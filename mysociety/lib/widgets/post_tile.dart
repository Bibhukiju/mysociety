import 'package:flutter/material.dart';
import '../pages/post_screen.dart';
import '../widgets/custom_image.dart';
import '../widgets/post.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPost(context),
      child: cachedNetworkImage(post.mediaUrl),
    );
  }

  showPost(context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PostScreen(
              postId: post.postId,
              userId: post.ownerId,
            )));
  }
}
