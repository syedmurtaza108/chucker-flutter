part of '../json_tree.dart';

class _JsonRoot extends StatelessWidget {
  const _JsonRoot({
    required this.rootObject,
    required this.showPadding,
    Key? key,
  }) : super(key: key);

  final dynamic rootObject;
  final bool showPadding;

  @override
  Widget build(BuildContext context) {
    if (rootObject == null) {
      return const SizedBox.shrink();
    }
    if (rootObject is List) {
      return _JsonList(
        jsonObjects: rootObject as List<dynamic>,
        showPadding: showPadding,
      );
    }

    if (rootObject is Map<String, dynamic>) {
      return _JsonObject(
        jsonObject: rootObject as Map<String, dynamic>,
        showPadding: showPadding,
      );
    }
    return _JsonObject(
      jsonObject: const {},
      showPadding: showPadding,
    );
  }
}
