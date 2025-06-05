import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../routes/app_routes.dart';

class MapController extends GetxController {
  GoogleMapController? mapController;
  final currentLocation = const LatLng(0, 0).obs;
  final markers = <Marker>{}.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
    _loadPetMarkers();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      currentLocation.value = LatLng(position.latitude, position.longitude);
      centerOnCurrentLocation();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _loadPetMarkers() async {
    try {
      isLoading.value = true;

      // Load and create custom markers for different pets
      final dogMarker = await _createCustomMarker(
        'assets/images/markers/dog_marker.png',
      );
      final catMarker = await _createCustomMarker(
        'assets/images/markers/cat_marker.png',
      );

      // Sample pet locations - Replace with actual data from your backend
      final pets = [
        {
          'id': '1',
          'type': 'dog',
          'location': const LatLng(40.7128, -74.0060),
          'name': 'Max',
          'image': 'assets/images/pets/dog1.jpg',
        },
        {
          'id': '2',
          'type': 'cat',
          'location': const LatLng(40.7129, -74.0061),
          'name': 'Luna',
          'image': 'assets/images/pets/cat1.jpg',
        },
        // Add more pets here
      ];

      // Create markers for each pet
      for (final pet in pets) {
        final marker = Marker(
          markerId: MarkerId(pet['id'] as String),
          position: pet['location'] as LatLng,
          icon: pet['type'] == 'dog' ? dogMarker : catMarker,
          onTap: () => _onMarkerTapped(pet['id'] as String),
          infoWindow: InfoWindow(
            title: pet['name'] as String,
            snippet: 'Tap to view profile',
          ),
        );
        markers.add(marker);
      }
    } catch (e) {
      print('Error loading markers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<BitmapDescriptor> _createCustomMarker(String assetPath) async {
    final ByteData byteData = await rootBundle.load(assetPath);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    final codec = await ui.instantiateImageCodec(
      uint8List,
      targetHeight: 120,
      targetWidth: 120,
    );

    final frame = await codec.getNextFrame();
    final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  void _onMarkerTapped(String petId) {
    // Navigate to pet profile or show bottom sheet
    print('Pet tapped: $petId');
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
  void onAddPetTap() => Get.toNamed(AppRoutes.addPet);
  void onProfileTap() => Get.toNamed(AppRoutes.profile);
  void onPetsTap() => Get.toNamed(AppRoutes.pets);
  void onChatTap() => Get.toNamed(AppRoutes.chat);

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }
}
