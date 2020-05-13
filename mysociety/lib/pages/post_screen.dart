import 'package:flutter/material.dart';

import '../widgets/header.dart';
import '../widgets/post.dart';
import '../widgets/progess.dart';
import 'home.dart';

class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;
  PostScreen({this.postId, this.userId});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return circularProgress();
          }
          Post post = Post.fromDocument(snapshots.data);
          return Center(
            child: Scaffold(
              appBar: header(context, titleText: post.username),
              body: ListView(
                children: <Widget>[
                  Container(
                    child: post,
                  )
                ],
              ),
            ),
          );
        },
        future: postsRef
            .document(userId)
            .collection("userPosts")
            .document(postId)
            .get());
  }
}
