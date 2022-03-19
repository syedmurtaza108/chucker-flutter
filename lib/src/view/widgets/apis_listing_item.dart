import 'package:chucker_flutter/src/extensions.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Chip(
            backgroundColor: statusCodeBackColor(statusCode),
            label: Text(
              statusCode.toString(),
              textAlign: TextAlign.center,
              style: context.theme.textTheme.bodyText1!.copyWith(
                color: Colors.white,
              ),
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
                      backgroundColor: methodBackColor(method),
                      label: Text(
                        method,
                        style: context.theme.textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      path,
                      style: context.theme.textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      baseUrl.isEmpty ? 'N/A' : baseUrl,
                      style: context.theme.textTheme.bodyText2!
                          .copyWith(color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      dateTime.toString(),
                      style: context.theme.textTheme.bodyText2!
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
