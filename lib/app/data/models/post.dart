class Post {
  final String id;
  final String description;
  final List<String> mediaUrls;
  final String userId;
  final DateTime createdAt;
  final int likes;
  final int comments;

  Post({
    required this.id,
    required this.description,
    required this.mediaUrls,
    required this.userId,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      description: json['description'] ?? '',
      mediaUrls: List<String>.from(json['media'] ?? []),
      userId: json['userId'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'media': mediaUrls,
    };
  }
} 