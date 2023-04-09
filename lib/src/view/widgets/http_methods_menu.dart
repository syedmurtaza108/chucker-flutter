import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/localization/localization.dart';

import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/helper/http_methods.dart';
import 'package:flutter/material.dart';

///Http Methods Menu
class HttpMethodsMenu extends StatefulWidget {
  ///Http Methods Menu
  const HttpMethodsMenu({
    required this.httpMethod,
    required this.onFilter,
    Key? key,
  }) : super(key: key);

  ///HttpMethod filter type
  final HttpMethod httpMethod;

  ///Call back to handle http method filter change
  final void Function(HttpMethod) onFilter;

  @override
  State<HttpMethodsMenu> createState() => _HttpMethodsMenuState();
}

class _HttpMethodsMenuState extends State<HttpMethodsMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Http Method: '),
              Chip(
                label: Text(
                  _getMethodName(),
                  style: context.textTheme.bodyLarge!.withColor(Colors.white),
                ),
                backgroundColor: methodColor(_getMethodName()),
              )
            ],
          ),
        ),
      ),
      itemBuilder: (_) => [
        _radioButton(Localization.strings['all']!, HttpMethod.none),
        _radioButton('GET', HttpMethod.get),
        _radioButton('POST', HttpMethod.post),
        _radioButton('PUT', HttpMethod.put),
        _radioButton('PATCH', HttpMethod.patch),
        _radioButton('DELETE', HttpMethod.delete),
      ],
    );
  }

  PopupMenuEntry<dynamic> _radioButton(
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
        return Localization.strings['all']!;
    }
  }
}
