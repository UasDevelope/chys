import 'dart:developer';
import 'dart:io';

import 'package:chys/app/core/const/app_text.dart';
import 'package:chys/app/data/models/post.dart';
import 'package:chys/app/modules/profile/controllers/profile_controller.dart';
import 'package:chys/app/services/custom_Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AddoredPostsController extends GetxController {
  final CustomApiService customApiService = CustomApiService();
  final RxList<Posts> posts = <Posts>[].obs;
  final TextEditingController commentController = TextEditingController();

  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

  void updateIndex(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    fetchAdoredPosts(); // Auto-fetch posts on controller init
  }

  Future<void> fetchAdoredPosts() async {
    try {
      isLoading.value = true;

      var response = await customApiService.getRequest("posts");
      log("Response for fetching posts is ${response}");
      final controller = Get.find<ProfileController>();
      final List<dynamic> postsData = response["posts"];

      posts.value = postsData
          .map((e) => Posts.fromMap(e, controller.profile.value!.id))
          .toList();
    } catch (e) {
      log("Error fetching adored posts: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> likePost(String postId) async {
    try {
      log("Post id is ${postId}");
      await EasyLoading.show(
        status: 'Processing your like...',
        maskType: EasyLoadingMaskType.black,
      );
      var response =
          await customApiService.postRequest("posts/$postId/like", {});
      log("Response for like post is $response");
      final index = posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        posts[index].isCurrentUserLiked = !posts[index].isCurrentUserLiked;
        posts.refresh();
      }
    } catch (e) {
      log("Error liking post: $e");
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> commentOnPost(String postId, Posts post) async {
    try {
      if (commentController.text.trim().isEmpty) {
        await EasyLoading.showError("Comment is empty");
        return;
      }

      await EasyLoading.show(
        status: 'Adding comment...',
        maskType: EasyLoadingMaskType.black,
      );

      final response = await customApiService.postRequest(
        "posts/$postId/comment",
        {"message": commentController.text.trim()},
      );

      log("Response for comment post is $response");

      final newComment = {
        "message": commentController.text.trim(),
        "createdAt": DateTime.now().toIso8601String(),
        "user": {"_id": Get.find<ProfileController>().profile.value!.id},
        "_id": response["_id"] ?? DateTime.now().toIso8601String(),
      };

      post.comments.add(newComment);
      commentController.clear();
    } catch (e) {
      log("Error posting comment: $e");
    } finally {
      await EasyLoading.dismiss();
    }
  }

  void sharePost(Posts post) async {
    try {
      final String contentToShare = '''
${post.description ?? ''}

Shared via CHYS app
''';

      XFile? previewFile;

      // If there's a media file (assuming it's a URL to an image)
      if (post.media.isNotEmpty) {
        final mediaUrl = post.media[0];

        // Download the image and convert to XFile
        final response = await http.get(Uri.parse(mediaUrl));
        final bytes = response.bodyBytes;

        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/shared_preview.jpg');
        await file.writeAsBytes(bytes);

        previewFile = XFile(file.path);
      }

      await SharePlus.instance.share(
        ShareParams(
          text: contentToShare,
          previewThumbnail: previewFile,
        ),
      );
    } catch (e) {
      log("Error sharing post: $e");
      EasyLoading.showError("Failed to share post");
    }
  }

  void showCommentsBottomSheet(Posts post) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        height: Get.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const AppText(
              text: 'Comments',
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (post.comments.isEmpty) {
                  return const Center(
                    child: Text('No comments yet.'),
                  );
                }
                return ListView.builder(
                  itemCount: post.comments.length,
                  itemBuilder: (_, index) {
                    final comment = post.comments[index];
                    return ListTile(
                      title: Text(comment['message'] ?? ''),
                      subtitle: Text(comment['createdAt']?.toString() ?? ''),
                    );
                  },
                );
              }),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () => commentOnPost(post.id, post),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
