import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/localization/localization.dart';

import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/json_tree/json_tree.dart';
import 'package:chucker_flutter/src/view/tabs/overview.dart';
import 'package:chucker_flutter/src/view/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

///Shows detail of api request and response
class ApiDetailsPage extends StatelessWidget {
  ///Shows detail of api request and response

  const ApiDetailsPage({
    required this.api,
    Key? key,
  }) : super(key: key);

  ///[ApiResponse] of which detail is to be shown
  final ApiResponse api;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Localization.textDirection,
      child: Scaffold(
        appBar: ChuckerAppBar(
          onBackPressed: () => context.navigator.pop(),
          actions: [
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: api.toString()));
              },
              icon: const Icon(Icons.copy),
            ),
            IconButton(
              onPressed: () {
                Share.share(api.toString());
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Material(
                color: primaryColor,
                child: TabBar(
                  tabs: [
                    Tab(text: Localization.strings['overview']),
                    Tab(text: Localization.strings['request']),
                    Tab(text: Localization.strings['response']),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  key: const Key('api_detail_tabbar_view'),
                  children: [
                    OverviewTabView(api: api),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: JsonTree(json: api.request),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: JsonTree(json: api.body),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
