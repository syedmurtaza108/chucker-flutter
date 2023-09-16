part of '../json_tree.dart';

class _JsonObject extends StatefulWidget {
  const _JsonObject({
    required this.jsonObject,
    required this.showPadding,
    Key? key,
  }) : super(key: key);

  final Map<String, dynamic> jsonObject;
  final bool showPadding;

  @override
  State<_JsonObject> createState() => __JsonObjectState();
}

class __JsonObjectState extends State<_JsonObject> {
  Map<String, bool> open = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.showPadding
          ? const EdgeInsetsDirectional.only(start: 16)
          : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.jsonObject.entries.length,
          (i) {
            final entry = widget.jsonObject.entries.elementAt(i);
            final canExpand = _itemCanExpand(entry.value);
            final button = _itemCanShowButton(entry.value);
            return Column(
              children: [
                Row(
                  children: [
                    Visibility(
                      visible: canExpand && (open[entry.key] ?? false),
                      child:
                          const Icon(Icons.arrow_drop_down_rounded, size: 24),
                    ),
                    Visibility(
                      visible: canExpand && !(open[entry.key] ?? false),
                      child: const Icon(Icons.arrow_right_rounded, size: 24),
                    ),
                    Visibility(
                      visible: canExpand && button,
                      child: SizeableTextButton(
                        height: 32,
                        onPressed: () {
                          setState(() {
                            open[entry.key] = !(open[entry.key] ?? false);
                          });
                        },
                        text: entry.key,
                        style: context.textTheme.bodyLarge!.toBold(),
                      ),
                    ),
                    Visibility(
                      visible: !canExpand && !(open[entry.key] ?? false),
                      child: const SizedBox(width: 24),
                    ),
                    Visibility(
                      visible: !canExpand || !button,
                      child: Text(
                        '${entry.key}:',
                        style: context.textTheme.bodyMedium!.toBold(),
                      ),
                    ),
                    const SizedBox(width: 4),
                    _JsonValue(
                      value: entry.value,
                      onOpen: () {
                        setState(() {
                          open[entry.key] = !(open[entry.key] ?? false);
                        });
                      },
                    ),
                  ],
                ),
                Visibility(
                  visible: open[entry.key] ?? false,
                  child: _JsonRoot(rootObject: entry.value, showPadding: true),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
