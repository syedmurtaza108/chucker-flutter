import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:flutter/material.dart';

///Alignment Menu for settings page
class AlignmentMenu extends StatefulWidget {
  ///Alignment Menu for settings page
  const AlignmentMenu({
    required this.notificationAlignment,
    required this.title,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  ///Assigned alignment
  final Alignment notificationAlignment;

  ///Menu button title
  final String title;

  ///Callback when an alignment selected
  final void Function(Alignment) onSelect;

  @override
  State<AlignmentMenu> createState() => _AlignmentMenuState();
}

class _AlignmentMenuState extends State<AlignmentMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(child: Text(widget.title)),
      ),
      itemBuilder: (_) => [
        _radioButton('BottomCenter', Alignment.bottomCenter),
        _radioButton('BottomLeft', Alignment.bottomLeft),
        _radioButton('BottomRight', Alignment.bottomRight),
        _radioButton('Center', Alignment.center),
        _radioButton('CenterLeft', Alignment.centerLeft),
        _radioButton('CenterRight', Alignment.centerRight),
        _radioButton('TopCenter', Alignment.topCenter),
        _radioButton('TopLeft', Alignment.topLeft),
        _radioButton('TopRight', Alignment.topRight),
      ],
    );
  }

  PopupMenuEntry<dynamic> _radioButton(
    String text,
    Alignment notificationAlignment,
  ) {
    return PopupMenuItem(
      onTap: () {
        widget.onSelect(notificationAlignment);
      },
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        dense: true,
        title: Text(text),
        leading: Radio<Alignment>(
          value: notificationAlignment,
          groupValue: widget.notificationAlignment,
          onChanged: (_) {},
        ),
      ),
    );
  }
}
