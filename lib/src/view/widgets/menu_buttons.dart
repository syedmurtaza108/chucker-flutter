import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:flutter/material.dart';

///Menu items shown on chucker main page
class MenuButtons extends StatelessWidget {
  ///Menu items shown on chucker main page
  const MenuButtons({
    required this.enableDelete,
    required this.onDelete,
    required this.onSettings,
    Key? key,
  }) : super(key: key);

  ///Whether to enable delete button or not
  final bool enableDelete;

  ///Callback when delete pressed
  final VoidCallback onDelete;

  ///Callback when settings pressed
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (value) {
        if (value == 0) {
          onDelete();
        } else if (value == 1) {
          onSettings();
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 0,
          enabled: enableDelete,
          key: const ValueKey('menu_delete'),
          child: Text(Localization.strings['delete']!),
        ),
        PopupMenuItem(
          value: 1,
          key: const ValueKey('menu_settings'),
          child: Text(Localization.strings['settings']!),
        ),
      ],
    );
  }
}
