import 'package:chucker_flutter/src/loggers/logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Logger', () {
    test('should log formatted json for valid json string', () {
      const jsonString = '{"name": "John", "age": 30}';
      
      // This should not throw any exceptions
      expect(() => Logger.json(jsonString), returnsNormally);
    });

    test('should log formatted json with isRequest flag true', () {
      const jsonString = '{"request": "data"}';
      
      expect(() => Logger.json(jsonString, isRequest: true), returnsNormally);
    });

    test('should handle invalid json gracefully', () {
      const invalidJson = 'not a valid json';
      
      // Should not throw, just log the error
      expect(() => Logger.json(invalidJson), returnsNormally);
    });

    test('should log request message', () {
      const requestMessage = 'GET /api/users';
      
      expect(() => Logger.request(requestMessage), returnsNormally);
    });

    test('should log response message', () {
      const responseMessage = '200 OK';
      
      expect(() => Logger.response(responseMessage), returnsNormally);
    });

    test('should handle empty json string', () {
      const emptyJson = '{}';
      
      expect(() => Logger.json(emptyJson), returnsNormally);
    });

    test('should handle json array', () {
      const jsonArray = '[1, 2, 3, 4, 5]';
      
      expect(() => Logger.json(jsonArray), returnsNormally);
    });

    test('should handle nested json objects', () {
      const nestedJson =
          '{"user": {"name": "John", "address": {"city": "NYC"}}}';
      
      expect(() => Logger.json(nestedJson), returnsNormally);
    });
  });
}
