import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/helper/method_enums.dart';
import 'package:chucker_flutter/src/view/widgets/alignment_menu.dart';
import 'package:chucker_flutter/src/view/widgets/app_bar.dart';
import 'package:chucker_flutter/src/view/widgets/http_methods_menu.dart';
import 'package:flutter/material.dart';

///Chucker Flutter Settings
class SettingsPage extends StatefulWidget {
  ///Chucker Flutter Settings
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _settings = ChuckerUiHelper.settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChuckerAppBar(
        onBackPressed: () => context.navigator.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _heading('Notification'),
            const SizedBox(height: 16),
            _settingRow(
              title: 'Show',
              description:
                  '''If on, you will receive an in-app notification whenever a network request will succeed or fail.''',
              child: Switch.adaptive(
                activeColor: primaryColor,
                value: _settings.showNotification,
                onChanged: (value) {
                  _saveSettings(showNotification: value);
                },
              ),
            ),
            const SizedBox(height: 16),
            _settingRow(
              title: 'Duration',
              description:
                  '''Notification will appear on screen for these seconds''',
              helperText: '${_settings.duration.inSeconds} seconds',
              child: Slider.adaptive(
                min: 2,
                max: 10,
                divisions: 9,
                activeColor: primaryColor,
                label: _settings.duration.inSeconds.toString(),
                value: _settings.duration.inSeconds.toDouble(),
                onChanged: (value) {
                  _saveSettings(duration: Duration(seconds: value.toInt()));
                },
              ),
            ),
            const SizedBox(height: 16),
            _settingRow(
              title: 'Alignment',
              description:
                  '''Notification will appear on screeen with reference to this alignment''',
              child: AlignmentMenu(
                notificationAlignment: _settings.notificationAlignment,
                title: _getAlignmentMenuTitle(),
                onSelect: (alignment) {
                  _saveSettings(notificationAlignment: alignment);
                },
              ),
              padding: 16,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            _heading('APIs Listing Screen'),
            const SizedBox(height: 16),
            _settingRow(
              title: 'Selected Http Method',
              description:
                  '''This http method will automatically be selected when you will go on api requests listing screen''',
              child: HttpMethodsMenu(
                httpMethod: _settings.httpMethod,
                onFilter: (method) {
                  _saveSettings(httpMethod: method);
                },
              ),
              padding: 16,
            ),
            const SizedBox(height: 16),
            _settingRow(
              title: 'Show Requests Statistics',
              description:
                  '''If on, the stats section of screen will remain visible.''',
              child: Switch.adaptive(
                activeColor: primaryColor,
                value: _settings.showRequestsStats,
                onChanged: (value) {
                  _saveSettings(showRequestsStats: value);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            _heading('API Requests'),
            const SizedBox(height: 16),
            _settingRow(
              title: 'Threshold',
              helperText: '${_settings.apiThresholds} apis',
              description:
                  '''The maximum number of api requests that you can save on device. When you will reach this threshold, an old request will be deleted before saving a new one.''',
              importantInfo:
                  '''Select the value carefully, a large number may result in huge consumption of user device's memory.''',
              child: Slider.adaptive(
                min: 100,
                max: 1000,
                divisions: 90,
                activeColor: primaryColor,
                label: _settings.apiThresholds.toString(),
                value: _settings.apiThresholds.toDouble(),
                onChanged: (value) {
                  _saveSettings(apiThresholds: value.toInt());
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            _heading('Deletion of Requests'),
            const SizedBox(height: 16),
            _settingRow(
              title: 'Show Confirm Dialog',
              description:
                  '''If on, a confirmation dialog will appear whenever you will attempt to delete a record.''',
              child: Switch.adaptive(
                activeColor: primaryColor,
                value: _settings.showDeleteConfirmDialog,
                onChanged: (value) {
                  _saveSettings(showDeleteConfirmDialog: value);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _saveSettings({
    Duration? duration,
    double? positionTop,
    double? positionBottom,
    double? positionRight,
    double? positionLeft,
    Alignment? notificationAlignment,
    int? apiThresholds,
    HttpMethod? httpMethod,
    bool? showRequestsStats,
    bool? showNotification,
    bool? showDeleteConfirmDialog,
  }) {
    _settings = _settings.copyWith(
      duration: duration,
      positionBottom: positionBottom,
      positionLeft: positionLeft,
      positionRight: positionRight,
      positionTop: positionTop,
      httpMethod: httpMethod,
      notificationAlignment: notificationAlignment,
      apiThresholds: apiThresholds,
      showRequestsStats: showRequestsStats,
      showNotification: showNotification,
      showDeleteConfirmDialog: showDeleteConfirmDialog,
    );
    SharedPreferencesManager.getInstance().setSettings(_settings);
    setState(() {});
  }

  String _getAlignmentMenuTitle() {
    if (_settings.notificationAlignment == Alignment.bottomCenter) {
      return 'BottomCenter';
    } else if (_settings.notificationAlignment == Alignment.bottomLeft) {
      return 'BottomLeft';
    } else if (_settings.notificationAlignment == Alignment.bottomRight) {
      return 'BottomRight';
    } else if (_settings.notificationAlignment == Alignment.center) {
      return 'Center';
    } else if (_settings.notificationAlignment == Alignment.centerLeft) {
      return 'CenterLeft';
    } else if (_settings.notificationAlignment == Alignment.centerRight) {
      return 'CenterRight';
    } else if (_settings.notificationAlignment == Alignment.topCenter) {
      return 'TopCenter';
    } else if (_settings.notificationAlignment == Alignment.topLeft) {
      return 'TopLeft';
    } else if (_settings.notificationAlignment == Alignment.topRight) {
      return 'TopRight';
    }
    return '';
  }

  Column _settingRow({
    required String title,
    required Widget child,
    required String description,
    String? helperText,
    String? importantInfo,
    double? padding,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.theme.textTheme.bodyText2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: context.theme.textTheme.caption,
                  ),
                  Visibility(
                    visible: helperText != null,
                    child: const SizedBox(height: 8),
                  ),
                  Visibility(
                    visible: helperText != null,
                    child: Text(
                      'Current Value: $helperText',
                      style: context.theme.textTheme.caption!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: child,
              ),
            ),
          ],
        ),
        Visibility(
          visible: importantInfo != null,
          child: const SizedBox(height: 8),
        ),
        Visibility(
          visible: importantInfo != null,
          child: Row(
            children: [
              const Icon(
                Icons.info,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  importantInfo ?? '',
                  style: context.theme.textTheme.caption!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heading(String heading) {
    return Text(
      heading,
      style: context.theme.textTheme.headline6!.copyWith(
        color: primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
