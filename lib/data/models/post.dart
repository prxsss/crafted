import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String title;
  String content;
  List<String> tags;
  String category;
  Timestamp createdAt;
  Timestamp updatedAt;
  int likesCount;
  int viewsCount;
  int commentsCount;
  String imageUrl;

  Post({
    required this.title,
    required this.content,
    required this.tags,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.likesCount,
    required this.viewsCount,
    required this.commentsCount,
    required this.imageUrl,
  });

  Post.fromJson(Map<String, Object?> json)
    : this(
        title: json['title']! as String,
        content: json['content']! as String,
        tags: json['tags']! as List<String>,
        category: json['category']! as String,
        createdAt: json['createdAt']! as Timestamp,
        updatedAt: json['updatedAt']! as Timestamp,
        likesCount: json['likesCount']! as int,
        viewsCount: json['viewsCount']! as int,
        commentsCount: json['commentsCount']! as int,
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
      tags: tags ?? this.tags,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      commentsCount: commentsCount ?? this.commentsCount,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'content': content,
      'tags': tags,
      'category': category,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'likesCount': likesCount,
      'viewsCount': viewsCount,
      'commentsCount': commentsCount,
      'imageUrl': imageUrl,
    };
  }
}
