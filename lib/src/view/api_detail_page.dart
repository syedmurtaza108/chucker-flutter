import 'package:chucker_flutter/src/extensions.dart';
import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/tabs/overview.dart';
import 'package:chucker_flutter/src/view/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
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
    return Scaffold(
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
            const Material(
              color: primaryColor,
              child: TabBar(
                tabs: [
                  Tab(text: 'OVERVIEW'),
                  Tab(text: 'REQUEST'),
                  Tab(text: 'RESPONSE'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  OverviewTabView(api: api),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: JsonViewer(api.request),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: JsonViewer(api.body),
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
