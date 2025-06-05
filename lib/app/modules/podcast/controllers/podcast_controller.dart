import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PodcastController extends GetxController {
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final followers = <Map<String, dynamic>>[].obs;
  final filteredFollowers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFollowers();
  }

  Future<void> _loadFollowers() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Mock data
      followers.value = [
        {
          'id': '1',
          'name': 'Lisa',
          'avatar': 'assets/images/avatars/lisa.jpg',
          'location': 'Swaziland',
        },
        {
          'id': '2',
          'name': 'Lavern',
          'avatar': 'assets/images/avatars/lavern.jpg',
          'location': 'Honduras',
        },
        {
          'id': '3',
          'name': 'Rey',
          'avatar': 'assets/images/avatars/rey.jpg',
          'location': 'Virgin Islands, British',
        },
        {
          'id': '4',
          'name': 'Sylvia',
          'avatar': 'assets/images/avatars/sylvia.jpg',
          'location': 'Dominica',
        },
        {
          'id': '5',
          'name': 'Gayle',
          'avatar': 'assets/images/avatars/gayle.jpg',
          'location': 'Qatar',
        },
        {
          'id': '6',
          'name': 'Ignatius',
          'avatar': 'assets/images/avatars/ignatius.jpg',
          'location': 'Kyrgyz Republic',
        },
        {
          'id': '7',
          'name': 'Lourdes',
          'avatar': 'assets/images/avatars/lourdes.jpg',
          'location': 'Niger',
        },
      ];

      filteredFollowers.value = followers;
    } catch (e) {
      print('Error loading followers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      filteredFollowers.value = followers;
      return;
    }

    filteredFollowers.value = followers
        .where((follower) =>
            follower['name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            follower['location']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
  }

  Future<void> inviteFollower(Map<String, dynamic> follower) async {
    try {
      // TODO: Implement invite logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      Get.snackbar(
        'Success',
        'Invitation sent to ${follower['name']}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error inviting follower: $e');
      Get.snackbar(
        'Error',
        'Failed to send invitation. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
} 