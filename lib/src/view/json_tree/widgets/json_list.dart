part of '../json_tree.dart';

class _JsonList extends StatefulWidget {
  const _JsonList({
    required this.showPadding,
    required this.jsonObjects,
    Key? key,
  }) : super(key: key);

  final List<dynamic> jsonObjects;
  final bool showPadding;

  @override
  State<_JsonList> createState() => __JsonListState();
}

class __JsonListState extends State<_JsonList> {
  late List<bool> isObjectExpends = List.filled(
    widget.jsonObjects.length,
    false,
  );

  @override
  Widget build(BuildContext context) {
    final padding = widget.showPadding
        ? const EdgeInsetsDirectional.only(start: 16)
        : EdgeInsets.zero;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.jsonObjects.length, (i) {
          final object = widget.jsonObjects[i];
          final canExpand = _itemCanExpand(object);
          final button = _itemCanShowButton(object);

          return Column(
            children: [
              Row(
                children: [
                  Visibility(
                    visible: canExpand && isObjectExpends[i],
                    child: const Icon(Icons.arrow_drop_down_rounded, size: 24),
                  ),
                  Visibility(
                    visible: !isObjectExpends[i],
                    child: const Icon(Icons.arrow_right_rounded, size: 24),
                  ),
                  Visibility(
                    visible: canExpand && button,
                    child: SizeableTextButton(
                      height: 32,
                      onPressed: () {
                        setState(
                          () => isObjectExpends[i] = !isObjectExpends[i],
                        );
                      },
                      text: '[$i]:',
                      style: context.textTheme.bodyLarge!.toBold(),
                    ),
                  ),
                  Visibility(
                    visible: !canExpand || !button,
                    child: Text(
                      '[$i]:',
                      style: context.textTheme.bodyMedium!.toBold(),
                    ),
                  ),
                  const SizedBox(width: 3),
                  _JsonValue(
                    value: object,
                    onOpen: () {
                      setState(() {
                        isObjectExpends[i] = !isObjectExpends[i];
                      });
                    },
                  ),
                ],
              ),
              Visibility(
                visible: isObjectExpends[i],
                child: _JsonRoot(rootObject: object, showPadding: true),
              ),
            ],
          );
        }),
      ),
    );
  }
}
