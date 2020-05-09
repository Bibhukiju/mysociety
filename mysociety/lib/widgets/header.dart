import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle = false, String titleText}) {
  return AppBar(
    title: isAppTitle
        ? Text(
            "Minsta",
            style: TextStyle(fontSize: 30),
          )
        : titleText,
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
