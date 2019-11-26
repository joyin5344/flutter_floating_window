import 'package:flutter/material.dart';

class FloatingWidgetConfig {
  final String text;
  final String cancelText;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color focusBackgroundColor;
  final Color cancelBackgroundColor;
  final Color cancelFocusBackgroundColor;

  FloatingWidgetConfig({
    this.text = "浮窗",
    this.cancelText = "取消浮窗",
    this.textStyle = const TextStyle(
      color: const Color(0xfff4f4f4),
      fontSize: 13,
    ),
    this.backgroundColor = const Color(0x66888888),
    this.focusBackgroundColor = const Color(0xaa888888),
    this.cancelBackgroundColor = const Color(0xFFDD5555),
    this.cancelFocusBackgroundColor = const Color(0xFFCC6666),
  });
}
