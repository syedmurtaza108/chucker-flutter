import 'package:chucker_flutter/src/helpers/constants.dart';
import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/helper/http_methods.dart';
import 'package:chucker_flutter/src/view/helper/languages.dart';
import 'package:chucker_flutter/src/view/widgets/alignment_menu.dart';
import 'package:chucker_flutter/src/view/widgets/app_bar.dart';
import 'package:chucker_flutter/src/view/widgets/http_methods_menu.dart';
import 'package:chucker_flutter/src/view/widgets/language_menu.dart';
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
  Widget build(BuildContext _) {
    return Directionality(
      textDirection: Localization.textDirection,
      child: Scaffold(
        appBar: ChuckerAppBar(
          onBackPressed: () => context.navigator.pop(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _heading(Localization.strings['notification']!),
              const SizedBox(height: 16),
              _settingRow(
                title: Localization.strings['show']!,
                description: Localization.strings['notificationSettingDesc']!,
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
                title: Localization.strings['duration']!,
                description: Localization.strings['durationSettingDesc']!,
                helperText:
                    '''${_settings.duration.inSeconds} ${Localization.strings['seconds']}''',
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
                title: Localization.strings['alignment']!,
                description: Localization.strings['alignmentSettingDesc']!,
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
              _heading(Localization.strings['apiListingScreen']!),
              const SizedBox(height: 16),
              _settingRow(
                title: Localization.strings['selectedMethod']!,
                description: Localization.strings['selectedMethodDesc']!,
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
                title: Localization.strings['showRequestStats']!,
                description: Localization.strings['showRequestStatsDesc']!,
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
              _heading(Localization.strings['apiRequests']!),
              const SizedBox(height: 16),
              _settingRow(
                title: Localization.strings['threshold']!,
                helperText:
                    '''${_settings.apiThresholds} ${Localization.strings['apis']}''',
                description: Localization.strings['apiSettingDesc']!,
                importantInfo: Localization.strings['apiSettingsImpInfo'],
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
              _heading(Localization.strings['deletionOfRequests']!),
              const SizedBox(height: 16),
              _settingRow(
                title: Localization.strings['showConfirmDialog']!,
                description: Localization.strings['showDialogDesc']!,
                child: Switch.adaptive(
                  activeColor: primaryColor,
                  value: _settings.showDeleteConfirmDialog,
                  onChanged: (value) {
                    _saveSettings(showDeleteConfirmDialog: value);
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(),
              ),
              _heading(Localization.strings['language']!),
              const SizedBox(height: 16),
              _settingRow(
                title: Localization.strings['chuckerLanguage']!,
                description: Localization.strings['chuckerLanguageDesc']!,
                child: LanguagesMenu(
                  language: _settings.language,
                  onSelect: (language) {
                    _saveSettings(language: language);
                  },
                ),
                padding: 16,
              ),
              const SizedBox(height: 16),
            ],
          ),
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
    Language? language,
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
      language: language,
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
                    style: context.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: context.textTheme.bodySmall,
                  ),
                  Visibility(
                    visible: helperText != null,
                    child: const SizedBox(height: 8),
                  ),
                  Visibility(
                    visible: helperText != null,
                    child: Text(
                      '${Localization.strings['currentValue']} $helperText',
                      style: context.textTheme.bodySmall!.toBold(),
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
                  importantInfo ?? emptyString,
                  style: context.textTheme.bodySmall!
                      .toBold()
                      .withColor(Colors.orange),
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
      style: context.textTheme.titleLarge!.toBold().withColor(
            primaryColor,
          ),
    );
  }
}
