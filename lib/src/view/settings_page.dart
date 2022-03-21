import 'package:chucker_flutter/src/extensions.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
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
                  setState(() {
                    _settings = _settings.copyWith(
                      showNotification: value,
                    );
                  });
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
                min: 1,
                max: 10,
                divisions: 10,
                activeColor: primaryColor,
                label: _settings.duration.inSeconds.toString(),
                value: _settings.duration.inSeconds.toDouble(),
                onChanged: (value) {
                  setState(
                    () => _settings = _settings.copyWith(
                      duration: Duration(seconds: value.toInt()),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _settingRow(
              title: 'Alignment',
              description:
                  '''Notification will appear on screeen with reference to this alignment''',
              importantInfo:
                  '''It will not work if any of the position attributes is non-zero.''',
              child: AlignmentMenu(
                notificationAlignment: _settings.notificationAlignment,
                title: _getAlignmentMenuTitle(),
                onSelect: (alignment) {
                  setState(
                    () => _settings = _settings.copyWith(
                      notificationAlignment: alignment,
                    ),
                  );
                },
              ),
              padding: 16,
            ),
            const SizedBox(height: 16),
            _settingRow(
              title: 'Position Bottom',
              description:
                  '''The position of notification from bottom of screen.''',
              helperText: _settings.positionBottom.toString(),
              child: _PositionField(
                onChange: (text) {
                  setState(
                    () => _settings = _settings.copyWith(
                      positionBottom: double.tryParse(text) ?? 0,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _settingRow(
              title: 'Position Top',
              description:
                  '''The position of notification from top of screen.''',
              helperText: _settings.positionTop.toString(),
              child: _PositionField(
                onChange: (text) {
                  setState(
                    () => _settings = _settings.copyWith(
                      positionTop: double.tryParse(text) ?? 0,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _settingRow(
              title: 'Position Left',
              description:
                  '''The position of notification from left of screen.''',
              helperText: _settings.positionLeft.toString(),
              child: _PositionField(
                onChange: (text) {
                  setState(
                    () => _settings = _settings.copyWith(
                      positionLeft: double.tryParse(text) ?? 0,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _settingRow(
              title: 'Position Right',
              description:
                  '''The position of notification from right of screen.''',
              helperText: _settings.positionRight.toString(),
              child: _PositionField(
                onChange: (text) {
                  setState(
                    () => _settings = _settings.copyWith(
                      positionRight: double.tryParse(text) ?? 0,
                    ),
                  );
                },
              ),
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
                  setState(
                    () => _settings = _settings.copyWith(
                      httpMethod: method,
                    ),
                  );
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
                  setState(() {
                    _settings = _settings.copyWith(
                      showRequestsStats: value,
                    );
                  });
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
                  setState(
                    () => _settings = _settings.copyWith(
                      apiThresholds: value.toInt(),
                    ),
                  );
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
                  setState(() {
                    _settings = _settings.copyWith(
                      showDeleteConfirmDialog: value,
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
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

class _PositionField extends StatelessWidget {
  const _PositionField({
    required this.onChange,
    Key? key,
  }) : super(key: key);

  final void Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
      ),
      keyboardType: TextInputType.number,
      onChanged: onChange,
    );
  }
}
