import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:chucker_flutter/src/extensions.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/helper/method_enums.dart';
import 'package:chucker_flutter/src/view/helper/strings.dart';
import 'package:chucker_flutter/src/view/tabs/apis_listing.dart';
import 'package:chucker_flutter/src/view/widgets/confirmation_dialog.dart';
import 'package:chucker_flutter/src/view/widgets/filter_buttons.dart';
import 'package:chucker_flutter/src/view/widgets/menu_buttons.dart';
import 'package:chucker_flutter/src/view/widgets/stats_tile.dart';
import 'package:flutter/material.dart';

///The main screen of `chucker_flutter`
class ChuckerPage extends StatefulWidget {
  ///The main screen of `chucker_flutter`
  const ChuckerPage({Key? key}) : super(key: key);

  @override
  State<ChuckerPage> createState() => _ChuckerPageState();
}

class _ChuckerPageState extends State<ChuckerPage> {
  var _httpMethod = ChuckerOptions.httpMethod;

  List<ApiResponse> _apis = List.empty();

  var _query = '';

  static final _tabsHeadings = [
    _TabModel(
      label: 'Success Requests',
      icon: const Icon(Icons.check_circle, color: Colors.green),
    ),
    _TabModel(
      label: 'Fail Requests',
      icon: const Icon(Icons.abc_outlined, color: Colors.red),
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
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          labelStyle: context.theme.textTheme.bodyText1,
        ),
        primaryColor: primaryColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text(packageName),
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
              onSettings: () {},
            ),
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    StatsTile(
                      stats: _successApis(filterApply: false).length.toString(),
                      title: 'Success\nRequests',
                      backColor: Colors.greenAccent[400]!,
                    ),
                    StatsTile(
                      stats: _failedApis(filterApply: false).length.toString(),
                      title: 'Failed\nRequests',
                      backColor: Colors.amber[300]!,
                    ),
                    StatsTile(
                      stats: _remaingRequests.toString(),
                      title: 'Remaining\nRequests',
                      backColor: Colors.deepOrange[400]!,
                    ),
                  ],
                ),
              ),
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
                  tabs: _tabsHeadings.map((e) => Tab(text: e.label)).toList(),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ApisListingTabView(
                      apis: _successApis(),
                      onDelete: _deleteAnApi,
                      onChecked: _selectAnApi,
                      showDelete: _selectedApis.isEmpty,
                    ),
                    ApisListingTabView(
                      apis: _failedApis(),
                      onDelete: _deleteAnApi,
                      onChecked: _selectAnApi,
                      showDelete: _selectedApis.isEmpty,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int get _remaingRequests => ChuckerOptions.apiThresholds - _apis.length;

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
    final deleteConfirm = await showConfirmationDialog(
          context,
          title: 'Deletion of a Record',
          message: 'Are you sure you want to delete the record permanently?',
          yesButtonBackColor: Colors.red,
          yesButtonForeColor: Colors.white,
        ) ??
        false;
    if (deleteConfirm) {
      final sharedPreferencesManager = SharedPreferencesManager.getInstance();
      await sharedPreferencesManager.deleteAnApi(dateTime);
      setState(
        () => _apis.removeWhere((e) => e.requestTime.toString() == dateTime),
      );
    }
  }

  Future<void> _deleteAllSelected() async {
    final deleteConfirm = await showConfirmationDialog(
          context,
          title: 'Deletion of The Selected Records',
          message:
              '''Are you sure you want to delete the selected records permanently?''',
          yesButtonBackColor: Colors.red,
          yesButtonForeColor: Colors.white,
        ) ??
        false;
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
}

class _TabModel {
  _TabModel({
    required this.label,
    required this.icon,
  });
  final String label;
  final Widget icon;
}
