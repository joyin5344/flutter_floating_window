library flutter_floating_window;

import 'package:flutter/material.dart';
import 'package:flutter_floating_window/src/flutter_floating_config.dart';
import 'package:flutter_floating_window/src/flutter_floating_manager.dart';

export 'src/flutter_floating_config.dart';

initFloatingWindow(
  Map<String, WidgetBuilder> routeTable, {
  VoidCallback onTouchCallback,
  FloatingWidgetConfig config,
}) {
  FlutterFloatingManager().init(
    routeTable,
    onTouchCallback: onTouchCallback,
    config: config,
  );
}

Future<T> openFloatingWindowPage<T extends Object>(
  BuildContext context,
  String pageRouteName, {
  Map<String, Object> argument,
  String icon,
}) {
  return FlutterFloatingManager().openPage(
    context,
    pageRouteName,
    argument: argument,
    icon: icon,
  );
}
