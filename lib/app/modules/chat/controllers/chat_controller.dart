import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class ChatController extends GetxController {
  final searchController = TextEditingController();
  final messageController = TextEditingController();
  final isLoading = false.obs;
  final conversations = <Map<String, dynamic>>[].obs;
  final filteredConversations = <Map<String, dynamic>>[].obs;
  final messages = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Mock data exactly matching the design
      conversations.value = [
        {
          'id': '1',
          'name': 'Lisa',
          'avatar': 'assets/images/avatars/lisa.jpg',
          'lastMessage': 'Thanks a bunch! Have a great day! 😊',
          'time': '20:10 05/05/2024',
          'unread': 0,
        },
        {
          'id': '2',
          'name': 'Lavern',
          'avatar': 'assets/images/avatars/lavern.jpg',
          'lastMessage': 'Great, thanks so much! 👋',
          'time': '20:10 05/05/2024',
          'unread': 0,
        },
        {
          'id': '3',
          'name': 'Rey',
          'avatar': 'assets/images/avatars/rey.jpg',
          'lastMessage': 'Appreciate it! See you soon! 🚀',
          'time': '20:10 05/05/2024',
          'unread': 0,
        },
        {
          'id': '4',
          'name': 'Sylvia',
          'avatar': 'assets/images/avatars/sylvia.jpg',
          'lastMessage': 'Hooray! 🎉',
          'time': '20:10 05/05/2024',
          'unread': 0,
        },
        {
          'id': '5',
          'name': 'Gayle',
          'avatar': 'assets/images/avatars/gayle.jpg',
          'lastMessage': 'See you soon!',
          'time': '20:10 05/05/2024',
          'unread': 0,
        },
        {
          'id': '6',
          'name': 'Ignatius',
          'avatar': 'assets/images/avatars/ignatius.jpg',
          'lastMessage': 'Appreciate it!',
          'time': '20:10 05/05/2024',
          'unread': 0,
        },
        {
          'id': '7',
          'name': 'Lourdes',
          'avatar': 'assets/images/avatars/lourdes.jpg',
          'lastMessage': 'Hooray! 🎉',
          'time': '20:10 05/05/2024',
          'unread': 0,
        },
        {
          'id': '8',
          'name': 'Affie',
          'avatar': 'assets/images/avatars/affie.jpg',
          'lastMessage': 'Nice!',
          'time': '20:10 05/05/2024',
          'unread': 0,
        },
      ];

      filteredConversations.value = conversations;
    } catch (e) {
      print('Error loading conversations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      filteredConversations.value = conversations;
      return;
    }

    filteredConversations.value = conversations
        .where((conversation) =>
            conversation['name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            conversation['lastMessage']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
  }

  void onSearchTap() {
    // Implement advanced search functionality
  }

  void onNewChat() {
    Get.toNamed(AppRoutes.newChat);
  }

  void onConversationTap(Map<String, dynamic> conversation) {
    Get.toNamed(
      AppRoutes.chatDetail,
      arguments: conversation,
    );
  }

  void onCallTap() {
    // Implement call functionality
  }

  void onAttachmentTap() {
    // Implement attachment functionality
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final message = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': messageController.text,
      'time': DateTime.now(),
      'isMe': true,
    };

    messages.add(message);
    messageController.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    messageController.dispose();
    super.onClose();
  }
} 