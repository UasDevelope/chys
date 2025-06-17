import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryPreviewPage extends StatelessWidget {
  final List<String> mediaUrls;
  final String userName;

  StoryPreviewPage({
    Key? key,
    required this.mediaUrls,
    required this.userName,
  }) : super(key: key);

  final StoryController _storyController = StoryController();

  @override
  Widget build(BuildContext context) {
    final List<StoryItem> storyItems = mediaUrls.map((url) {
      final isVideo = url.endsWith(".mp4") || url.contains("video");
      return isVideo
          ? StoryItem.pageVideo(
        url,
        controller: _storyController,
        caption: Text(userName),
      )
          : StoryItem.pageImage(
        url: url,
        controller: _storyController,
        caption: Text(userName),
        duration: const Duration(seconds: 5),
      );
    }).toList();

    return Scaffold(
      body: StoryView(
        storyItems: storyItems,
        controller: _storyController,
        onComplete: () => Navigator.pop(context),
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
