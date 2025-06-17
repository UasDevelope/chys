import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chys/app/core/const/app_image.dart';
import 'package:chys/app/core/const/app_text.dart';
import 'package:chys/app/core/utils/app_size.dart';
import 'package:chys/app/data/models/post.dart';
import 'package:chys/app/data/models/story.dart';
import 'package:chys/app/modules/%20home/petGallery.dart';
import 'package:chys/app/modules/%20home/story_view.dart';
import 'package:chys/app/modules/%20home/widget/custom_header.dart';
import 'package:chys/app/modules/%20home/widget/floating_action_button.dart';
import 'package:chys/app/modules/adored_posts/controller/controller.dart';
import 'package:chys/app/routes/app_routes.dart';
import 'package:chys/app/services/custom_Api.dart';
import 'package:chys/app/widget/image/svg_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../map/controllers/map_controller.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  final contrroller = Get.put(AddoredPostsController());
  final storyController = Get.put(HomeController());
  final CustomApiService _apiService = Get.put(CustomApiService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSize.h2,
                children: [
                  SizedBox(
                    height: AppSize.h2,
                  ),
                  buildCustomHeader(),
                  SizedBox(
                    height: AppSize.getHeight(
                        100), // Adjusted to show both avatar + name
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: _apiService
                          .getRequest('story/public')
                          .then((res) => res as Map<String, dynamic>),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading stories'));
                        }

                        if (!snapshot.hasData ||
                            snapshot.data!['success'] != true) {
                          return const SizedBox.shrink();
                        }

                        final List<dynamic> storiesData =
                            snapshot.data!['data'];
                        final List<UserStory> userStories = storiesData
                            .map((story) => UserStory.fromMap(story))
                            .toList();

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              userStories.length + 1, // +1 for Add Story button
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // Add Story Button
                              return GestureDetector(
                                onTap: () {
                                  // Navigate to Add Story page or trigger story upload
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.grey,
                                          child: const Icon(Icons.add,
                                              color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      const AppText(text: "Add Story"),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final userStory = userStories[index - 1];
                            final hasStories = userStory.stories.isNotEmpty;
                            final latestStory =
                                hasStories ? userStory.stories.first : null;

                            return GestureDetector(
                              onTap: () {
                                final storyMediaUrls = userStory.stories
                                    .map((s) => s.mediaUrl)
                                    .toList();

                                Get.to(() => StoryPreviewPage(
                                      mediaUrls: storyMediaUrls,
                                      userName: userStory.userName,
                                    ));
                                // TODO: Show story using `story_view` package
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey.shade300,
                                        backgroundImage: latestStory != null
                                            ? NetworkImage(latestStory.mediaUrl)
                                            : null,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    AppText(
                                      text: userStory.userName,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Obx(() => contrroller.isLoading.value
                      ? const CircularProgressIndicator()
                      : ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          // padding: const EdgeInsets.all(16),
                          itemCount: contrroller.posts.length,
                          itemBuilder: (context, index) {
                            return CatQuoteCard(
                                posts: contrroller.posts[index],
                                addoredPostsController: contrroller,
                                onTapLove: () {
                                  log("Like tap");
                                  contrroller
                                      .likePost(contrroller.posts[index].id);
                                },
                                onTapShare: () {
                                  contrroller
                                      .sharePost(contrroller.posts[index]);
                                },
                                onTapPaw: () {},
                                onTapMessage: () {
                                  final controller =
                                      Get.find<AddoredPostsController>();
                                  controller.showCommentsBottomSheet(
                                      controller.posts[index]);
                                });
                          }))
                ],
              ),
            ),
          ),
          // See All Posts
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Get.to(PetGalleryScreen());
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFff9a9e), Color(0xFFfad0c4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.explore, color: Colors.white, size: 20),
                    const SizedBox(width: 6),
                    const Text(
                      'See All Posts',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          CustomFloatingActionButton(controller: Get.find<MapController>()),
          UserMapButtons(
              bottom: AppSize.getHeight(10),
              right: AppSize.getHeight(14),
              controller: Get.find<MapController>()),
        ],
      ),
    );
  }
}

class CatQuoteCard extends StatelessWidget {
  Posts posts;
  AddoredPostsController addoredPostsController;
  final VoidCallback? onTapCard;
  final VoidCallback? onTapPaw;
  final VoidCallback? onTapMessage;
  final VoidCallback? onTapShare;
  final VoidCallback? onTapLove;

  CatQuoteCard({
    required this.posts,
    required this.addoredPostsController,
    this.onTapCard,
    this.onTapPaw,
    this.onTapMessage,
    this.onTapShare,
    this.onTapLove,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 400,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(24),
        //   image: const DecorationImage(
        //     image: NetworkImage(
        //         'https://www.gstatic.com/flutter-onestack-prototype/genui /example_1.jp g'),
        //     // Placeholder
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Stack(
          children: [
            // See All Posts Button

            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CarouselSlider(
                items: posts.media.map((url) {
                  return Image.network(url,
                      fit: BoxFit.cover, width: double.infinity);
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  height: 400,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  onPageChanged: (index, reason) {
                    addoredPostsController.updateIndex(index);
                  },
                ),
              ),
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Text content
            Positioned(
              left: 20,
              right: 80,
              bottom: 80,
              child: Text(
                posts.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // User Info
            Positioned(
              left: 20,
              bottom: 20,
              child: InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.profile, arguments: posts.creatorId);
                },
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/150?img=12'),
                      radius: 18,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kitty Jenna",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "STUTTGART",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Floating Buttons
            Positioned(
              right: 10,
              top: AppSize.h10,
              child: Column(
                children: [
                  _circleIcon(AppImages.paw, onTapPaw),
                  const SizedBox(height: 12),
                  _circleIcon(AppImages.message, onTapMessage),
                  const SizedBox(height: 12),
                  _circleIcon(AppImages.share, onTapShare),
                  const SizedBox(height: 12),
                  _circleIcon(AppImages.love, onTapLove,
                      bgColor: posts.isCurrentUserLiked ? Colors.red : null),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _circleIcon(
    String icon,
    VoidCallback? onTap, {
    Color? bgColor,
  }) {
    final Color finalBgColor = bgColor ?? Colors.white.withOpacity(0.6);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: finalBgColor,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: onTap,
          icon: icon.toSvg(),
          color: Colors.black87,
        ),
      ),
    );
  }
}
