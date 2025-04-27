import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitkat_social_app/features/posts/domain/entities/comment.dart';

class Post {
  final String id;
  final String userId;
  final String name;
  final String text;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes; // store uids
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userId,
    required this.name,
    required this.imageUrl,
    required this.text,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  Post copyWith({String? imageUrl}) {
    return Post(
      id: id,
      userId: userId,
      name: name,
      imageUrl: imageUrl ?? this.imageUrl,
      text: text,
      timestamp: timestamp,
      likes: likes,
      comments: comments,
    );
  }

  // Convert post -> json
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "name": name,
      "imageUrl": imageUrl,
      "text": text,
      "timestamp": Timestamp.fromDate(timestamp),
      "likes": likes,
      "comments": comments.map((comment) => comment.toJson()).toList(),
    };
  }

  // json -> post
  factory Post.fromJson(Map<String, dynamic> json) {
    // Robustly parse comments list
    final List<Comment> comments =
        (json["comments"] is List)
            ? (json["comments"] as List)
                .map((c) => Comment.fromJson(c))
                .toList()
            : [];

    return Post(
      id: json["id"],
      userId: json["userId"],
      name: json["name"],
      imageUrl: json["imageUrl"],
      text: json["text"],
      timestamp: (json["timestamp"] as Timestamp).toDate(),
      likes: List<String>.from(json["likes"] ?? []),
      comments: comments,
    );
  }
}
