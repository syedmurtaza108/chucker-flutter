import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Status color should return proper with respect to status code', () {
    expect(statusColor(201), Colors.green);
    expect(statusColor(401), Colors.red);
    expect(statusColor(501), Colors.purple);
    expect(statusColor(601), Colors.orange);
  });

  test('Method color should return proper with respect to http method', () {
    expect(methodColor('get'), Colors.brown[600]);
    expect(methodColor('put'), Colors.blue[900]);
    expect(methodColor('post'), Colors.teal[700]);
    expect(methodColor('patch'), Colors.black);
    expect(methodColor('delete'), Colors.red);
    expect(methodColor('unidentified'), Colors.orangeAccent);
  });
}
