import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/helper/languages.dart';
import 'package:flutter/material.dart';

///Languages Menu
class LanguagesMenu extends StatefulWidget {
  ///Languages Menu
  const LanguagesMenu({
    required this.language,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  ///language
  final Language language;

  ///Call back to handle language change
  final void Function(Language) onSelect;

  @override
  State<LanguagesMenu> createState() => _LanguagesMenuState();
}

class _LanguagesMenuState extends State<LanguagesMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(child: Text(widget.language.name)),
      ),
      itemBuilder: (_) => Language.values.map(_radioButton).toList(),
    );
  }

  PopupMenuEntry<dynamic> _radioButton(Language language) {
    return PopupMenuItem(
      onTap: () {
        widget.onSelect(language);
      },
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        dense: true,
        title: Text(language.name),
        leading: Radio<Language>(
          value: language,
          groupValue: widget.language,
          onChanged: (_) {},
        ),
      ),
    );
  }
}
