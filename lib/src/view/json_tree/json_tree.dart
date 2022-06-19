import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/image_preview_dialog.dart';
import 'package:chucker_flutter/src/view/widgets/sizeable_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part './widgets/json_list.dart';
part './widgets/json_root.dart';
part './widgets/json_object.dart';
part './widgets/json_value.dart';

///A widget to show json in tree form
class JsonTree extends StatefulWidget {
  ///A widget to show json in tree form
  const JsonTree({
    required this.json,
    Key? key,
  }) : super(key: key);

  ///Json object which is to be shown
  final dynamic json;
  @override
  State<JsonTree> createState() => _JsonTreeState();
}

class _JsonTreeState extends State<JsonTree> {
  @override
  Widget build(BuildContext context) {
    return _JsonRoot(rootObject: widget.json, showPadding: false);
  }
}

bool _itemCanExpand(dynamic item) {
  return item != null &&
      item is! double &&
      item is! int &&
      item is! String &&
      item is! bool;
}

bool _itemCanShowButton(dynamic item) {
  return _itemCanExpand(item) && (item is! List || item.isNotEmpty);
}
