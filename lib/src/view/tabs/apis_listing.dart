import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/widgets/apis_listing_item.dart';
import 'package:flutter/material.dart';

///Shows the listing of api requests
class ApisListingTabView extends StatefulWidget {
  ///Shows the listing of all success api requests
  const ApisListingTabView({required this.apis, Key? key}) : super(key: key);

  ///The list of [ApiResponse] that to be shown in this page
  final List<ApiResponse> apis;

  @override
  State<ApisListingTabView> createState() => _ApisListingTabViewState();
}

class _ApisListingTabViewState extends State<ApisListingTabView> {
  @override
  Widget build(BuildContext context) {
    if (widget.apis.isEmpty) {
      return const Center(
        child: Text('No api response found at the moment'),
      );
    }
    return ListView.separated(
      itemBuilder: (_, i) {
        final api = widget.apis[i];
        return ApisListingItemWidget(
          baseUrl: api.baseUrl,
          dateTime: api.requestTime,
          method: api.method,
          path: api.path,
          statusCode: api.statusCode,
        );
      },
      separatorBuilder: (_, __) => const Divider(),
      itemCount: widget.apis.length,
    );
  }
}
