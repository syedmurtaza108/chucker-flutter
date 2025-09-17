import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/api_detail_page.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/helper/http_methods.dart';
import 'package:chucker_flutter/src/view/settings_page.dart';
import 'package:chucker_flutter/src/view/tabs/apis_listing.dart';
import 'package:chucker_flutter/src/view/widgets/app_bar.dart';
import 'package:chucker_flutter/src/view/widgets/confirmation_dialog.dart';
import 'package:chucker_flutter/src/view/widgets/filter_buttons.dart';
import 'package:chucker_flutter/src/view/widgets/menu_buttons.dart';
import 'package:flutter/material.dart';

///The main screen of `chucker_flutter`
class ChuckerPage extends StatefulWidget {
  ///The main screen of `chucker_flutter`
  const ChuckerPage({Key? key}) : super(key: key);

  @override
  State<ChuckerPage> createState() => _ChuckerPageState();
}

class _ChuckerPageState extends State<ChuckerPage> {
  var _httpMethod = ChuckerUiHelper.settings.httpMethod;

  List<ApiResponse> _apis = List.empty();

  var _query = '';

  final _tabsHeadings = [
    _TabModel(
      label: Localization.strings['successRequestsWithSpace']!,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      index: 0,
    ),
    _TabModel(
      label: Localization.strings['failedRequestsWithSpace']!,
      icon: const Icon(Icons.error, color: Colors.white),
      index: 1,
    ),
  ];

