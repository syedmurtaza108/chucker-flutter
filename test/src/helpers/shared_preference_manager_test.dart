import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/models/settings.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late final SharedPreferencesManager _sharedPreferencesManager;

  setUpAll(() {
    _sharedPreferencesManager = SharedPreferencesManager.getInstance();
  });

  test('getInstance always returns the same instance', () {
    final instance1 = SharedPreferencesManager.getInstance();
    final instance2 = SharedPreferencesManager.getInstance();
    final instance3 = SharedPreferencesManager.getInstance();
    expect(instance1, instance2);
    expect(instance2, instance3);
  });

  group('delete responses froms shared preferences', () {
    test('An api request should be deleted when deleteAnApi called ', () async {
      final mockedApis = [
        ApiResponse.mock().copyWith(requestTime: DateTime(2022, 1, 2)),
        ApiResponse.mock().copyWith(requestTime: DateTime(2022, 1, 3)),
      ];

      //It is necessary to call to avoid retrieving previous data
      SharedPreferences.setMockInitialValues({});

      for (var i = 0; i < mockedApis.length; i++) {
        await _sharedPreferencesManager.addApiResponse(mockedApis[i]);
      }

      var savedApis = await _sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, mockedApis.length);

      await _sharedPreferencesManager.deleteAnApi(
        mockedApis.first.requestTime.toString(),
      );

      savedApis = await _sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, 1);
      expect(savedApis.first, mockedApis[1]);
    });

    test('All selected records should be deleted when deleteSelected called ',
        () async {
      final mockedApis = [
        ApiResponse.mock().copyWith(requestTime: DateTime(2022, 1, 2)),
        ApiResponse.mock().copyWith(requestTime: DateTime(2022, 1, 3)),
        ApiResponse.mock().copyWith(requestTime: DateTime(2022, 1, 4)),
      ];

      //It is necessary to call to avoid retrieving previous data
      SharedPreferences.setMockInitialValues({});

      for (var i = 0; i < mockedApis.length; i++) {
        await _sharedPreferencesManager.addApiResponse(mockedApis[i]);
      }

      var savedApis = await _sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, mockedApis.length);

      await _sharedPreferencesManager.deleteSelected([
        mockedApis[0].requestTime.toString(),
        mockedApis[1].requestTime.toString(),
      ]);

      savedApis = await _sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, 1);
      expect(savedApis.first, mockedApis[2]);
    });

    test('No item should be deleted when no selected item found ', () async {
      final mockedApis = [
        ApiResponse.mock().copyWith(requestTime: DateTime(2022, 1, 2)),
        ApiResponse.mock().copyWith(requestTime: DateTime(2022, 1, 3)),
      ];

      //It is necessary to call to avoid retrieving previous data
      SharedPreferences.setMockInitialValues({});

      for (var i = 0; i < mockedApis.length; i++) {
        await _sharedPreferencesManager.addApiResponse(mockedApis[i]);
      }

      var savedApis = await _sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, mockedApis.length);

      await _sharedPreferencesManager.deleteAnApi(
        DateTime(2022, 1, 4).toString(),
      );

      savedApis = await _sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, 2);
      expect(savedApis.first, mockedApis[1]);
    });
  });

  group('get responses from shared preferences', () {
    test('Initially should return empty array', () async {
      //It is necessary to call to avoid retrieving previous data
      SharedPreferences.setMockInitialValues({});

      final savedApis = await _sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, 0);
    });
    test(
        'all saved responses should be returned when getAllApiResponses called',
        () async {
      final mockedApis = [
        ApiResponse.mock(),
        ApiResponse.mock().copyWith(statusCode: 400),
      ];

      //It is necessary to call to avoid retrieving previous data
      SharedPreferences.setMockInitialValues({});

      for (var i = 0; i < mockedApis.length; i++) {
        await _sharedPreferencesManager.addApiResponse(mockedApis[i]);
      }

      final savedApis = await _sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, mockedApis.length);
    });

    test('all saved responses should be returned in descending order',
        () async {
      final mockedApis = [
        ApiResponse.mock().copyWith(requestTime: DateTime(2022, 1, 2)),
        ApiResponse.mock().copyWith(requestTime: DateTime(2022, 1, 3)),
      ];

      //It is necessary to call to avoid retrieving previous data
      SharedPreferences.setMockInitialValues({});

      for (var i = 0; i < mockedApis.length; i++) {
        await _sharedPreferencesManager.addApiResponse(mockedApis[i]);
      }

      final savedApis = await _sharedPreferencesManager.getAllApiResponses();
      expect(savedApis[0], mockedApis[1]);
      expect(savedApis[1], mockedApis[0]);
    });
  });

  group('save api responses in shared preferences', () {
    test(
        'data should be saved in shared preferences when addApiResponse called',
        () async {
      final mockedApi = ApiResponse.mock();

      //It is necessary to call to avoid retrieving previous data
      SharedPreferences.setMockInitialValues({});

      await _sharedPreferencesManager.addApiResponse(mockedApi);

      final savedApis = await _sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, 1);
      expect(savedApis.first, mockedApi);
    });

    test('old record should be removed when threshold reached', () async {
      ChuckerUiHelper.settings = Settings.defaultObject().copyWith(
        apiThresholds: 1,
      );

      final mockedApi = ApiResponse.mock();
      final mockedApi2 = ApiResponse.mock().copyWith(statusCode: 400);

      //It is necessary to call to avoid retrieving previous data
      SharedPreferences.setMockInitialValues({});

      await _sharedPreferencesManager.addApiResponse(mockedApi);

      var savedApis = await _sharedPreferencesManager.getAllApiResponses();

      expect(savedApis.first.statusCode, 200);
      expect(savedApis.length, 1);

      await _sharedPreferencesManager.addApiResponse(mockedApi2);

      savedApis = await _sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.first.statusCode, 400);
      expect(savedApis.length, 1);
    });
  });

  group('chucker settings', () {
    test(
      'Default object should be return when no settings found on device',
      () async {
        //It is necessary to call to avoid retrieving previous data
        SharedPreferences.setMockInitialValues({});

        final settings = await _sharedPreferencesManager.getSettings();
        expect(settings, Settings.defaultObject());
      },
    );

    test(
      '''settings should be assigned to ChuckerUiHelper.settings setters when setSettings called''',
      () async {
        final defaultSettings = Settings.defaultObject();

        ChuckerUiHelper.settings = defaultSettings;

        final mySettings = defaultSettings.copyWith(
          apiThresholds: 20,
        );

        expect(ChuckerUiHelper.settings.apiThresholds, 100);

        //It is necessary to call to avoid retrieving previous data
        SharedPreferences.setMockInitialValues({});

        await _sharedPreferencesManager.setSettings(mySettings);

        expect(ChuckerUiHelper.settings.apiThresholds, 20);
      },
    );

    test(
      'settings should be saved on device when setSettings called',
      () async {
        final mySettings = Settings.defaultObject().copyWith(
          apiThresholds: 1,
        );
        //It is necessary to call to avoid retrieving previous data
        SharedPreferences.setMockInitialValues({});

        await _sharedPreferencesManager.setSettings(mySettings);
        final settings = await _sharedPreferencesManager.getSettings();
        expect(settings, mySettings);
      },
    );
  });
}
