import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_window/flutter_floating_window.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Floating Window"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Open Normal Page"),
              onPressed: () {
                Navigator.pushNamed(context, "/normal");
              },
            ),
            Container(height: 50),
            RaisedButton(
              child: Text("Open Floating Page"),
              onPressed: () {
                openFloatingWindowPage(
                  context,
                  '/floating',
                  icon:
                      'https://cdn.jsdelivr.net/gh/flutterchina/website@1.0/images/flutter-mark-square-100.png',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
