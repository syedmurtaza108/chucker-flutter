import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/localization/localization.dart';

import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:flutter/material.dart';

///[ApisListingItemWidget] renders the [ApiResponse] items in
///`ApisListingTabView`
class ApisListingItemWidget extends StatelessWidget {
  ///[ApisListingItemWidget] renders the [ApiResponse] items in
  ///1ApisListingTabView`
  const ApisListingItemWidget({
    required this.baseUrl,
    required this.dateTime,
    required this.method,
    required this.path,
    required this.statusCode,
    required this.onDelete,
    required this.checked,
    required this.onChecked,
    required this.showDelete,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  ///base url of api request such as `https://www.api.com`
  final String baseUrl;

  ///request path such as `/users`
  final String path;

  ///method type of api request such as GET, PUT, POST, DELETE
  final String method;

  ///status code of api response such as `200` for OK
  final int statusCode;

  ///Creation time of api request
  final DateTime dateTime;

  ///Callback to delete a request
  final void Function(String) onDelete;

  ///Used for selection
  final bool checked;

  ///Callback to select a request
  final void Function(String) onChecked;

  ///Whether to hide or show delete button
  final bool showDelete;

  ///Callback when user presses this instance
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const ValueKey('api_listing_item_widget'),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 68,
              child: Column(
                children: [
                  Chip(
                    backgroundColor: statusColor(statusCode),
                    label: Text(
                      statusCode.toString(),
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodySmall!.withColor(
                        Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: showDelete,
                    child: TextButton(
                      onPressed: () => onDelete(dateTime.toString()),
                      child: Text(
                        Localization.strings['delete']!,
                        style:
                            context.textTheme.bodySmall!.withColor(Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(
                        backgroundColor: methodColor(method),
                        label: Text(
                          method,
                          style: context.textTheme.bodySmall!
                              .toBold()
                              .withColor(Colors.white),
                        ),
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      Checkbox(
                        value: checked,
                        activeColor: Colors.green,
                        onChanged: (_) => onChecked(dateTime.toString()),
                      ),
                    ],
                  ),
                  Text(
                    path,
                    style: context.textTheme.bodySmall!.toBold(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    baseUrl.isEmpty ? Localization.strings['nA']! : baseUrl,
                    style: context.textTheme.bodySmall!.withColor(Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateTime.toString(),
                    style: context.textTheme.bodySmall!.withColor(Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
