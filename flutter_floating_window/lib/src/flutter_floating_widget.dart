import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_floating_window/src/flutter_floating_tip_widget.dart';

import 'flutter_floating_manager.dart';

class FlutterFloatingWidget extends StatefulWidget {
  final RouteSettings settings;

  FlutterFloatingWidget({Key key, @required this.settings}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FlutterFloatingWidgetState();
}

class _FlutterFloatingWidgetState extends State<FlutterFloatingWidget>
    with TickerProviderStateMixin {
  Object _icon;

  bool _showDismiss = false;
  double _width = 68;
  Offset _offset;

  bool _hit = false;

  bool _show = true;

  bool _isFirstMove = true;

  static const int WIDTH_MODE_NORMAL = 143;
  static const int WIDTH_MODE_FOCUS = 165;

  AnimationController _animController;
  Animation _animation;

  @override
  void initState() {
    if (widget.settings != null && widget.settings.arguments is Map) {
      Map arguments = widget.settings.arguments;
      var icon = arguments['floating_icon'];
      if (icon is String) {
        _icon = NetworkImage(icon);
      } else if (icon is ImageProvider) {
        _icon = icon;
      }
    }

    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation =
        Tween<double>(begin: WIDTH_MODE_NORMAL.toDouble(), end: 0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.decelerate,
      ),
    )
          ..addListener(() {
            if (mounted) {
              setState(() {});
            }
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              if (mounted) {
                setState(() {
                  _showDismiss = false;
                });
              }
            }
          });
    super.initState();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _offset ??= Offset(mediaQuery.size.width - _width / 2 - 7,
        (mediaQuery.size.height * 0.618) - _width / 2);
    _width = 68;
    return Container(
      child: _show
          ? Stack(
              children: <Widget>[
                _showDismiss
                    ? FlutterFloatingTipWidget(
                        size: _hit ? WIDTH_MODE_FOCUS : WIDTH_MODE_NORMAL,
                        color: _hit
                            ? FlutterFloatingManager()
                                .config
                                .cancelBackgroundColor
                            : FlutterFloatingManager()
                                .config
                                .cancelFocusBackgroundColor,
                        offset: Offset(_animation.value, _animation.value),
                        text: FlutterFloatingManager().config.cancelText,
                        textStyle: FlutterFloatingManager().config.textStyle,
                        icon: Icon(
                          Icons.link_off,
                          color: Colors.white,
                        ),
                      )
                    : Container(),
                _FloatingItemWidget(
                  left: _offset.dx,
                  top: _offset.dy,
                  size: _width,
                  onTap: () {
                    setState(() {
                      _show = false;
                    });
                    FlutterFloatingManager()
                        .openPage(
                      context,
                      widget.settings.name,
                      argument: widget.settings.arguments,
                    )
                        .then((_) {
                      if (mounted) {
                        setState(() {
                          _show = true;
                        });
                      }
                    });
                  },
                  onPanDown: _onPanDown,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  floatingImageProvider: _icon ?? Icon(Icons.link),
                ),
              ],
            )
          : null,
    );
  }

  _onPanDown(DragDownDetails details) {
    _updatePosition(details.globalPosition);
  }

  _onPanUpdate(DragUpdateDetails details) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _updatePosition(details.globalPosition);
    setState(() {
      _showDismiss = true;
      var distance =
          (Offset(mediaQuery.size.width, mediaQuery.size.height) - _offset)
              .distance;
      if (!_hit && distance <= WIDTH_MODE_NORMAL + _width / 2) {
        _hit = true;
        FlutterFloatingManager().onTouchHit();
      } else if (_hit && distance > WIDTH_MODE_FOCUS + _width / 2) {
        _hit = false;
      }

      if (_isFirstMove) {
        _animController.forward();
      }
      _isFirstMove = false;
    });
  }

  _onPanEnd(DragEndDetails details) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    setState(() {
      if (_hit) {
        FlutterFloatingManager().dismissFloating();
      }

      var x = _offset.dx;
      var y = _offset.dy;
      if (x < mediaQuery.size.width / 2) {
        x = _width / 2 + 7;
      } else {
        x = mediaQuery.size.width - _width / 2 - 7;
      }
      _offset = Offset(x, y);

      _hit = false;
      _isFirstMove = true;

      _animController.reverse();
    });
  }

  _updatePosition(Offset position) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    setState(() {
      var x = position.dx;
      var y = position.dy;
      x = max(_width / 2, x);
      y = max(_width / 2, y);
      x = min(mediaQuery.size.width - _width / 2, x);
      y = min(mediaQuery.size.height - _width / 2, y);
      _offset = Offset(x, y);
    });
  }
}

class _FloatingItemWidget extends StatelessWidget {
  final double left;
  final double top;

  final ImageProvider floatingImageProvider;

  final GestureDragDownCallback onPanDown;
  final GestureDragStartCallback onPanStart;
  final GestureDragUpdateCallback onPanUpdate;
  final GestureDragEndCallback onPanEnd;
  final GestureDragCancelCallback onPanCancel;
  final GestureTapCallback onTap;

  final double size;

  _FloatingItemWidget({
    this.left,
    this.top,
    this.size,
    this.onPanDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.onTap,
    this.floatingImageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        margin: EdgeInsets.only(top: top - size / 2, left: left - size / 2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                  color: Color(0x55000000),
                  offset: Offset(2.0, 2.0),
                  blurRadius: 5.0,
                  spreadRadius: 2.0),
            ]),
        child: GestureDetector(
          onPanDown: onPanDown,
          onPanUpdate: onPanUpdate,
          onPanStart: onPanStart,
          onPanCancel: onPanCancel,
          onPanEnd: onPanEnd,
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Image(
                image: floatingImageProvider,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
