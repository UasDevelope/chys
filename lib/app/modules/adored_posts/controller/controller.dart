import 'dart:developer';

import 'package:chys/app/data/models/post.dart';
import 'package:chys/app/services/custom_Api.dart';
import 'package:get/get.dart';

class AddoredPostsController extends GetxController {
  final CustomApiService customApiService = CustomApiService();
  final RxList<Posts> posts = <Posts>[].obs;
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
      var response = await customApiService.getRequest("/posts");
      log("Response for fetching posts is ${response}");
      final List<dynamic> postsData = response["posts"];
      posts.value = postsData.map((e) => Posts.fromMap(e)).toList();
    } catch (e) {
      log("Error fetching adored posts: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