  Future<void> _init() async {
    final sharedPreferencesManager = SharedPreferencesManager.getInstance();
    _apis = await sharedPreferencesManager.getAllApiResponses();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(_) {
    return Scaffold(
      appBar: ChuckerAppBar(
        onBackPressed: () => ChuckerFlutter.navigatorObserver.navigator?.pop(),
        actions: [
          Theme(
            data: ThemeData(
              checkboxTheme: const CheckboxThemeData(
                side: BorderSide(color: Colors.white),
              ),
            ),
            child: Checkbox(
              tristate: true,
              value: _selectAllCheckState(),
              onChanged: (checked) {
                _selectDeselectAll(checked ?? false);
              },
            ),
          ),
          MenuButtons(
            enableDelete: _selectedApis.isNotEmpty,
            onDelete: _deleteAllSelected,
            onSettings: _openSettings,
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            FilterButtons(
              onFilter: (httpMethod) {
                setState(() => _httpMethod = httpMethod);
              },
              onSearch: (query) {
                setState(() => _query = query);
              },
              httpMethod: _httpMethod,
              query: _query,
            ),
            const SizedBox(height: 16),
            Material(
              color: primaryColor,
              child: TabBar(
                tabs: _tabsHeadings
                    .map(
                      (e) => Tab(
                        text: e.index == 0
                            ? '''${e.label} (${_successApis(filterApply: false).length})'''
                            : '''${e.label} (${_failedApis(filterApply: false).length})''',
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                key: const Key('apis_tab_bar_view'),
                children: [
                  ApisListingTabView(
                    apis: _successApis(),
                    onDelete: _deleteAnApi,
                    onChecked: _selectAnApi,
                    showDelete: _selectedApis.isEmpty,
                    onItemPressed: _openDetails,
                  ),
                  ApisListingTabView(
                    key: const Key('fail_tab_view'),
                    apis: _failedApis(),
                    onDelete: _deleteAnApi,
                    onChecked: _selectAnApi,
                    showDelete: _selectedApis.isEmpty,
                    onItemPressed: _openDetails,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ApiResponse> _successApis({bool filterApply = true}) {
    final query = _query.toLowerCase();
    return _apis.where((element) {
      var success = element.statusCode > 199 && element.statusCode < 300;
      final methodFilter = element.method.toLowerCase() == _httpMethod.name;
      if (filterApply) {
        success = success && (_httpMethod == HttpMethod.none || methodFilter);
        if (query.isEmpty) {
          return success;
        }
        return success &&
            (element.baseUrl.toLowerCase().contains(query) ||
                element.statusCode.toString().contains(query) ||
                element.path.toLowerCase().contains(query) ||
                element.requestTime.toString().contains(query));
      }
      return success;
    }).toList();
  }

  List<ApiResponse> _failedApis({bool filterApply = true}) {
    final query = _query.toLowerCase();
    return _apis.where((element) {
      var failed = element.statusCode < 200 || element.statusCode > 299;
      final methodFilter = element.method.toLowerCase() == _httpMethod.name;
      if (filterApply) {
        failed = failed && (_httpMethod == HttpMethod.none || methodFilter);
        if (query.isEmpty) {
          return failed;
        }
        return failed &&
            (element.baseUrl.toLowerCase().contains(query) ||
                element.statusCode.toString().contains(query) ||
                element.path.toLowerCase().contains(query) ||
                element.requestTime.toString().contains(query));
      }
      return failed;
    }).toList();
  }

  List<ApiResponse> get _selectedApis => _apis.where((e) => e.checked).toList();

  Future<void> _deleteAnApi(String dateTime) async {
    var deleteConfirm = true;
    if (ChuckerUiHelper.settings.showDeleteConfirmDialog) {
      deleteConfirm = await showConfirmationDialog(
            context,
            title: Localization.strings['singleDeletionTitle']!,
            message: Localization.strings['singleDeletionMessage']!,
            yesButtonBackColor: Colors.red,
            yesButtonForeColor: Colors.white,
          ) ??
          false;
    }
    if (deleteConfirm) {
      final sharedPreferencesManager = SharedPreferencesManager.getInstance();
      await sharedPreferencesManager.deleteAnApi(dateTime);
      setState(
        () => _apis.removeWhere((e) => e.requestTime.toString() == dateTime),
      );
    }
  }

  Future<void> _deleteAllSelected() async {
    var deleteConfirm = true;
    if (ChuckerUiHelper.settings.showDeleteConfirmDialog) {
      deleteConfirm = await showConfirmationDialog(
            context,
            title: Localization.strings['multipleDeletionTitle']!,
            message: Localization.strings['multipleDeletionMessage']!,
            yesButtonBackColor: Colors.red,
            yesButtonForeColor: Colors.white,
          ) ??
          false;
    }
    if (deleteConfirm) {
      final dateTimes = _selectedApis
          .where((e) => e.checked)
          .map((e) => e.requestTime.toString())
          .toList();
      final sharedPreferencesManager = SharedPreferencesManager.getInstance();
      await sharedPreferencesManager.deleteSelected(dateTimes);
      setState(
        () => _apis.removeWhere(
          (e) => dateTimes.contains(e.requestTime.toString()),
        ),
      );
    }
  }

  void _selectAnApi(String dateTime) {
    setState(() {
      _apis = _apis
          .map(
            (e) => e.requestTime.toString() == dateTime
                ? e.copyWith(checked: !e.checked)
                : e,
          )
          .toList();
    });
  }

  void _selectDeselectAll(bool select) {
    setState(() {
      _apis = _apis.map((e) => e.copyWith(checked: select)).toList();
    });
  }

  bool? _selectAllCheckState() {
    if (_selectedApis.length == _apis.length) {
      return true;
    } else if (_selectedApis.isNotEmpty) {
      return null;
    }
    return false;
  }

  void _openSettings() {
    ChuckerFlutter.navigatorObserver.navigator?.push(
      MaterialPageRoute<void>(
        builder: (_) => Theme(
          data: ThemeData.light(useMaterial3: false),
          child: const SettingsPage(),
        ),
      ),
    );
  }

  void _openDetails(ApiResponse api) {
    ChuckerFlutter.navigatorObserver.navigator?.push(
      MaterialPageRoute<void>(
        builder: (_) => Theme(
          data: ThemeData.light(useMaterial3: false),
          child: ApiDetailsPage(api: api),
        ),
      ),
    );
  }
}

class _TabModel {
  _TabModel({
    required this.label,
    required this.icon,
    required this.index,
  });
  final String label;
  final Widget icon;
  final int index;
}
