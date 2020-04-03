import 'package:challenge_3/main.dart';
import 'package:flutter/material.dart';

class Helper {
  Drawer drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: FlutterLogo(
              colors: Colors.red,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text(
              'Corona Virus Tracker',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                  (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            title: Text(
              'Ice Cream Stores',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
