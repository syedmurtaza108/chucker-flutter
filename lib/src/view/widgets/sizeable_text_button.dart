import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:flutter/material.dart';

///Resizeable Text Button
class SizeableTextButton extends StatelessWidget {
  ///Resizeable Text Button
  const SizeableTextButton({
    required this.onPressed,
    required this.text,
    this.height,
    this.width,
    this.style,
    Key? key,
  }) : super(key: key);

  ///height of text button
  final double? height;

  ///width of text button
  final double? width;

  ///text on text button
  final String text;

  ///Callback when it is pressed
  final VoidCallback onPressed;

  ///TextStyle applied to be on text
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: style ?? context.textTheme.bodySmall!.withColor(primaryColor),
        ),
      ),
    );
  }
}
