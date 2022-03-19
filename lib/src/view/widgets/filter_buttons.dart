import 'package:chucker_flutter/src/extensions.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/helper/method_enums.dart';
import 'package:flutter/material.dart';

///[FilterButtons] helps filtering api requests in apis listing screen
class FilterButtons extends StatelessWidget {
  ///[FilterButtons] helps filtering api requests in apis listing screen
  const FilterButtons({
    required this.onFilter,
    required this.httpMethod,
    Key? key,
  }) : super(key: key);

  ///Call back to handle http method filter change
  final void Function(HttpMethod) onFilter;

  ///HttpMethod filter type
  final HttpMethod httpMethod;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          PopupMenuButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Row(
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
          )
        ],
      ),
    );
  }

  PopupMenuEntry _radioButton(
    String text,
    HttpMethod httpMethod,
  ) {
    return PopupMenuItem(
      onTap: () {
        onFilter(httpMethod);
      },
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        dense: true,
        title: Text(text),
        leading: Radio<HttpMethod>(
          value: httpMethod,
          groupValue: this.httpMethod,
          onChanged: (HttpMethod? value) {},
        ),
      ),
    );
  }

  String _getMethodName() {
    switch (httpMethod) {
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
}
