import 'package:chys/app/core/const/app_image.dart';
import 'package:chys/app/core/utils/app_size.dart';
import 'package:chys/app/modules/signup/widgets/custom_text_field.dart';
import 'package:chys/app/widget/image/svg_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/chat_controller.dart';

class ChatDetailView extends GetView<ChatController> {
  const ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> chatUser = Get.arguments;

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
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        const NetworkImage("https://i.pravatar.cc/150?img=6"),
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMessage(
                  "Hey there! 👋",
                  "10:10",
                  isMe: false,
                ),
                _buildMessage(
                  "This is your friend kitty owner speaking. How was your day? 😊",
                  "10:10",
                  isMe: false,
                ),
                _buildMessage(
                  "Hi!",
                  "10:10",
                  isMe: true,
                ),
                _buildMessage(
                  "Awesome, thanks for letting me asking! Can't wait to meet kitty. 🐱",
                  "10:11",
                  isMe: true,
                ),
                _buildMessage(
                  "No problem at all!\nIt'll be there in about 15 minutes.",
                  "10:11",
                  isMe: false,
                ),
                _buildMessage(
                  "I'll text you when kitty is ready.",
                  "10:11",
                  isMe: false,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                  16), // if not circular, remove for full square
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.1), // slightly darker for visibility
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: Offset(0, 4), // subtle bottom shadow
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 1), // soft ambient top shadow
                ),
              ],
            ),
            child: Row(
              spacing: AppSize.h2,
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
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: AppImages.send.toSvg(
                        color:
                            Colors.white), // ensure white icon inside blue bg
                    onPressed: () => controller.sendMessage(),
                    iconSize: 20, // optional: tweak size
                    splashRadius: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
