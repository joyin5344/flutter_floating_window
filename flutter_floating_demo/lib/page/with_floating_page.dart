import 'package:flutter/material.dart';

class WithFloatingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("With Floating Page"),
      ),
      body: Center(
        child: Text("侧滑返回可添加至浮窗"),
      ),
    );
  }
}
