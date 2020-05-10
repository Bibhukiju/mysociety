import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;

  Post(
      {this.postId,
      this.ownerId,
      this.username,
      this.description,
      this.likes,
      this.location,
      this.mediaUrl});
  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc["postId"],
      ownerId: doc["ownerId"],
      username: doc["username"],
      location: doc["location"],
      description: doc["description"],
      mediaUrl: doc["mediaurl"],
      likes: doc["likes"],
    );
  }
  int getLikesCount(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
      postId: this.postId,
      ownerId: this.ownerId,
      username: this.username,
      mediaUrl: this.mediaUrl,
      location: this.location,
      description: this.description,
      likes: this.likes,
      likesCount: getLikesCount(likes));
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  int likesCount;
  Map likes;

  _PostState(
      {this.postId,
      this.ownerId,
      this.username,
      this.description,
      this.likes,
      this.likesCount,
      this.location,
      this.mediaUrl});
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
