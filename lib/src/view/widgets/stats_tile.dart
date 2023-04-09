import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:flutter/material.dart';

///Shows statistics of api requests as summary
class StatsTile extends StatelessWidget {
  ///Shows statistics of api requests as summary
  const StatsTile({
    required this.stats,
    required this.title,
    required this.backColor,
    Key? key,
  }) : super(key: key);

  ///Title of title
  final String title;

  ///Statistics to be shown
  final String stats;

  ///Tile background color
  final Color backColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: backColor,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              stats,
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall!.toBold(),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall!.toBold(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
