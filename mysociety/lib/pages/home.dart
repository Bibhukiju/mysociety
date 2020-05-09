import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSign = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  login() {
    googleSign.signIn();
  }

  logout() {
    googleSign.signOut();
  }

  buildAuthScreen() {
    return Center(
      child: RaisedButton(
        onPressed: () {
          logout();
        },
        child: Text("logOut"),
      ),
    );
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Theme.of(context).accentColor,
                Theme.of(context).primaryColor,
              ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "MySociety",
                style: TextStyle(
                    fontSize: 80,
                    color: Colors.white,
                    fontStyle: FontStyle.italic),
              ),
              GestureDetector(
                onTap: () {
                  login();
                },
                child: Container(
                  width: 260,
                  height: 60,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://i.stack.imgur.com/mGHPI.png"))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    googleSign.onCurrentUserChanged.listen((event) {
      handleSignIn(event);
    });
    googleSign
        .signInSilently(suppressErrors: false)
        .then((value) => handleSignIn(value));
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
