import 'dart:async';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:chucker_flutter/src/extensions.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:flutter/material.dart';

///Notification widget showing in overlay notification
class Notification extends StatefulWidget {
  ///Notification widget showing in overlay notification
  const Notification({
    required this.statusCode,
    required this.method,
    required this.path,
    required this.removeNotification,
    Key? key,
  }) : super(key: key);

  ///method of request
  final String method;

  ///url of request
  final String path;

  ///statusCode of response
  final int statusCode;

  ///Call back to notify parent to remove notification
  final VoidCallback removeNotification;

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: ChuckerOptions.duration,
    vsync: this,
  )..forward();

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, 0.5),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(parent: _controller, curve: Curves.fastLinearToSlowEaseIn),
  );

  @override
  void initState() {
    Future.delayed(
      Duration(seconds: ChuckerOptions.duration.inSeconds - 1),
      _controller.reverse,
    );

    _controller.addListener(
      () {
        if (_controller.status == AnimationStatus.completed ||
            _controller.status == AnimationStatus.dismissed) {
          widget.removeNotification();
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.isAnimating) {
          _controller.stop();
          return;
        }
        _controller.animateTo(0);
      },
      child: SlideTransition(
        position: _offsetAnimation,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Material(
            elevation: 10,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusCodeBackColor(widget.statusCode),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Chip(
                    backgroundColor: Colors.white,
                    label: Text(
                      '${widget.method.toUpperCase()}: ${widget.statusCode}',
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.path,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: ChuckerUiHelper.showChuckerScreen,
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                    ),
                    child: const Text('Show Details'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
