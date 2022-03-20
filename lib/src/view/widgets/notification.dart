import 'dart:async';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:chucker_flutter/src/extensions.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/widgets/chucker_button.dart';
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
    begin: const Offset(0, 1.5),
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
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusCodeBackColor(widget.statusCode),
                borderRadius: BorderRadius.circular(64),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
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
                  Expanded(
                    child: Text(
                      widget.path,
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.bodyText2,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ChuckerButton(
                    onPressed: () {
                      _controller.animateTo(0);
                      ChuckerUiHelper.showChuckerScreen();
                    },
                    text: 'Details',
                    foreColor: Colors.white,
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
