import 'package:carousel_slider/carousel_slider.dart';
import 'package:chys/app/core/const/app_image.dart';
import 'package:chys/app/core/const/app_text.dart';
import 'package:chys/app/core/utils/app_size.dart';
import 'package:chys/app/data/models/post.dart';
import 'package:chys/app/modules/%20home/widget/custom_header.dart';
import 'package:chys/app/modules/%20home/widget/floating_action_button.dart';
import 'package:chys/app/modules/adored_posts/controller/controller.dart';
import 'package:chys/app/routes/app_routes.dart';
import 'package:chys/app/widget/image/svg_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../map/controllers/map_controller.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  final contrroller = Get.put(AddoredPostsController());
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
                    height:
                        AppSize.getHeight(10), // total height including text
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final imageUrl =
                            'https://picsum.photos/200?random=$index';

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: index == 0
                                            ? null
                                            : Border.all(
                                                color: Colors.blue, width: 5),
                                      ),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(imageUrl),
                                        backgroundColor: Colors.grey.shade300,
                                      ),
                                    ),
                                    if (index == 0)
                                      Positioned(
                                        bottom: -2,
                                        right: -2,
                                        child: Container(
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              const AppText(text: "My Story"),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Obx(
                    () => ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        // padding: const EdgeInsets.all(16),
                        itemCount: contrroller.posts.length,
                        itemBuilder: (context, index) {
                          contrroller.fetchAdoredPosts();
                          return CatQuoteCard(
                            posts: contrroller.posts[index],
                            addoredPostsController: contrroller,
                          );
                        }),
                  )
                ],
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
  CatQuoteCard({required this.posts, required this.addoredPostsController});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.toNamed(AppRoutes.homeDetail);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 400,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(24),
        //   image: const DecorationImage(
        //     image: NetworkImage(
        //         'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg'),
        //     // Placeholder
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CarouselSlider(
                items: posts.media.map((url) {
                  return Image.network(
                    url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // User Info
            const Positioned(
              left: 20,
              bottom: 20,
              child: Row(
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

            // Floating Buttons
            Positioned(
              right: 10,
              top: AppSize.h10,
              child: Column(
                children: [
                  _circleIcon(AppImages.paw),
                  const SizedBox(height: 12),
                  _circleIcon(AppImages.message),
                  const SizedBox(height: 12),
                  _circleIcon(AppImages.share),
                  const SizedBox(height: 12),
                  _circleIcon(AppImages.love),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _circleIcon(String icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {},
        icon: icon.toSvg(),
        color: Colors.black87,
      ),
    );
  }
}
