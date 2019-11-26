import 'package:flutter/material.dart';

class FlutterFloatingTipWidget extends StatelessWidget {
  final int size;
  final Color color;
  final Offset offset;
  final String text;
  final TextStyle textStyle;
  final Widget icon;

  FlutterFloatingTipWidget({
    @required this.size,
    @required this.color,
    @required this.offset,
    @required this.text,
    @required this.textStyle,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Transform.translate(
        offset: offset,
        child: Container(
          width: size.toDouble(),
          height: size.toDouble(),
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(
            right: 32,
            bottom: 22,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(375),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              icon,
              Padding(
                padding: EdgeInsets.only(top: 15),
              ),
              Material(
                color: Colors.transparent,
                child: Text(
                  text ?? "",
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
