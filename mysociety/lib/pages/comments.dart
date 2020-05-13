import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../widgets/header.dart';
import '../widgets/progess.dart';
import 'home.dart';
import 'home.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;
  Comments({this.postId, this.postMediaUrl, this.postOwnerId});
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Comments"),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText: "Write a Comment"),
            ),
            trailing: OutlineButton(
              onPressed: addComment,
              borderSide: BorderSide.none,
              child: Text("post"),
            ),
          )
        ],
      ),
    );
  }

  addComment() {
    commentsRef.document(widget.postId).collection("comments").add({
      "username": currentUser.username,
      "comment": commentController.text,
      "timestamp": timestamp,
      "avatarUrl": currentUser.photoUrl,
      "userId": currentUser.id,
    });
  //   bool isNotPostOwner=widget.postOwnerId!=currentUser.id;
  //  if(isNotPostOwner)
   {
      activityFeedRef.document(widget.postOwnerId).collection("feedItems").add({
      "type": "comment",
      "commentData": commentController.text,
      "username": currentUser.username,
      "userProfileImg": currentUser.photoUrl,
      "postId": widget.postId,
      "mediaUrl": widget.postMediaUrl,
      "timestamp": timestamp,
      "userId":currentUser.id,

    });
   }
    commentController.clear();
  }

  buildComments() {
    return StreamBuilder(
      stream: commentsRef
          .document(widget.postId)
          .collection('comments')
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<Comment> comments = [];
        snapshot.data.documents
            .forEach((doc) => {comments.add(Comment.fromDocumnet(doc))});
        return ListView(children: comments);
      },
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment(
      {this.username,
      this.avatarUrl,
      this.comment,
      this.timestamp,
      this.userId});

  factory Comment.fromDocumnet(DocumentSnapshot doc) {
    return Comment(
      avatarUrl: doc["avatarUrl"],
      userId: doc["userId"],
      comment: doc["comment"],
      timestamp: doc["timestamp"],
      username: doc["username"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(avatarUrl)),
          subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider()
      ],
    );
  }
}
