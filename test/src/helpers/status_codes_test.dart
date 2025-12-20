import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('status phrases should not be duplicated', () {
    var isDuplicate = false;

    final phrases = List<String>.empty(growable: true);
    for (final phrase in statusCodes.values) {
      if (phrases.contains(phrase)) {
        isDuplicate = true;
        break;
      }
      phrases.add(phrase);
    }

    expect(isDuplicate, false);
  });

  test('should contain common HTTP status codes', () {
    // Successful responses
    expect(statusCodes.containsKey(200), true); // OK
    expect(statusCodes.containsKey(201), true); // Created
    expect(statusCodes.containsKey(204), true); // No Content

    // Redirection messages
    expect(statusCodes.containsKey(301), true); // Moved Permanently
    expect(statusCodes.containsKey(302), true); // Found

    // Client error responses
    expect(statusCodes.containsKey(400), true); // Bad Request
    expect(statusCodes.containsKey(401), true); // Unauthorized
    expect(statusCodes.containsKey(403), true); // Forbidden
    expect(statusCodes.containsKey(404), true); // Not Found

    // Server error responses
    expect(statusCodes.containsKey(500), true); // Internal Server Error
    expect(statusCodes.containsKey(502), true); // Bad Gateway
    expect(statusCodes.containsKey(503), true); // Service Unavailable
  });

  test('should not contain empty phrases', () {
    for (final phrase in statusCodes.values) {
      expect(phrase.isNotEmpty, true);
    }
  });

  test('should have proper descriptions for status codes', () {
    expect(statusCodes[200], 'OK');
    expect(statusCodes[201], 'Created');
    expect(statusCodes[400], 'Bad Request');
    expect(statusCodes[401], 'Unauthorized');
    expect(statusCodes[404], 'Not Found');
    expect(statusCodes[500], 'Internal Server Error');
  });

  test('should return null for unknown status codes', () {
    expect(statusCodes[999], null);
    expect(statusCodes[100], isNotNull); // Continue is a valid code
  });

  test('status codes map should not be empty', () {
    expect(statusCodes.isNotEmpty, true);
    expect(statusCodes.length, greaterThan(40));
  });

  test('should have 2xx success status codes', () {
    final successCodes = [200, 201, 202, 203, 204];
    for (final code in successCodes) {
      expect(statusCodes.containsKey(code), true);
    }
  });

  test('should have 3xx redirection status codes', () {
    final redirectCodes = [300, 301, 302, 303, 304];
    for (final code in redirectCodes) {
      expect(statusCodes.containsKey(code), true);
    }
  });

  test('should have 4xx client error status codes', () {
    final clientErrorCodes = [400, 401, 402, 403, 404, 405];
    for (final code in clientErrorCodes) {
      expect(statusCodes.containsKey(code), true);
    }
  });

  test('should have 5xx server error status codes', () {
    final serverErrorCodes = [500, 501, 502, 503, 504];
    for (final code in serverErrorCodes) {
      expect(statusCodes.containsKey(code), true);
    }
  });

  test('status code keys should be integers', () {
    for (final key in statusCodes.keys) {
      expect(key, isA<int>());
      expect(key >= 100 && key < 600, true);
    }
  });

  test('status phrases should be strings', () {
    for (final phrase in statusCodes.values) {
      expect(phrase, isA<String>());
    }
  });
}
