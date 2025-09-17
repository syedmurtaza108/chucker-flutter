import 'dart:async';

import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/view/api_detail_page.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/widgets/primary_button.dart';
import 'package:flutter/material.dart';

///Notification widget showing in overlay notification
class Notification extends StatefulWidget {
  ///Notification widget showing in overlay notification
  const Notification({
    required this.statusCode,
    required this.method,
    required this.path,
    required this.removeNotification,
    required this.requestTime,
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

  ///Time when api request sent
  final DateTime requestTime;

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: ChuckerUiHelper.settings.duration,
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
    super.initState();
    Future.delayed(
      Duration(seconds: ChuckerUiHelper.settings.duration.inSeconds - 1),
      () {
        if (mounted) _controller.reverse();
      },
    );

    _controller.addListener(
      () {
        if (_controller.status == AnimationStatus.completed ||
            _controller.status == AnimationStatus.dismissed) {
          widget.removeNotification();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const ValueKey('notification_button'),
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
                border: Border(
                  left: BorderSide(
                    color: statusColor(widget.statusCode),
                    width: 8,
                  ),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.statusCode.toString(),
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge!
                        .toBold()
                        .withColor(Colors.black),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.method.toUpperCase(),
                          style: context.textTheme.bodyMedium!
                              .toBold()
                              .withColor(methodColor(widget.method)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.path,
                          style: context.textTheme.bodySmall
                              ?.withColor(Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  PrimaryButton(
                    onPressed: () {
                      _controller.animateTo(0);
                      ChuckerUiHelper.showChuckerScreen();
                      _openDetails();
                    },
                    text: Localization.strings['details']!,
                    foreColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openDetails() async {
    final api = await SharedPreferencesManager.getInstance().getApiResponse(
      widget.requestTime,
    );
    await ChuckerFlutter.navigatorObserver.navigator?.push(
      MaterialPageRoute<dynamic>(
        builder: (_) => Theme(
          data: ThemeData.light(useMaterial3: false),
          child: ApiDetailsPage(api: api),
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
