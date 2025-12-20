import 'package:chucker_flutter/src/localization/localization.dart';
import 'package:chucker_flutter/src/view/image_preview_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ImagePreviewDialog', () {
    Widget buildTestWidget(String imagePath) {
      return MaterialApp(
        localizationsDelegates: [
          ...Localization.localizationsDelegates,
        ],
        supportedLocales: Localization.supportedLocales,
        home: Scaffold(
          body: ImagePreviewDialog(path: imagePath),
        ),
      );
    }

    testWidgets('should display AlertDialog', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget('https://example.com/image.png'));

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('should display close button', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget('https://example.com/image.png'));

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should have rounded corners', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget('https://example.com/image.png'));

      final alertDialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
      final shape = alertDialog.shape! as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('should display Image.network widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget('https://example.com/image.png'));

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should use provided path for image',
        (WidgetTester tester) async {
      const testPath = 'https://example.com/test-image.png';
      await tester.pumpWidget(buildTestWidget(testPath));

      final image = tester.widget<Image>(find.byType(Image));
      final networkImage = image.image as NetworkImage;
      expect(networkImage.url, testPath);
    });

    testWidgets('should display error when image fails to load',
        (WidgetTester tester) async {
      // Using an invalid URL that will fail to load
      await tester.pumpWidget(buildTestWidget('invalid-url'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(
        find.text(Localization.strings['imageCouldNotBeLoaded']!),
        findsOneWidget,
      );
    });

    testWidgets('should close dialog when close button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            Localization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: Localization.supportedLocales,
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => const ImagePreviewDialog(
                        path: 'https://example.com/image.png',
                      ),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              );
            },
          ),
        ),
      );

      // Open the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(ImagePreviewDialog), findsOneWidget);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.byType(ImagePreviewDialog), findsNothing);
    });

    testWidgets('should have centered image', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget('https://example.com/image.png'));

      final center = find.ancestor(
        of: find.byType(Image),
        matching: find.byType(Center),
      );
      expect(center, findsOneWidget);
    });

    testWidgets('should use full screen size for content',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget('https://example.com/image.png'));

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(SizedBox),
        ),
      );

      final view = tester.view;
      final screenSize = view.physicalSize / view.devicePixelRatio;
      expect(sizedBox.height, screenSize.height);
      expect(sizedBox.width, screenSize.width);
    });

    testWidgets('should stack close button on top of image',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget('https://example.com/image.png'));

      expect(find.byType(Stack), findsOneWidget);

      final stack = tester.widget<Stack>(find.byType(Stack));
      expect(stack.children.length, 2);
    });

    testWidgets('should position close button at top end',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget('https://example.com/image.png'));

      final align = tester.widget<Align>(
        find.ancestor(
          of: find.byIcon(Icons.close),
          matching: find.byType(Align),
        ),
      );

      expect(align.alignment, AlignmentDirectional.topEnd);
    });

    testWidgets('should display red close icon', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget('https://example.com/image.png'));

      final iconButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.close),
          matching: find.byType(IconButton),
        ),
      );

      final icon = iconButton.icon as Icon;
      expect(icon.color, Colors.red);
    });

    testWidgets('should handle different image paths',
        (WidgetTester tester) async {
      final imagePaths = [
        'https://example.com/image1.png',
        'https://example.com/image2.jpg',
        'https://example.com/image3.gif',
      ];

      for (final path in imagePaths) {
        await tester.pumpWidget(buildTestWidget(path));

        final image = tester.widget<Image>(find.byType(Image));
        final networkImage = image.image as NetworkImage;
        expect(networkImage.url, path);
      }
    });

    testWidgets('error message should be displayed in red',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget('invalid-url'));
      await tester.pumpAndSettle();

      final errorText = tester.widget<Text>(
        find.text(Localization.strings['imageCouldNotBeLoaded']!),
      );
      expect(errorText.style!.color, Colors.red);
    });
  });
}
