import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildSearchField(),
      body: buildNocontact(),
    );
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        decoration: InputDecoration(
            hintText: "Search for a user",
            filled: true,
            prefixIcon: Icon(
              Icons.account_box,
              size: 25,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => print("clear"),
            )),
      ),
    );
  }

  Container buildNocontact() {
    return Container(
        child: Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SvgPicture.asset(
            'assets/search.svg',
            height: MediaQuery.of(context).size.height * .8,
          ),
          Text(
            "Find Users",
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            fontSize: 20
            ),
          )
        ],
      ),
    ));
  }
}
