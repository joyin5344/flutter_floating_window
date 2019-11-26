import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_floating_window/src/flutter_floating_config.dart';
import 'package:flutter_floating_window/src/flutter_floating_drag_widget.dart';
import 'package:flutter_floating_window/src/flutter_floating_widget.dart';

import 'flutter_floating_route.dart';

class FlutterFloatingManager {
  static FlutterFloatingManager _singleton;

  FlutterFloatingManager._internal();

  factory FlutterFloatingManager() {
    _singleton ??= FlutterFloatingManager._internal();
    return _singleton;
  }

  VoidCallback _onTouchHitCallback;

  FloatingWidgetConfig config;
  Map<String, WidgetBuilder> _routes;

  OverlayEntry _dragOverlayEntry;
  OverlayEntry _floatingOverlayEntry;
  StreamController<DragUpdateDetails> _dragStreamController;
  DragResult _dragResult;

  init(
    Map<String, WidgetBuilder> routeTable, {
    VoidCallback onTouchCallback,
    FloatingWidgetConfig config,
  }) {
    _routes = routeTable;
    _onTouchHitCallback = onTouchCallback;
    this.config = config ?? FloatingWidgetConfig();
  }

  Future<T> openPage<T extends Object>(
    BuildContext context,
    String pageRouteName, {
    Map<String, Object> argument,
    Object icon,
    FloatingWidgetConfig config,
  }) {
    if (_routes == null || !_routes.containsKey(pageRouteName)) {
      throw Exception(
          "must call init with route table before open page, or your route table has no key named '$pageRouteName'.");
    }
    var args = argument ?? {};
    if (icon != null) {
      args['floating_icon'] = icon;
    }
    return Navigator.push(
      context,
      FlutterFloatingPageRoute(
        builder: _routes[pageRouteName],
        settings: RouteSettings(
          name: pageRouteName,
          arguments: args,
        ),
      ),
    );
  }

  startDrag(BuildContext context) {
    _dragStreamController?.close();
    _dragResult = DragResult();
    _dragStreamController = StreamController();
    _dragOverlayEntry = OverlayEntry(builder: (context) {
      return FlutterFloatingDragWidget(
        stream: _dragStreamController.stream,
      );
    });
    Overlay.of(context).insert(_dragOverlayEntry);
  }

  endDrag(BuildContext context, RouteSettings settings) {
    if (_dragResult != null && _dragResult.showFloating) {
      showFloating(
        context,
        settings: settings,
      );
    }
    if (_dragOverlayEntry != null) {
      _dragOverlayEntry.remove();
      _dragOverlayEntry = null;
    }
    _dragStreamController?.close();
    _dragStreamController = null;
    _dragResult = null;
  }

  updateDrag(DragUpdateDetails data) {
    _dragStreamController?.sink?.add(data);
  }

  setHitResult(bool isHit) {
    if (_dragResult != null && _dragResult.showFloating != isHit) {
      if (_dragResult.showFloating == false) {
        onTouchHit();
      }
      _dragResult.showFloating = isHit;
    }
  }

  onTouchHit() {
    if (_onTouchHitCallback != null) {
      _onTouchHitCallback();
    }
  }

  showFloating(
    BuildContext context, {
    @required RouteSettings settings,
  }) {
    dismissFloating();
    _floatingOverlayEntry = OverlayEntry(builder: (context) {
      return FlutterFloatingWidget(
        settings: settings,
      );
    });
    Overlay.of(context).insert(_floatingOverlayEntry);
  }

  dismissFloating() {
    try {
      if (_floatingOverlayEntry != null) {
        _floatingOverlayEntry.remove();
        _floatingOverlayEntry = null;
      }
    } catch (e) {}
  }
}

class DragResult {
  bool showFloating;
}
