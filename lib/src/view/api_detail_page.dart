import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/localization/localization.dart';

import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/helper/colors.dart';
import 'package:chucker_flutter/src/view/json_tree/json_tree.dart';
import 'package:chucker_flutter/src/view/tabs/overview.dart';
import 'package:chucker_flutter/src/view/widgets/app_bar.dart';
import 'package:chucker_flutter/src/view/widgets/sizeable_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

///Shows detail of api request and response
class ApiDetailsPage extends StatefulWidget {
  ///Shows detail of api request and response

  const ApiDetailsPage({required this.api, Key? key}) : super(key: key);

  ///[ApiResponse] of which detail is to be shown
  final ApiResponse api;

  @override
  State<ApiDetailsPage> createState() => _ApiDetailsPageState();
}

class _ApiDetailsPageState extends State<ApiDetailsPage> {
  final json = {
    'id': 1,
    'name': 'Syed Murtaza',
    'weight': 56.8,
    'isInPakistan': true,
    'favoritePersonalities': ['Allama Iqbal', 'Muhammad Ali Jinnah'],
    'ids': 1,
    'names': 'Syed Murtaza',
    'weights': 56.8,
    'isInPaksistan': true,
    'favoritesPersonalities': ['Allama Iqbal', 'Muhammad Ali Jinnah']
  };

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
                Clipboard.setData(ClipboardData(text: widget.api.toString()));
              },
              icon: const Icon(Icons.copy),
            ),
            IconButton(
              onPressed: () {
                Share.share(widget.api.toString());
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
                    OverviewTabView(api: widget.api),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: JsonTree(json: widget.api.request),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizeableTextButton(
                                onPressed: () {},
                                height: 32,
                                text: 'Object',
                                style: context.textTheme.bodyText2,
                              ),
                              SizeableTextButton(
                                onPressed: () {},
                                height: 32,
                                text: 'Object',
                                style: context.textTheme.bodyText2!.toBold(),
                              )
                            ],
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: JsonTree(
                              json: json,
                            ),
                          ),
                        ],
                      ),
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
