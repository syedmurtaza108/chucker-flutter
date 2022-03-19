import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:chucker_flutter/src/extensions.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/helper/method_enums.dart';
import 'package:chucker_flutter/src/view/helper/strings.dart';
import 'package:chucker_flutter/src/view/tabs/apis_listing.dart';
import 'package:chucker_flutter/src/view/widgets/filter_buttons.dart';
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
      ),
      home: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/flutter_chucker_icon.png',
                      width: 64,
                      height: 64,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      packageName,
                      style: context.theme.textTheme.headline4!.copyWith(
                        color: primaryColor,
                      ),
                    ),
                    const Expanded(child: SizedBox.shrink()),
                    const SizedBox(width: 16),
                    Text(
                      _getStats(
                        ChuckerOptions.apiThresholds,
                        _successApis(filterApply: false).length,
                        _failedApis(filterApply: false).length,
                      ),
                      style: context.theme.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              const Divider(),
              FilterButtons(
                onFilter: (httpMethod) {
                  setState(() => _httpMethod = httpMethod);
                },
                httpMethod: _httpMethod,
              ),
              const Divider(),
              Material(
                color: primaryColor,
                child: TabBar(
                  tabs: _tabsHeadings.map((e) => Tab(text: e.label)).toList(),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ApisListingTabView(apis: _successApis()),
                    ApisListingTabView(apis: _failedApis()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStats(
    int apiThresholds,
    int successApis,
    int failApis,
  ) {
    return '''
    Api Requests Threshold: $apiThresholds
    Total Success Requests: $successApis
    Total Fail Requests: $failApis
    ''';
  }

  List<ApiResponse> _successApis({bool filterApply = true}) {
    return _apis.where((element) {
      final success = element.statusCode > 199 && element.statusCode < 300;
      final isFilter = element.method.toLowerCase() == _httpMethod.name;
      if (filterApply) {
        return success && (_httpMethod == HttpMethod.none || isFilter);
      }
      return success;
    }).toList();
  }

  List<ApiResponse> _failedApis({bool filterApply = true}) {
    return _apis.where((element) {
      final failed = element.statusCode < 200 || element.statusCode > 299;
      final isFilter = element.method.toLowerCase() == _httpMethod.name;
      if (filterApply) {
        return failed && (_httpMethod == HttpMethod.none || isFilter);
      }
      return failed;
    }).toList();
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
