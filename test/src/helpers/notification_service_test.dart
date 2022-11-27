import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:chucker_flutter/src/helpers/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
      'Chucker Flutter default init, '
      'which mean no Local Notification initialization', () {
    expect(
      ChuckerFlutter.showNotificationOptions,
      ShowNotificationOptions.toast,
    );
  });

  test(
      '[NotificationService] initiated when'
      ' ChuckerFlutter.showNotificationOptions '
      '== ShowNotificationOptions.notification', () {
    ChuckerFlutter.withLocalNotification();
    expect(
      ChuckerFlutter.showNotificationOptions,
      ShowNotificationOptions.notification,
    );
    expect(
      NotificationService.flutterLocalNotificationsPlugin,
      isA<FlutterLocalNotificationsPlugin>(),
    );
  });

  test('[NotificationService] show notification', () {
    /// Notification Channel ID
    const channelId = 'Chucker';

    /// Notification Channel Name
    const channelName = 'Chucker';

    /// Notification Channel Description
    const channelDescription = 'Chucker';

    /// [AndroidNotificationDetails] give many
    /// options for displaying android notifications
    const androidNotificationDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      ticker: 'ticker',
      groupKey: channelId,
      enableVibration: false,
    );

    /// [DarwinNotificationDetails] give many
    /// options for displaying iOS notifications
    const iosNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
      threadIdentifier: 'requests',
    );
    ChuckerFlutter.withLocalNotification();

    expect(
      NotificationService.showNotification(
        0,
        channelName,
        {
          'HTTP Request': {
            'method': 'POST',
            'status_code': '201',
            'path': 'v1/posts',
          }
        }.toString(),
        const NotificationDetails(
          android: androidNotificationDetails,
          iOS: iosNotificationDetails,
        ),
        payload: '',
      ),
      true,
    );
  });
}
