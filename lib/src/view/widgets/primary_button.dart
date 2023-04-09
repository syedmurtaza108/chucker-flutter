import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:flutter/material.dart';

///Reusable elevated button
class PrimaryButton extends StatelessWidget {
  ///Reusable elevated button
  const PrimaryButton({
    required this.text,
    required this.onPressed,
    this.backColor,
    this.foreColor,
    this.padding,
    Key? key,
  }) : super(key: key);

  ///Callback
  final VoidCallback onPressed;

  ///Button title
  final String text;

  ///Background color
  final Color? backColor;

  ///Title color
  final Color? foreColor;

  ///Padding
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backColor ?? primaryColor,
        ),
        child: Text(
          text,
          style: context.textTheme.bodyLarge!.copyWith(color: foreColor),
        ),
      ),
    );
  }
}
