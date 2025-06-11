class Posts {
  final String id;
  final String description;
  final List<String> media;
  final List<String> likes;
  final int viewCount;
  final List<String> tags;
  final bool isActive;
  final List<String> comments;
  final String creatorId;
  final String createdAt;
  final String updatedAt;
  final int v;

  Posts({
    required this.id,
    required this.description,
    required this.media,
    required this.likes,
    required this.viewCount,
    required this.tags,
    required this.isActive,
    required this.comments,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Posts.fromMap(Map<String, dynamic> map) {
    return Posts(
      id: map["_id"]?.toString() ?? '',
      description: map["description"]?.toString() ?? '',
      media: _safeStringList(map["media"]),
      likes: _safeStringList(map["likes"]),
      viewCount: map["viewCount"] is int ? map["viewCount"] : int.tryParse(map["viewCount"]?.toString() ?? '') ?? 0,
      tags: _safeStringList(map["tags"]),
      isActive: map["isActive"] == true,
      comments: _safeStringList(map["comments"]),
      creatorId: map["creator"] is Map<String, dynamic> ? map["creator"]["_id"]?.toString() ?? '' : '',
      createdAt: map["createdAt"]?.toString() ?? '',
      updatedAt: map["updatedAt"]?.toString() ?? '',
      v: map["__v"] is int ? map["__v"] : int.tryParse(map["__v"]?.toString() ?? '') ?? 0,
    );
  }

  static List<String> _safeStringList(dynamic list) {
    if (list is List) {
      return list.map((item) => item.toString()).toList();
    }
    return [];
  }
}
