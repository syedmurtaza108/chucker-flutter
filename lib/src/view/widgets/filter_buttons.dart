import 'dart:async';

import 'package:chucker_flutter/src/extensions.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/helper/method_enums.dart';
import 'package:chucker_flutter/src/view/widgets/chucker_button.dart';
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
  var _openSearch = true;

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
                  : _popUpMenuButton(context),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 128,
            height: 48,
            child: ChuckerButton(
              text: _openSearch ? 'Show Filter' : 'Hide Filter',
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

  PopupMenuButton _popUpMenuButton(
    BuildContext context,
  ) {
    return PopupMenuButton(
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Http Method: '),
            Chip(
              label: Text(
                _getMethodName(),
                style: context.theme.textTheme.bodyText1!.copyWith(
                  color: Colors.white,
                ),
              ),
              backgroundColor: methodBackColor(_getMethodName()),
            )
          ],
        ),
      ),
      itemBuilder: (_) => [
        _radioButton('ALL', HttpMethod.none),
        _radioButton('GET', HttpMethod.get),
        _radioButton('POST', HttpMethod.post),
        _radioButton('PUT', HttpMethod.put),
        _radioButton('PATCH', HttpMethod.patch),
        _radioButton('DELETE', HttpMethod.delete),
      ],
    );
  }

  PopupMenuEntry _radioButton(
    String text,
    HttpMethod httpMethod,
  ) {
    return PopupMenuItem(
      onTap: () {
        widget.onFilter(httpMethod);
      },
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        dense: true,
        title: Text(text),
        leading: Radio<HttpMethod>(
          value: httpMethod,
          groupValue: widget.httpMethod,
          onChanged: (HttpMethod? value) {},
        ),
      ),
    );
  }

  String _getMethodName() {
    switch (widget.httpMethod) {
      case HttpMethod.get:
        return 'GET';
      case HttpMethod.post:
        return 'POST';
      case HttpMethod.put:
        return 'PUT';
      case HttpMethod.patch:
        return 'PATCH';
      case HttpMethod.delete:
        return 'DELETE';
      case HttpMethod.none:
        return 'ALL';
    }
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
        hintText: 'Base url, status code or date',
      ),
      onChanged: onSearch,
    );
  }
}
