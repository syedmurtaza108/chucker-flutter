import 'dart:convert';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

///[SharedPreferencesManager] handles storage of API responses
class SharedPreferencesManager {
  SharedPreferencesManager._();

  static SharedPreferencesManager? _sharedPreferencesManager;

  ///[getInstance] returns the singleton object of [SharedPreferencesManager]
  // ignore: prefer_constructors_over_static_methods
  static SharedPreferencesManager getInstance() {
    return _sharedPreferencesManager ??= SharedPreferencesManager._();
  }

  static const String _kApiResponses = 'api_responses';

  ///[addApiResponse] sets an API response to local disk
  Future<void> addApiResponse(ApiResponse apiResponse) async {
    final newResponses = List<ApiResponse>.empty(growable: true);
    final previousResponses = await getAllApiResponses();

    if (previousResponses.length == ChuckerOptions.apiThresholds) {
      previousResponses.removeAt(0);
    }

    newResponses
      ..addAll(previousResponses)
      ..add(apiResponse);

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _kApiResponses,
      jsonEncode(newResponses),
    );
  }

  ///[getAllApiResponses] returns all api responses saved in local disk
  Future<List<ApiResponse>> getAllApiResponses() async {
    final preferences = await SharedPreferences.getInstance();
    final json = preferences.getString(_kApiResponses);
    if (json == null) {
      return List.empty();
    }

    final list = jsonDecode(json);
    final apiResponses = List<ApiResponse>.empty(growable: true);

    for (final item in list) {
      apiResponses.add(ApiResponse.fromJson(item as Map<String, dynamic>));
    }
    apiResponses.sort((a, b) => b.requestTime.compareTo(a.requestTime));
    return apiResponses;
  }

  ///[deleteAnApi] deletes an api record from local disk
  Future<void> deleteAnApi(String dateTime) async {
    final apis = await getAllApiResponses();
    apis.removeWhere((e) => e.requestTime.toString() == dateTime);

    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _kApiResponses,
      jsonEncode(apis),
    );
  }

  ///[deleteAnApi] deletes an api record from local disk
  Future<void> deleteSelected(List<String> dateTimes) async {
    final apis = await getAllApiResponses();
    apis.removeWhere((e) => dateTimes.contains(e.requestTime.toString()));

    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _kApiResponses,
      jsonEncode(apis),
    );
  }
}
