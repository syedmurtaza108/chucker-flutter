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
        child: Table(
          columnWidths: const {
            0: FixedColumnWidth(100),
            2: FixedColumnWidth(70)
          },
          children: [
            _settingRow(
              title: 'Notification Duration',
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
            _settingRow(
              title: 'Notification Alignment',
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
            _settingRow(
              title: 'Default Http Method',
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
            _settingRow(
              title: 'Api Threshold',
              helperText: '${_settings.apiThresholds} apis',
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
            _settingRow(
              title: 'Show Notification',
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
            _settingRow(
              title: 'Show Delete Dialog',
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
            _settingRow(
              title: 'Show Requests Statistics',
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
            _settingRow(
              title: 'Notification Position Bottom',
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
            _settingRow(
              title: 'Notification Position Top',
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
            _settingRow(
              title: 'Notification Position Left',
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
            _settingRow(
              title: 'Notification Position Right',
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

  TableRow _settingRow({
    required String title,
    required Widget child,
    String? helperText,
    double? padding,
  }) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: EdgeInsets.all(padding ?? 8),
            child: Text(
              title,
              style: context.theme.textTheme.caption!.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: EdgeInsets.all(padding ?? 8),
            child: child,
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: EdgeInsets.all(padding ?? 8),
            child: Text(
              helperText ?? '',
              style: context.theme.textTheme.caption!.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
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
