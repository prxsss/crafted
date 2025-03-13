import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String title;
  String content;
  Timestamp createdAt;
  Timestamp updatedAt;
  String imageUrl;

  Post({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrl,
  });

  Post.fromJson(Map<String, Object?> json)
    : this(
        title: json['title']! as String,
        content: json['content']! as String,
        createdAt: json['createdAt']! as Timestamp,
        updatedAt: json['updatedAt']! as Timestamp,
        imageUrl: json['imageUrl']! as String,
      );

  Post copyWith({
    String? title,
    String? content,
    List<String>? tags,
    String? category,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    int? likesCount,
    int? viewsCount,
    int? commentsCount,
    String? imageUrl,
  }) {
    return Post(
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'imageUrl': imageUrl,
    };
  }
}
