import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart';

class Upload extends StatefulWidget {
  final User currentUser;
  Upload({this.currentUser});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File file;
  handletakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      this.file = file;
    });
  }

  handlepickPhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }

  selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text("Create Post"),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: handletakePhoto,
                  child: Text("Photo with camera"),
                ),
                SimpleDialogOption(
                  child: Text("Image from gallery"),
                  onPressed: handlepickPhoto,
                ),
                SimpleDialogOption(
                  child: Text("cancel"),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => clearImage(),
        ),
        title: Text(
          "Caption Post",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => print("hello"),
            child: Text(
              "Post",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.height * .8,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: FileImage(file))),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(widget.currentUser.photoUrl),
            ),
            title: Container(
              child: Text(
                widget.currentUser.username,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.closed_caption,color: Colors.orange,),
            title: Container(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: "Write your caption "),
              ),
            ),
          ),
          Container(
            width: 250,
            child: ListTile(
              leading: Icon(
                Icons.pin_drop,
                color: Colors.orange,
              ),
              title: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Where is this photo taken"),
              ),
            ),
          ),
          Center(
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Theme.of(context).primaryColor,
              child: Text("Use Current Location"),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }

  Container buildSplashScreen() {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.6),
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            SvgPicture.asset("assets/upload.svg"),
            RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text("Upload Image"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  selectImage(context);
                }),
          ],
        ),
      ),
    );
  }
}
