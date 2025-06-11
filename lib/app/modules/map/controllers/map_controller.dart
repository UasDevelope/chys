import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:chys/app/data/models/pet_profile.dart';
import 'package:chys/app/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/map_utils.dart';
import '../../../routes/app_routes.dart';

class MapController extends GetxController {
  GoogleMapController? mapController;
  final currentLocation = const LatLng(0, 0).obs;
  final markers = <Marker>{}.obs;
  final isLoading = false.obs;
  var petList = <PetModel>[].obs;
  var nearbyPetList = <PetModel>[].obs;
  var isDataLoading = false.obs;
  var isNearbyPetLoading = false.obs;
  RxString selectedFeature = ''.obs; // e.g. 'chat', 'add', etc.
  RxInt currentIndex = 0.obs;
  Timer? autoSlideTimer;

  void startAutoSlide(int maxIndex) {
    autoSlideTimer?.cancel();
    autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      currentIndex.value = (currentIndex.value + 1) % maxIndex;
    });
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition();
        currentLocation.value = LatLng(position.latitude, position.longitude);
        log("Current location is $currentLocation");
        centerOnCurrentLocation();
      } else {
        Get.snackbar(
          'Permission Denied',
          'Location access is required to use the map.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  void onMapCreated(GoogleMapController controller) {
    log("Come here");
    mapController = controller;
    centerOnCurrentLocation();

    mapController!.setMapStyle(MapUtils.lightMode);
  }

  Future<void> fetchPetProfile({String? petId}) async {
    try {
      isDataLoading.value = true;

      // Build URL conditionally
      String url = petId == null || petId.isEmpty
          ? ApiEndPoints.petProfile
          : "${ApiEndPoints.petProfile}/$petId";

      final response = await ApiClient().get(url);
      final pet = PetModel.fromJson(response["pet"]);
      petList.value = [pet];
    } catch (e) {
      log("Error is $e");
    } finally {
      isDataLoading.value = false;
    }
  }

  Future<void> fetchNearbyPet() async {
    isNearbyPetLoading.value = true;

    try {
      // Wait until the location is available (with retry + timeout)
      int retries = 0;
      while (currentLocation.value.latitude == 0.0 && retries < 5) {
        log("Waiting for valid location... Attempt ${retries + 1}");
        await Future.delayed(const Duration(seconds: 1));
        retries++;
      }

      if (currentLocation.value.latitude == 0.0) {
        log("Location not available after retries");
        nearbyPetList.value = [];
        return;
      }

      final response = await ApiClient().get(
        "${ApiEndPoints.nearbyPet}/?lat=${currentLocation.value.latitude}&lng=${currentLocation.value.longitude}",
      );

      if (response != null && response['pets'] != null) {
        final petsJson = response['pets'] as List;
        log("Pets json is $petsJson");

        final List<PetModel> nearbyPets =
            petsJson.map((petJson) => PetModel.fromJson(petJson)).toList();

        nearbyPetList.value = nearbyPets;
        _loadPetMarkers();
      } else {
        nearbyPetList.value = [];
      }
    } catch (e) {
      log("Error is==> $e");
      nearbyPetList.value = [];
    } finally {
      isNearbyPetLoading.value = false;
    }
  }

  void selectFeature(String feature) {
    selectedFeature.value = feature;
    switch (feature) {
      case 'chat':
        onChatTap();
        break;
      case 'add':
        onAddPetTap();
        break;
      case 'user':
        onProfileTap();
        break;
      case 'podcast':
        onPetsTap();
        break;
      case 'map':
        centerOnCurrentLocation();
        break;
    }
  }

  Future<void> _loadPetMarkers() async {
    markers.clear();
    Set<String> usedLocations = {};
    log("Length is ${nearbyPetList.length}");
    for (final pet in nearbyPetList) {
      final location = pet.userModel?.location?.coordinates;
      final petName = pet.name ?? 'Unknown';
      final profileUrl = pet.profilePic ?? '';
      final petId = pet.id ?? '';

      if (location != null && location.length == 2) {
        double lng = location[0];
        double lat = location[1];

        // Offset step for overlapping markers
        const double offsetStep = 0.0003;
        String locKey = '$lat:$lng';
        int offsetIndex = 1;
        while (usedLocations.contains(locKey)) {
          lat += offsetStep * offsetIndex;
          lng += offsetStep * offsetIndex;
          locKey = '$lat:$lng';
          offsetIndex++;
        }

        usedLocations.add(locKey);

        final Uint8List markerIcon =
            await _getBytesFromNetworkImage(profileUrl);

        final Marker marker = Marker(
            markerId: MarkerId(pet.id ?? UniqueKey().toString()),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.bytes(markerIcon),
            infoWindow: InfoWindow(title: petName),
            onTap: () {
              log("Pet id is $petId");

              Get.toNamed(AppRoutes.homeDetail, arguments: petId);
            });

        markers.add(marker);
      }
    }
  }

  Future<Uint8List> _getBytesFromNetworkImage(String imageUrl,
      {int size = 80}) async {
    try {
      final http.Response response = await http.get(Uri.parse(imageUrl));
      final Uint8List imageData = response.bodyBytes;
      final ui.Codec codec = await ui.instantiateImageCodec(imageData,
          targetWidth: size, targetHeight: size);
      final ui.FrameInfo fi = await codec.getNextFrame();
      final ui.Image image = fi.image;

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      final Paint paint = Paint();

      final double radius = size / 2;
      final Rect rect = Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble());

      // Draw circular clip path
      canvas.drawCircle(Offset(radius, radius), radius, paint);
      paint.blendMode = BlendMode.srcIn;

      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        rect,
        paint,
      );

      final ui.Image circularImage =
          await recorder.endRecording().toImage(size, size);
      final ByteData? byteData =
          await circularImage.toByteData(format: ui.ImageByteFormat.png);

      return byteData!.buffer.asUint8List();
    } catch (e) {
      print('Error loading/cropping image: $e');
      // Return a transparent placeholder if needed
      return Uint8List(0);
    }
  }

  void centerOnCurrentLocation() {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation.value, 15),
      );
    }
  }

  // Action button handlers
  void onSettingsTap() => Get.toNamed(AppRoutes.settings);
  void onNotificationsTap() => Get.toNamed(AppRoutes.notifications);
  void onAddPetTap() => Get.toNamed(AppRoutes.addPost);
  void onProfileTap() => Get.toNamed(AppRoutes.invitePodcast);
  void onPetsTap() => Get.toNamed(AppRoutes.home);
  void onChatTap() => Get.toNamed(AppRoutes.chat);

  @override
  void onClose() {
    mapController?.dispose();
    autoSlideTimer?.cancel();
    super.onClose();
  }
}
