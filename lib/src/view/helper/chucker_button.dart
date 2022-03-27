import 'package:chucker_flutter/src/view/helper/chucker_ui_helper.dart';
import 'package:chucker_flutter/src/view/widgets/primary_button.dart';
import 'package:flutter/material.dart';

///[ChuckerButton] can be placed anywhere in the UI to open Chucker Screen
class ChuckerButton extends StatelessWidget {
  ///[ChuckerButton] can be placed anywhere in the UI to open Chucker Screen
  const ChuckerButton._({Key? key}) : super(key: key);

  static ChuckerButton? _button;

  ///[getInstance] returns the singleton object of [ChuckerButton]
  // ignore: prefer_constructors_over_static_methods
  static ChuckerButton getInstance() {
    return _button ??= const ChuckerButton._(key: Key('chucker_button'));
  }

  @override
  Widget build(BuildContext context) {
    return const PrimaryButton(
      text: 'Open Chucker Flutter',
      foreColor: Colors.white,
      onPressed: ChuckerUiHelper.showChuckerScreen,
    );
  }
}
