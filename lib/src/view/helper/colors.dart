import 'package:flutter/material.dart';

///main color used for `chucker_flutter`
const primaryColor = Color(0xFF01569a);

///secondary color used in UI
const secondaryColor = Color(0xFFd5d8ff);

///Render background color with respect to api status code
Color statusColor(int statusCode) {
  if (statusCode > 199 && statusCode < 300) {
    return Colors.green;
  } else if (statusCode > 399 && statusCode < 500) {
    return Colors.red;
  } else if (statusCode > 499 && statusCode < 600) {
    return Colors.purple;
  }
  return Colors.orange;
}

///Render background color with respect to api method
Color methodColor(String method) {
  final lMethod = method.toLowerCase();
  if (lMethod.contains('get')) {
    return Colors.brown[600]!;
  } else if (lMethod.contains('put')) {
    return Colors.blue[900]!;
  } else if (lMethod.contains('post')) {
    return Colors.teal[700]!;
  } else if (lMethod.contains('patch')) {
    return Colors.black;
  } else if (lMethod.contains('delete')) {
    return Colors.red;
  }
  return Colors.orangeAccent;
}
