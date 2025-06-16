import 'dart:developer';

import 'package:chys/app/modules/profile/controllers/profile_controller.dart';
import 'package:chys/app/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../services/chat_services.dart';

class ChatController extends GetxController {
  final searchController = TextEditingController();
  final messageController = TextEditingController();
  final profileController = Get.find<ProfileController>();
  final SocketService _socketService = Get.put(SocketService());
  final isLoading = false.obs;
  final RxBool isChatLoading = false.obs;
  final conversations = <Map<String, dynamic>>[].obs;
  final filteredConversations = <Map<String, dynamic>>[].obs;
  final messages = <Map<String, dynamic>>[].obs;
  RxString receiverId = "".obs;
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _loadConversations();
    _socketService.initSocket();
    _socketService.listenToPrivateMessages(_onPrivateMessageReceived);
  }

  Future<void> _loadConversations() async {
    try {
      isLoading.value = true;
      final response = await ApiClient().get("/chat/get/users");
      log("Response for chat is ${response}");
      conversations.assignAll(List<Map<String, dynamic>>.from(response));
      filteredConversations.value = conversations;
    } catch (e) {
      print('Error loading conversations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> loadChat() async {
    try {
      isChatLoading.value = true;
      final response = await ApiClient().get("/chat/${receiverId.value}");
      log("Response for chat is ${response}");
      messages.assignAll(List<Map<String, dynamic>>.from(response));
      scrollToBottom();
    } finally {
      isChatLoading.value = false;
    }
  }

  void _onPrivateMessageReceived(Map<String, dynamic> data) {
    log("📥 Private message listener received: $data");

    final senderId = data["senderId"];
    final receiverIdData = data["receiverId"];
    final messageText = data["message"];
    final timestamp =
        DateTime.tryParse(data["timestamp"] ?? '') ?? DateTime.now();

    // Check if message already exists in list
    final isDuplicate = messages.any((msg) =>
        msg['senderId'] == senderId &&
        msg['receiverId'] == receiverIdData &&
        msg['message'] == messageText &&
        (msg['timestamp'] as DateTime).difference(timestamp).inSeconds.abs() <
            2);

    if (!isDuplicate) {
      if (senderId == Get.find<ProfileController>().profile.value?.id) {
        messages.add({
          'senderId': senderId,
          'receiverId': receiverIdData,
          'message': messageText,
          'timestamp': timestamp,
        });

        log("🆕 Message added to messages: ${messages.last}");
        scrollToBottom();
      }
    } else {
      log("⚠️ Duplicate message ignored");
    }
  }

  void sendPrivateMessage(String senderId) {
    if (messageController.text.trim().isEmpty) return;

    final text = messageController.text;
    messageController.clear();

    log("After adding message ${messages.last}");
    messages.add({
      'senderId': senderId,
      'receiverId': receiverId.value,
      'message': text,
      'timestamp': DateTime.now(),
    });
    _socketService.sendPrivateMessage(receiverId.value, text);
    scrollToBottom();
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
      arguments: {
        "id": conversation["user"]["_id"],
        "name": conversation["user"]["name"]
      },
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
