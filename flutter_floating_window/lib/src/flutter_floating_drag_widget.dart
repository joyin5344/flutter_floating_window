import 'dart:math';

import 'package:flutter/material.dart';

import 'flutter_floating_manager.dart';
import 'flutter_floating_tip_widget.dart';

class FlutterFloatingDragWidget extends StatelessWidget {
  final Stream<DragUpdateDetails> stream;

  static const int WIDTH_MODE_NORMAL = 143;
  static const int WIDTH_MODE_FOCUS = 165;

  FlutterFloatingDragWidget({
    @required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return StreamBuilder<DragUpdateDetails>(
      stream: stream,
      builder:
          (BuildContext context, AsyncSnapshot<DragUpdateDetails> snapshot) {
        double offset = WIDTH_MODE_NORMAL.toDouble();

        var hit = false;
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            Offset global = snapshot.data.globalPosition;
            var distance =
                (Offset(mediaQuery.size.width, mediaQuery.size.height) -
                        (global))
                    .distance;
            if (!hit && distance <= WIDTH_MODE_NORMAL) {
              hit = true;
            } else if (hit && distance > WIDTH_MODE_FOCUS) {
              hit = false;
            }
            double globalX = global.dx;
            if (globalX < 50) {
              offset = WIDTH_MODE_NORMAL.toDouble();
            } else if (globalX > mediaQuery.size.width / 2) {
              offset = 0;
            } else {
              offset = max(0, WIDTH_MODE_NORMAL / 2 - (globalX - 50));
            }
          }
        } else {
          hit = false;
        }
        FlutterFloatingManager().setHitResult(hit);
        return Stack(
          children: <Widget>[
            FlutterFloatingTipWidget(
              size: hit ? WIDTH_MODE_FOCUS : WIDTH_MODE_NORMAL,
              color: hit
                  ? FlutterFloatingManager().config.focusBackgroundColor
                  : FlutterFloatingManager().config.backgroundColor,
              offset: Offset(offset, offset),
              text: FlutterFloatingManager().config.text,
              textStyle: FlutterFloatingManager().config.textStyle,
              icon: Icon(
                Icons.link,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
