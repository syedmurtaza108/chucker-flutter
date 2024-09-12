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
  var _jsonRequestPreviewType = _JsonPreviewType.tree;
  var _jsonResponsePreviewType = _JsonPreviewType.tree;

  @override
  Widget build(BuildContext context) {
    // deb('ApiDetailsPage build ${widget.api.toString()}');
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
                Share.share(
                  widget.api.toString(),
                  sharePositionOrigin: Rect.fromLTWH(
                    0,
                    0,
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height / 2,
                  ),
                );
              },
              icon: const Icon(Icons.share),
            ),
            TextButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: widget.api.toCurl()),
                );
              },
              child: const Text(
                'Copy cURL Command',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Material(
                  color: primaryColor,
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white.withOpacity(0.8),
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
                      _RequestTab(
                        jsonPreviewType: _jsonRequestPreviewType,
                        onShufflePreview: _shuffleRequestPreviewType,
                        json: widget.api.request,
                        prettyJson: widget.api.prettyJsonRequest,
                        apiResponse: widget.api,
                      ),
                      _ResponseTab(
                        jsonPreviewType: _jsonResponsePreviewType,
                        onShufflePreview: _shuffleResponsePreviewType,
                        json: widget.api.body,
                        prettyJson: widget.api.prettyJson,
                        apiResponse: widget.api,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _shuffleResponsePreviewType() {
    switch (_jsonResponsePreviewType) {
      case _JsonPreviewType.tree:
        setState(() => _jsonResponsePreviewType = _JsonPreviewType.text);
        break;
      case _JsonPreviewType.text:
        setState(() => _jsonResponsePreviewType = _JsonPreviewType.tree);
        break;
    }
  }

  void _shuffleRequestPreviewType() {
    switch (_jsonRequestPreviewType) {
      case _JsonPreviewType.tree:
        setState(() => _jsonRequestPreviewType = _JsonPreviewType.text);
        break;
      case _JsonPreviewType.text:
        setState(() => _jsonRequestPreviewType = _JsonPreviewType.tree);
        break;
    }
  }
}

class _PreviewModeControl extends StatelessWidget {
  const _PreviewModeControl({
    required this.jsonPreviewType,
    required this.onPreviewPressed,
    required this.onCopyPressed,
    Key? key,
  }) : super(key: key);

  final _JsonPreviewType jsonPreviewType;
  final VoidCallback onPreviewPressed;
  final VoidCallback onCopyPressed;

  @override
  Widget build(BuildContext context) {
    final type = jsonPreviewType == _JsonPreviewType.text
        ? Localization.strings['text']!
        : Localization.strings['tree']!;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                Localization.strings['jsonPreviewMode']!,
                style: context.textTheme.bodyMedium!
                    .toBold()
                    .withColor(primaryColor),
              ),
              SizeableTextButton(
                onPressed: onPreviewPressed,
                height: 34,
                text: type,
                style: context.textTheme.bodyMedium!.toBold(),
              ),
            ],
          ),
        ),
        Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: InkWell(
            key: const ValueKey('api_detail_copy'),
            onTap: onCopyPressed,
            borderRadius: BorderRadius.circular(24),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.copy, color: primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResponseTab extends StatelessWidget {
  const _ResponseTab({
    required this.apiResponse,
    required this.jsonPreviewType,
    required this.onShufflePreview,
    required this.json,
    required this.prettyJson,
    Key? key,
  }) : super(key: key);

  final ApiResponse apiResponse;
  final dynamic json;
  final String prettyJson;
  final _JsonPreviewType jsonPreviewType;
  final VoidCallback onShufflePreview;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: secondaryColor,
            boxShadow: [
              BoxShadow(
                color: secondaryColor.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: _PreviewModeControl(
            jsonPreviewType: jsonPreviewType,
            onCopyPressed: _copyJsonResponse,
            onPreviewPressed: onShufflePreview,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _renderJsonWidget(context),
          ),
        ),
      ],
    );
  }

  void _copyJsonResponse() {
    Clipboard.setData(ClipboardData(text: prettyJson));
  }

  Widget _renderJsonWidget(BuildContext context) {
    switch (jsonPreviewType) {
      case _JsonPreviewType.tree:
        return JsonTree(json: json);
      case _JsonPreviewType.text:
        return SizedBox(
          width: double.maxFinite,
          child: SelectableText(
            prettyJson,
            style: context.textTheme.bodyLarge,
            textDirection: TextDirection.ltr,
          ),
        );
    }
  }
}

class _RequestTab extends StatelessWidget {
  const _RequestTab({
    required this.apiResponse,
    required this.jsonPreviewType,
    required this.onShufflePreview,
    required this.json,
    required this.prettyJson,
    Key? key,
  }) : super(key: key);

  final ApiResponse apiResponse;
  final dynamic json;
  final String prettyJson;
  final _JsonPreviewType jsonPreviewType;
  final VoidCallback onShufflePreview;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: secondaryColor,
            boxShadow: [
              BoxShadow(
                color: secondaryColor.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: _PreviewModeControl(
            jsonPreviewType: jsonPreviewType,
            onCopyPressed: _copyJsonRequest,
            onPreviewPressed: onShufflePreview,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _renderJsonWidget(context),
          ),
        ),
      ],
    );
  }

  void _copyJsonRequest() {
    Clipboard.setData(ClipboardData(text: prettyJson));
  }

  Widget _renderJsonWidget(BuildContext context) {
    switch (jsonPreviewType) {
      case _JsonPreviewType.tree:
        return JsonTree(json: json);
      case _JsonPreviewType.text:
        return SizedBox(
          width: double.maxFinite,
          child: SelectableText(
            prettyJson,
            style: context.textTheme.bodyLarge,
            textDirection: TextDirection.ltr,
          ),
        );
    }
  }
}

enum _JsonPreviewType {
  tree,
  text,
}
