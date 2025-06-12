import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Posts {
  final String id;
  final String description;
  final List<String> media;
  final List<dynamic> likes;
  final int viewCount;
  final List<String> tags;
  final bool isActive;
  RxList<Map<String, dynamic>> comments;
  final String creatorId;
  final String createdAt;
  final String updatedAt;
  final int v;
  bool isCurrentUserLiked;

  Posts({
    required this.id,
    required this.description,
    required this.media,
    required this.likes,
    required this.viewCount,
    required this.tags,
    required this.isActive,
    required List<dynamic> comments,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
    required this.isCurrentUserLiked,
    required this.v,
  }) : comments =
            RxList<Map<String, dynamic>>(comments.cast<Map<String, dynamic>>());

  factory Posts.fromMap(Map<String, dynamic> map, String currentUserId) {
    final likesList = map['likes'] as List<dynamic>? ?? [];
    final isLiked = likesList.any((like) => like['_id'] == currentUserId);

    return Posts(
      id: map["_id"]?.toString() ?? '',
      description: map["description"]?.toString() ?? '',
      media: _safeStringList(map["media"]),
      likes: map["likes"] ?? [],
      isCurrentUserLiked: isLiked,
      viewCount: map["viewCount"] is int
          ? map["viewCount"]
          : int.tryParse(map["viewCount"]?.toString() ?? '') ?? 0,
      tags: _safeStringList(map["tags"]),
      isActive: map["isActive"] == true,
      comments: map["comments"] ?? [],
      creatorId: map["creator"] is Map<String, dynamic>
          ? map["creator"]["_id"]?.toString() ?? ''
          : '',
      createdAt: map["createdAt"]?.toString() ?? '',
      updatedAt: map["updatedAt"]?.toString() ?? '',
      v: map["__v"] is int
          ? map["__v"]
          : int.tryParse(map["__v"]?.toString() ?? '') ?? 0,
    );
  }

  static List<String> _safeStringList(dynamic list) {
    if (list is List) {
      return list.map((item) => item.toString()).toList();
    }
    return [];
  }
}
