# flutter_floating_window

仿旧版微信浏览页面，侧滑添加至浮窗功能。

[![pub package](https://img.shields.io/pub/v/flutter_floating_window.svg)](https://pub.dev/packages/flutter_floating_window)

## Screenshot

![](./screenshot.gif)

## Installation

Add `flutter_floating_window` as a dependency in your pubspec.yaml file.

1. Import Flutter Floating Window:

```dart
import 'package:flutter_floating_window/flutter_floating_window.dart';
```

2. Init Flutter Floating Window.

```dart
var routeTable = {
  "/floating": (context) => WithFloatingPage(),
};
initFloatingWindow(
  routeTable,
);
```

3. Open the page.

```dart
openFloatingWindowPage(
  context,
  '/floating',
  icon:
    'https://cdn.jsdelivr.net/gh/flutterchina/website@1.0/images/flutter-mark-square-100.png',
);
```

The icon shoud be a *network url* or an instance of *ImageProvider*.
