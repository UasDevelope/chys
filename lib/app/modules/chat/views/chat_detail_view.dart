import 'dart:developer';

import 'package:chys/app/core/const/app_image.dart';
import 'package:chys/app/core/utils/app_size.dart';
import 'package:chys/app/modules/signup/widgets/custom_text_field.dart';
import 'package:chys/app/services/date_time_service.dart';
import 'package:chys/app/widget/image/svg_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/chat_controller.dart';

class ChatDetailView extends GetView<ChatController> {
  ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> chatUser = Get.arguments;
    log("Chat user is $chatUser");

    controller.receiverId.value = chatUser['id'];
    controller.loadChat();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 4), // shadow position
              ),
            ],
          ),
          child: SafeArea(
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0, // keep AppBar itself flat
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Get.back(),
              ),
              title: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage("https://i.pravatar.cc/150?img=6"),
                  ),
                  SizedBox(width: AppSize.h2),
                  Text(
                    chatUser['name'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isChatLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              Expanded(
                child: controller.messages.isEmpty
                    ? const Center(child: Text("No messages yet"))
                    : ListView.builder(
                        controller: controller.scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.messages.length,
                        itemBuilder: (context, index) {
                          final message = controller.messages[index];
                          final isMe = message['senderId'] ==
                              controller.profileController.profile.value?.id;

                          return _buildMessage(
                            message['message'],
                            DateTimeService.formatTime(message['timestamp']),
                            isMe: isMe,
                          );
                        },
                      ),
              ),
              // ✅ Always show message input at bottom
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: "Type a message",
                        controller: controller.messageController,
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: AppImages.send.toSvg(color: Colors.white),
                        onPressed: () => controller.sendPrivateMessage(
                            controller.profileController.profile.value?.id ??
                                ""),
                        iconSize: 20,
                        splashRadius: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildMessage(String text, String time, {required bool isMe}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Get.width * 0.7, // prevent stretching to full width
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? AppColors.blue : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 16),
                ),
                boxShadow: [
                  if (!isMe)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // soft shadow
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(2, 4),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      time,
                      style: TextStyle(
                        color: isMe ? Colors.white70 : Colors.grey[500],
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
