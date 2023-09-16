import 'package:chucker_flutter/src/helpers/extensions.dart';

import 'package:chucker_flutter/src/helpers/status_code_map.dart';
import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/widgets/sizeable_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Shows the api response summary
class OverviewTabView extends StatelessWidget {
  ///Shows the api response summary
  const OverviewTabView({
    required this.api,
    Key? key,
  }) : super(key: key);

  ///The item of which summary is to be shown
  final ApiResponse api;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Table(
        border: TableBorder.all(),
        columnWidths: const {0: FixedColumnWidth(100)},
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey[300]),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  Localization.strings['attribute']!,
                  style: context.textTheme.bodyMedium!.toBold().withSize(16),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  Localization.strings['value']!,
                  style: context.textTheme.bodyMedium!.toBold().withSize(16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          _dataRow(context, attribute: 'Base URL', value: api.baseUrl),
          _dataRow(context, attribute: 'Path', value: api.path),
          _dataRow(
            context,
            attribute: 'Method',
            value: api.method,
            valueColor: methodColor(api.method),
          ),
          _dataRow(
            context,
            attribute: 'Status Code',
            value: '${api.statusCode} (${statusCodes[api.statusCode]})',
            valueColor: statusColor(api.statusCode),
          ),
          _dataRow(
            context,
            attribute: 'Request Time',
            value: api.requestTime.toString(),
          ),
          _dataRow(
            context,
            attribute: 'Response Time',
            value: api.responseTime.toString(),
          ),
          _dataRow(context, attribute: 'Headers', value: api.headers),
          _dataRow(
            context,
            attribute: 'Query Parameters',
            value: api.queryParameters,
          ),
          _dataRow(
            context,
            attribute: 'Content Type',
            value: api.contentType ?? 'N/A',
          ),
          _dataRow(
            context,
            attribute: 'Response Type',
            value: api.responseType,
          ),
          _dataRow(
            context,
            attribute: 'Client Library',
            value: api.clientLibrary,
          ),
          _dataRow(
            context,
            attribute: 'Connection Timeout',
            value: api.connectionTimeout.isNotZero
                ? '${api.connectionTimeout} ms'
                : 'N/A',
          ),
          _dataRow(
            context,
            attribute: 'Receive Timeout',
            value: api.receiveTimeout.isNotZero
                ? '${api.receiveTimeout} ms'
                : 'N/A',
          ),
          _dataRow(
            context,
            attribute: 'Send Timeout',
            value: api.sendTimeout.isNotZero ? '${api.sendTimeout} ms' : 'N/A',
          ),
        ],
      ),
    );
  }

  TableRow _dataRow(
    BuildContext context, {
    required String attribute,
    required String value,
    Color? valueColor,
  }) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              attribute,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: context.textTheme.bodySmall!.withColor(valueColor),
                  ),
                ),
                const SizedBox(width: 8),
                SizeableTextButton(
                  onPressed: () =>
                      Clipboard.setData(ClipboardData(text: value)),
                  text: Localization.strings['copy']!,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
