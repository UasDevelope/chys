import 'package:chys/app/core/const/app_text.dart';
import 'package:chys/app/core/utils/app_size.dart';
import 'package:chys/app/modules/signup/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

class ChatListView extends GetView<ChatController> {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: CustomTextField(
                hintColor: Colors.white,
                label: "Search",
                controller: TextEditingController(),
                onChanged: controller.onSearchChanged,
                fillColor: Colors.grey.withValues(alpha: 0.3),
                borderColor: Colors.transparent,
              ),
            ),

            // Chat List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.conversations.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: AppSize.h4),
                  itemBuilder: (context, index) {
                    final chat = controller.conversations[index];
                    return _buildChatTile(chat);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTile(Map<String, dynamic> chat) {
    final user = chat['user'] ?? {};
    final String name = user['name'] ?? 'Unknown';
    final String lastMessage = chat['lastMessage'] ?? '';
    final DateTime? timestamp = DateTime.tryParse(chat['timestamp'] ?? '');
    final String timeText = timestamp != null
        ? "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}"
        : '';

    return InkWell(
      onTap: () => controller.onConversationTap(chat),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=6"),
          ),
          const SizedBox(width: 12),

          // Message Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      timeText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Last Message
                AppText(
                  text: lastMessage,
                  fontSize: 14,
                  color: Colors.grey[600]!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
