import 'dart:convert';

import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/models/settings.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///[SharedPreferencesManager] handles storage of API responses
class SharedPreferencesManager {
  SharedPreferencesManager._() {
    getSettings();
  }

  static SharedPreferencesManager? _sharedPreferencesManager;

  ///[getInstance] returns the singleton object of [SharedPreferencesManager]
  // ignore: prefer_constructors_over_static_methods
  static SharedPreferencesManager getInstance() {
    return _sharedPreferencesManager ??= SharedPreferencesManager._();
  }

  static const String _kApiResponses = 'api_responses';
  static const String _kSettings = 'chucker_settings';

  ///[addApiResponse] sets an API response to local disk
  Future<void> addApiResponse(ApiResponse apiResponse) async {
    final newResponses = List<ApiResponse>.empty(growable: true);
    final previousResponses = await getAllApiResponses();

    if (previousResponses.length == ChuckerUiHelper.settings.apiThresholds) {
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

  ///[setSettings] saves the chucker settings in user's disk
  Future<void> setSettings(Settings settings) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _kSettings,
      jsonEncode(settings),
    );
    debugPrint(jsonEncode(settings));

    ChuckerUiHelper.settings = settings;
  }

  ///[getSettings] gets the chucker settings from user's disk
  Future<Settings> getSettings() async {
    final preferences = await SharedPreferences.getInstance();

    var settings = Settings.defaultObject();

    final jsonString = preferences.getString(_kSettings);

    debugPrint('jsonString: $jsonString');

    if (jsonString == null) {
      return settings;
    }
    final json = jsonDecode(jsonString);

    try {
      settings = Settings.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      debugPrint('try: $e');
    }

    ChuckerUiHelper.settings = settings;
    return settings;
  }
}
