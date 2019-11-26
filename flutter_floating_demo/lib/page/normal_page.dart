import 'package:flutter/material.dart';

class NormalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Normal Page"),
      ),
      body: Center(
        child: Text("普通页面"),
      ),
    );
  }
}
