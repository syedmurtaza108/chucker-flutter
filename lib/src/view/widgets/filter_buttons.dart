import 'dart:async';

import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/helper/http_methods.dart';
import 'package:chucker_flutter/src/view/widgets/http_methods_menu.dart';
import 'package:chucker_flutter/src/view/widgets/primary_button.dart';
import 'package:flutter/material.dart';

///[FilterButtons] helps filtering api requests in apis listing screen
class FilterButtons extends StatefulWidget {
  ///[FilterButtons] helps filtering api requests in apis listing screen
  const FilterButtons({
    required this.onFilter,
    required this.httpMethod,
    required this.onSearch,
    required this.query,
    Key? key,
  }) : super(key: key);

  ///Call back to handle http method filter change
  final void Function(HttpMethod) onFilter;

  ///HttpMethod filter type
  final HttpMethod httpMethod;

  ///Callback to handle search
  final void Function(String) onSearch;

  ///Initial query assigned to search field
  final String query;

  @override
  State<FilterButtons> createState() => _FilterButtonsState();
}

class _FilterButtonsState extends State<FilterButtons> {
  var _openSearch = false;

  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _openSearch
                  ? SizedBox(
                      height: 48,
                      child: _SearchField(
                        onSearch: _onSearch,
                        query: widget.query,
                      ),
                    )
                  : HttpMethodsMenu(
                      httpMethod: widget.httpMethod,
                      onFilter: widget.onFilter,
                    ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 128,
            height: 48,
            child: PrimaryButton(
              text: !_openSearch
                  ? Localization.strings['showSearch']!
                  : Localization.strings['hideSearch']!,
              onPressed: () => setState(() => _openSearch = !_openSearch),
              foreColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _onSearch(String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.onSearch,
    required this.query,
    Key? key,
  }) : super(key: key);

  final void Function(String) onSearch;
  final String query;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const ValueKey('search_field'),
      controller: TextEditingController()
        ..text = query
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: query.length),
        ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
        hintText: 'Base url, status code, date',
      ),
      onChanged: onSearch,
    );
  }
}
