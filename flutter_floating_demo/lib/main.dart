import 'package:flutter/material.dart';
import 'package:flutter_floating_window/flutter_floating_window.dart';

import 'page/home_page.dart';
import 'page/normal_page.dart';
import 'page/with_floating_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routeTable = {
      "/": (context) => HomePage(),
      "/normal": (context) => NormalPage(),
      "/floating": (context) => WithFloatingPage(),
    };
    initFloatingWindow(
      routeTable,
      onTouchCallback: () {},
    );
    return MaterialApp(
      routes: routeTable,
      initialRoute: "/",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
