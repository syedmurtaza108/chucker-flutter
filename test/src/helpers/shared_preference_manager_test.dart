import 'package:chucker_flutter/src/helpers/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/models/settings.dart';
import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late final SharedPreferencesManager sharedPreferencesManager;

  setUpAll(() {
    sharedPreferencesManager = SharedPreferencesManager.getInstance(
      initData: false,
    );
  });

  test('getInstance always returns the same instance', () {
    final instance1 = SharedPreferencesManager.getInstance(
      initData: false,
    );
    final instance2 = SharedPreferencesManager.getInstance(
      initData: false,
    );
    final instance3 = SharedPreferencesManager.getInstance(
      initData: false,
    );
    expect(instance1, instance2);
    expect(instance2, instance3);
  });

  group('delete responses from shared preferences', () {
    test('An api request should be deleted when deleteAnApi called ', () async {
      final mockedApis = [
        ApiResponse.mock().copyWith(requestTime: DateTime(2022, 1, 2)),
        ApiResponse.mock().copyWith(requestTime: DateTime(2022, 1, 3)),
      ];

      //It is necessary to call to avoid retrieving previous data
      SharedPreferences.setMockInitialValues({});

      for (var i = 0; i < mockedApis.length; i++) {
        await sharedPreferencesManager.addApiResponse(mockedApis[i]);
      }

      var savedApis = await sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, mockedApis.length);

      await sharedPreferencesManager.deleteAnApi(
        mockedApis.first.requestTime.toString(),
      );

      savedApis = await sharedPreferencesManager.getAllApiResponses();
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
        await sharedPreferencesManager.addApiResponse(mockedApis[i]);
      }

      var savedApis = await sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, mockedApis.length);

      await sharedPreferencesManager.deleteSelected([
        mockedApis[0].requestTime.toString(),
        mockedApis[1].requestTime.toString(),
      ]);

      savedApis = await sharedPreferencesManager.getAllApiResponses();
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
        await sharedPreferencesManager.addApiResponse(mockedApis[i]);
      }

      var savedApis = await sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, mockedApis.length);

      await sharedPreferencesManager.deleteAnApi(
        DateTime(2022, 1, 4).toString(),
      );

      savedApis = await sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, 2);
      expect(savedApis.first, mockedApis[1]);
    });
  });

  group('get responses from shared preferences', () {
    test('Initially should return empty array', () async {
      //It is necessary to call to avoid retrieving previous data
      SharedPreferences.setMockInitialValues({});

      final savedApis = await sharedPreferencesManager.getAllApiResponses();
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
        await sharedPreferencesManager.addApiResponse(mockedApis[i]);
      }

      final savedApis = await sharedPreferencesManager.getAllApiResponses();
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
        await sharedPreferencesManager.addApiResponse(mockedApis[i]);
      }

      final savedApis = await sharedPreferencesManager.getAllApiResponses();
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

      await sharedPreferencesManager.addApiResponse(mockedApi);

      final savedApis = await sharedPreferencesManager.getAllApiResponses();
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

      await sharedPreferencesManager.addApiResponse(mockedApi);

      var savedApis = await sharedPreferencesManager.getAllApiResponses();

      expect(savedApis.first.statusCode, 200);
      expect(savedApis.length, 1);

      await sharedPreferencesManager.addApiResponse(mockedApi2);

      savedApis = await sharedPreferencesManager.getAllApiResponses();
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

        final settings = await sharedPreferencesManager.getSettings();
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

        await sharedPreferencesManager.setSettings(mySettings);

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

        await sharedPreferencesManager.setSettings(mySettings);
        final settings = await sharedPreferencesManager.getSettings();
        expect(settings, mySettings);
      },
    );
  });

  group('edge cases', () {
    test('should handle adding many API responses', () async {
      SharedPreferences.setMockInitialValues({});
      ChuckerUiHelper.settings = Settings.defaultObject().copyWith(
        apiThresholds: 100,
      );

      final mockedApis = List.generate(
        50,
        (i) => ApiResponse.mock().copyWith(
          requestTime: DateTime(2024, 1, 1, i),
          statusCode: 200 + i,
        ),
      );

      for (final api in mockedApis) {
        await sharedPreferencesManager.addApiResponse(api);
      }

      final savedApis = await sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, 50);
    });

    test('should handle deleting from empty list', () async {
      SharedPreferences.setMockInitialValues({});

      await sharedPreferencesManager
          .deleteAnApi(DateTime(2024).toString());

      final savedApis = await sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, 0);
    });

    test('should handle deleting non-existent API', () async {
      final mockedApi = ApiResponse.mock().copyWith(
        requestTime: DateTime(2024),
      );

      SharedPreferences.setMockInitialValues({});
      await sharedPreferencesManager.addApiResponse(mockedApi);

      await sharedPreferencesManager.deleteAnApi(
        DateTime(2024, 1, 2).toString(),
      );

      final savedApis = await sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, 1);
      expect(savedApis.first, mockedApi);
    });

    test('should handle deleting all selected items', () async {
      final mockedApis = List.generate(
        5,
        (i) => ApiResponse.mock().copyWith(
          requestTime: DateTime(2024, 1, i + 1),
        ),
      );

      SharedPreferences.setMockInitialValues({});

      for (final api in mockedApis) {
        await sharedPreferencesManager.addApiResponse(api);
      }

      await sharedPreferencesManager.deleteSelected(
        mockedApis.map((api) => api.requestTime.toString()).toList(),
      );

      final savedApis = await sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, 0);
    });

    test('should handle empty deleteSelected list', () async {
      final mockedApi = ApiResponse.mock();
      SharedPreferences.setMockInitialValues({});

      await sharedPreferencesManager.addApiResponse(mockedApi);

      await sharedPreferencesManager.deleteSelected([]);

      final savedApis = await sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, 1);
    });

    test('should maintain threshold when adding responses', () async {
      ChuckerUiHelper.settings = Settings.defaultObject().copyWith(
        apiThresholds: 3,
      );

      SharedPreferences.setMockInitialValues({});

      for (var i = 1; i <= 5; i++) {
        await sharedPreferencesManager.addApiResponse(
          ApiResponse.mock().copyWith(
            requestTime: DateTime(2024, 1, i),
            statusCode: 200 + i,
          ),
        );
      }

      final savedApis = await sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, 3);
      // Should keep the most recent 3
      expect(savedApis[0].statusCode, 205);
      expect(savedApis[1].statusCode, 204);
      expect(savedApis[2].statusCode, 203);
    });

    test('should handle threshold of zero', () async {
      ChuckerUiHelper.settings = Settings.defaultObject().copyWith(
        apiThresholds: 0,
      );

      SharedPreferences.setMockInitialValues({});

      await sharedPreferencesManager.addApiResponse(ApiResponse.mock());

      final savedApis = await sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, 0);
    });

    test('should handle large threshold values', () async {
      ChuckerUiHelper.settings = Settings.defaultObject().copyWith(
        apiThresholds: 10000,
      );

      SharedPreferences.setMockInitialValues({});

      for (var i = 0; i < 100; i++) {
        await sharedPreferencesManager.addApiResponse(
          ApiResponse.mock().copyWith(requestTime: DateTime(2024, 1, 1, i)),
        );
      }

      final savedApis = await sharedPreferencesManager.getAllApiResponses();
      expect(savedApis.length, 100);
    });

    test('should handle concurrent settings updates', () async {
      SharedPreferences.setMockInitialValues({});

      final settings1 = Settings.defaultObject().copyWith(apiThresholds: 50);
      final settings2 = Settings.defaultObject().copyWith(apiThresholds: 75);

      await sharedPreferencesManager.setSettings(settings1);
      await sharedPreferencesManager.setSettings(settings2);

      final savedSettings = await sharedPreferencesManager.getSettings();
      expect(savedSettings.apiThresholds, 75);
    });

    test('should handle API responses with same request time', () async {
      SharedPreferences.setMockInitialValues({});

      final sameTime = DateTime(2024, 1, 1, 12);
      final api1 = ApiResponse.mock().copyWith(
        requestTime: sameTime,
        statusCode: 200,
      );
      final api2 = ApiResponse.mock().copyWith(
        requestTime: sameTime,
        statusCode: 404,
      );

      await sharedPreferencesManager.addApiResponse(api1);
      await sharedPreferencesManager.addApiResponse(api2);

      final savedApis = await sharedPreferencesManager.getAllApiResponses();
      // Should handle duplicates somehow - either replace or keep both
      expect(savedApis.length, greaterThanOrEqualTo(1));
    });
  });
}
