import 'package:challenge_3/main.dart';
import 'package:challenge_3/src/ui/charts.dart';
import 'package:challenge_3/src/ui/news.dart';
import 'package:challenge_3/src/ui/youtube.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  Drawer drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: FlutterLogo(
              colors: Colors.grey,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[800],
            ),
          ),
          ListTile(
            title: Text(
              'COVID-19 Virus Tracker',
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
              'COVID-19 News by Country',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => NewsUI()),
                  (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            title: Text(
              'COVID-19 Charts',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportChartUI(),
                  ),
                  (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            title: Text(
              'COVID-19 WHO Videos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YoutubeUI(),
                  ),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  String getStrToday() {
    var today = DateFormat().add_yMMMMd().format(DateTime.now());
    var strDay = today.split(" ")[1].replaceFirst(',', '');
    if (strDay == '1') {
      strDay = strDay + "st";
    } else if (strDay == '2') {
      strDay = strDay + "nd";
    } else if (strDay == '3') {
      strDay = strDay + "rd";
    } else {
      strDay = strDay + "th";
    }
    var strMonth = today.split(" ")[0];
    var strYear = today.split(" ")[2];
    return "$strDay $strMonth $strYear";
  }
}
