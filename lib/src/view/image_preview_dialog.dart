import 'package:chucker_flutter/src/helpers/extensions.dart';
import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:flutter/material.dart';

///It shows image preview if possible otherwise shows error
class ImagePreviewDialog extends StatelessWidget {
  ///It shows image preview if possible otherwise shows error
  const ImagePreviewDialog({required this.path, Key? key}) : super(key: key);

  ///Path of image to be shown
  final String path;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Center(
              child: Image.network(
                path,
                errorBuilder: (_, __, ___) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(
                      Localization.strings['imageCouldNotBeLoaded']!,
                      style: context.textTheme.bodyLarge!.withColor(Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: IconButton(
                splashRadius: 16,
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: Navigator.of(context).pop,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
