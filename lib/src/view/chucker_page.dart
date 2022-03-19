import 'package:chucker_flutter/src/models/chucker_state.dart';
import 'package:chucker_flutter/src/view/tabs/summary_tab_view.dart';
import 'package:flutter/material.dart';

class ChuckerPage extends StatelessWidget {
  const ChuckerPage({
    required this.chuckerState,
    Key? key,
  }) : super(key: key);

  final ChuckerState chuckerState;

  static const _tabsHeadings = ['Summary', 'Request', 'Response'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TabBar(tabs: _tabsHeadings.map((e) => Tab(text: e)).toList()),
        body: const TabBarView(
          children: [
            SummaryTabView(),
            SummaryTabView(),
            SummaryTabView(),
          ],
        ),
      ),
    );
  }
}
