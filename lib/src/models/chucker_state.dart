import 'package:chucker_flutter/src/models/api_response.dart';
import 'package:chucker_flutter/src/view/tabs/success_apis_listing.dart';

///Basic state of Chucker Screen
class BasicState {}

///Loading state of Chucker Screen
class LoadingState extends BasicState {}

///Success state of Chucker Screen
class SuccessState extends BasicState {
  ///Success state of Chucker Screen
  SuccessState({required this.apis});
  ///List of [ApiResponse] to be shown in [SuccessApisListingTabView]
  final List<ApiResponse> apis;
}
