import 'dart:async';

import 'package:chucker_flutter/src/models/chucker_state.dart';
import 'package:chucker_flutter/src/shared_preferences_manager.dart';
import 'package:chucker_flutter/src/view/widgets/apis_listing_item.dart';
import 'package:flutter/material.dart';

///Shows the listing of all success api requests
class SuccessApisListingTabView extends StatefulWidget {
  ///Shows the listing of all success api requests
  const SuccessApisListingTabView({Key? key}) : super(key: key);

  @override
  State<SuccessApisListingTabView> createState() =>
      _SuccessApisListingTabViewState();
}

class _SuccessApisListingTabViewState extends State<SuccessApisListingTabView> {
  Future<BasicState> _getData() async {
    final sharedPreferencesManager = SharedPreferencesManager.getInstance();
    final list = await sharedPreferencesManager.getAllApiResponses();
    return SuccessState(apis: list);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BasicState>(
      future: _getData(),
      initialData: LoadingState(),
      builder: (context, snapshot) {
        if (snapshot.data is LoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final apis = (snapshot.data as SuccessState?)?.apis ?? List.empty();

        if (apis.isEmpty) {
          return const Center(
            child: Text('No api response found at the moment'),
          );
        }

        return ListView.separated(
          itemBuilder: (_, i) {
            final api = apis[i];
            return ApisListingItemWidget(
              baseUrl: api.baseUrl,
              dateTime: api.requestTime,
              method: api.method,
              path: api.path,
              statusCode: api.statusCode,
            );
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: apis.length,
        );
      },
    );
  }
}
