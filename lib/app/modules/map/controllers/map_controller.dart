import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:chys/app/data/models/pet_profile.dart';
import 'package:chys/app/services/http_service.dart';
import 'package:flutter/material.dart';
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
  var isDataLoading = false.obs;
  RxString selectedFeature = ''.obs; // e.g. 'chat', 'add', etc.

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
    fetchPetProfile();
  }

  void onMapCreated(GoogleMapController controller) {
    log("Come here");
    mapController = controller;
    centerOnCurrentLocation();

    mapController!.setMapStyle(MapUtils.lightMode);
    _loadPetMarkers();
  }

  Future<void> fetchPetProfile() async {
    try {
      isDataLoading.value = true;
      final response = await ApiClient().get(ApiEndPoints.petProfile);
      final pet = PetModel.fromJson(response);
      petList.value = [pet];
    } catch (e) {
      log("Error is $e");
    } finally {
      isDataLoading.value = false;
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
    try {
      isLoading.value = true;

      final position = await Geolocator.getCurrentPosition();
      final baseLat = position.latitude;
      final baseLng = position.longitude;
      debugPrint("Base lat: $baseLat, Base lng: $baseLng");

      final imageUrls = [
        'https://i.pravatar.cc/150?img=3',
        'https://i.pravatar.cc/150?img=4',
        'https://i.pravatar.cc/150?img=5',
        'https://i.pravatar.cc/150?img=6',
      ];

      for (int i = 0; i < imageUrls.length; i++) {
        final BitmapDescriptor? customIcon =
            await _getCircularBitmapDescriptor(imageUrls[i], size: 150);

        final marker = Marker(
          markerId: MarkerId('avatar_$i'),
          position: LatLng(
            baseLat + 0.002 * i,
            baseLng + 0.003 * i,
          ),
          icon: customIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: 'User ${i + 1}',
          ),
          onTap: () {
            Get.toNamed(AppRoutes.homeDetail);
          },
        );

        markers.add(marker);
        markers.refresh();
      }
    } catch (e) {
      debugPrint('Error loading markers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<BitmapDescriptor?> _getCircularBitmapDescriptor(String imageUrl,
      {int size = 150}) async {
    try {
      final http.Response response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final Uint8List imageBytes = response.bodyBytes;

        final ui.Codec codec = await ui.instantiateImageCodec(
          imageBytes,
          targetWidth: size,
          targetHeight: size,
        );
        final ui.FrameInfo frameInfo = await codec.getNextFrame();
        final ui.Image image = frameInfo.image;

        final ui.PictureRecorder recorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(recorder);
        final Paint paint = Paint()..isAntiAlias = true;
        final double radius = size / 2;

        // Draw circular clip
        canvas.drawCircle(Offset(radius, radius), radius, paint);

        // Draw the image within the circular clip
        paint.shader = ImageShader(
          image,
          TileMode.clamp,
          TileMode.clamp,
          Matrix4.identity().storage,
        );
        canvas.drawCircle(Offset(radius, radius), radius, paint);

        final ui.Image finalImage =
            await recorder.endRecording().toImage(size, size);
        final ByteData? byteData =
            await finalImage.toByteData(format: ui.ImageByteFormat.png);

        return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
      }
    } catch (e) {
      debugPrint('Error creating circular bitmap: $e');
    }
    return null;
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
    super.onClose();
  }
}
