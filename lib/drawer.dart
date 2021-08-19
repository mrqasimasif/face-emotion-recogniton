import 'package:femr_app/cam/capture.dart';
import 'package:femr_app/cam/scan.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Face Emotionn Recognition"),
              accountEmail: Text("femr@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
                child: Text(
                  "F",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              title: Text("From Images"),
              trailing: Icon(Icons.camera_alt),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Camcorder())),
            ),
          ],
        ),
      ),
    );
  }
}
