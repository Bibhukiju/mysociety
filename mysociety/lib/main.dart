
import 'package:flutter/material.dart';
import 'package:mysociety/pages/home.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(primarySwatch: Colors.deepOrange, accentColor: Colors.pink),
      title: "Minista",
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
