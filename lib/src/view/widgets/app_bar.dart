import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:flutter/material.dart';

///Reusable appbar
class ChuckerAppBar extends StatefulWidget implements PreferredSizeWidget {
  ///Reusable appbar
  const ChuckerAppBar({
    required this.onBackPressed,
    this.actions,
    Key? key,
  }) : super(key: key);

  ///A list of Widgets to display in a row after the title
  final List<Widget>? actions;

  ///Callback when back button pressed
  final VoidCallback onBackPressed;

  @override
  State<ChuckerAppBar> createState() => _ChuckerAppBarState();

  @override
  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _ChuckerAppBarState extends State<ChuckerAppBar> {
  @override
  Widget build(BuildContext _) {
    return AppBar(
      backgroundColor: primaryColor,
      title: Text(
        'Chucker Flutter',
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: Colors.white),
      ),
      leading: IconButton(
        key: const ValueKey('chucker_back_button'),
        icon: const Icon(Icons.arrow_back),
        onPressed: widget.onBackPressed,
      ),
      actions: widget.actions,
    );
  }
}
