import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final isLoading = false.obs;
  final notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      isLoading.value = true;
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock notifications data
      notifications.value = [
        {
          'id': 1,
          'type': 'alert',
          'title': 'Lost Pet Alert',
          'message': 'A dog matching Max\'s description was spotted nearby.',
          'time': '2 minutes ago',
          'read': false,
        },
        {
          'id': 2,
          'type': 'message',
          'title': 'New Message',
          'message': 'Sarah sent you a message about Luna.',
          'time': '1 hour ago',
          'read': true,
        },
        {
          'id': 3,
          'type': 'friend',
          'title': 'New Friend Request',
          'message': 'John wants to connect with you.',
          'time': '2 hours ago',
          'read': false,
        },
        {
          'id': 4,
          'type': 'alert',
          'title': 'Vaccination Reminder',
          'message': 'Luna\'s vaccination is due next week.',
          'time': '1 day ago',
          'read': true,
        },
        {
          'id': 5,
          'type': 'message',
          'title': 'Community Update',
          'message': 'Check out the new pet-friendly parks in your area!',
          'time': '2 days ago',
          'read': true,
        },
      ];
    } catch (e) {
      print('Error loading notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification['read'] = true;
    }
    notifications.refresh();
  }

  void deleteNotification(int id) {
    notifications.removeWhere((notification) => notification['id'] == id);
  }

  void onNotificationTap(Map<String, dynamic> notification) {
    // Mark as read
    final index = notifications.indexWhere((n) => n['id'] == notification['id']);
    if (index != -1) {
      notifications[index]['read'] = true;
      notifications.refresh();
    }

    // Handle notification tap based on type
    switch (notification['type']) {
      case 'alert':
        // Navigate to alert details
        break;
      case 'message':
        // Navigate to chat
        break;
      case 'friend':
        // Navigate to friend profile
        break;
      default:
        // Handle other types
        break;
    }
  }
} 