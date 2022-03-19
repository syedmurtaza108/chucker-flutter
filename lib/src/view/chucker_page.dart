import 'package:chucker_flutter/src/view/tabs/success_apis_listing.dart';
import 'package:chucker_flutter/src/view/tabs/summary_tab_view.dart';
import 'package:flutter/material.dart';

///The main screen of `chucker_flutter`
class ChuckerPage extends StatelessWidget {
  ///The main screen of `chucker_flutter`
  const ChuckerPage({Key? key}) : super(key: key);

  static const _tabsHeadings = ['Success Requests', 'Request', 'Response'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TabBar(tabs: _tabsHeadings.map((e) => Tab(text: e)).toList()),
        body: const TabBarView(
          children: [
            SuccessApisListingTabView(),
            SummaryTabView(),
            SummaryTabView(),
          ],
        ),
      ),
    );
  }
}
