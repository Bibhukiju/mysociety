import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String bio;
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  User(
      {this.bio,
      this.displayName,
      this.email,
      this.photoUrl,
      this.id,
      this.username});
  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc["id"],
        email: doc["email"],
        displayName: doc["displayname"],
        photoUrl: doc["photoUrl"],
        username: doc["username"],
        bio: doc["bio"]);
  }
}
