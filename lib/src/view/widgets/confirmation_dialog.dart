import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/localization/localization.dart';

import 'package:chucker_flutter/src/view/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog({
    required this.title,
    required this.message,
    this.yesButtonBackColor,
    this.yesButtonForeColor,
    Key? key,
  }) : super(key: key);

  final String title;
  final String message;
  final Color? yesButtonBackColor;
  final Color? yesButtonForeColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => context.navigator.pop(false),
          child: Text(
            Localization.strings['no']!,
            style: context.textTheme.bodyLarge!.withColor(Colors.black),
          ),
        ),
        PrimaryButton(
          text: Localization.strings['yes']!,
          onPressed: () => context.navigator.pop(true),
          foreColor: yesButtonForeColor,
          backColor: yesButtonBackColor,
        ),
      ],
    );
  }
}

///Shows the reusable confirmation dialog
Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  Color? yesButtonBackColor,
  Color? yesButtonForeColor,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ConfirmationDialog(
      title: title,
      message: message,
      yesButtonBackColor: yesButtonBackColor,
      yesButtonForeColor: yesButtonForeColor,
    ),
  );
}
