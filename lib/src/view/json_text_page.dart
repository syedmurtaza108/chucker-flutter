import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/view/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

///Shows json response in text form
class JsonTextPage extends StatelessWidget {
  ///Shows json response in text form
  const JsonTextPage({required this.json, Key? key}) : super(key: key);

  ///Json content
  final String json;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Localization.textDirection,
      child: Scaffold(
        appBar: ChuckerAppBar(
          onBackPressed: context.navigator.pop,
          actions: [
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: json));
              },
              icon: const Icon(Icons.copy),
            ),
            IconButton(
              onPressed: () => Share.share(json),
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: Text(json),
      ),
    );
  }
}
