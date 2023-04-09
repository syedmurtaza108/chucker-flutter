part of '../json_tree.dart';

class _JsonValue extends StatefulWidget {
  const _JsonValue({
    required this.value,
    required this.onOpen,
    Key? key,
  }) : super(key: key);

  final dynamic value;
  final VoidCallback onOpen;

  @override
  State<_JsonValue> createState() => _JsonValueState();
}

class _JsonValueState extends State<_JsonValue> {
  var _copied = false;

  @override
  Widget build(BuildContext context) {
    if (_itemCanExpand(widget.value)) {
      if (widget.value is List) {
        if ((widget.value as List).isEmpty) {
          return Text(
            'Empty List',
            style: context.textTheme.bodyMedium!.withColor(Colors.red),
          );
        }
        return SizeableTextButton(
          height: 32,
          onPressed: widget.onOpen,
          text: 'List[${(widget.value as List).length}]',
          style: context.textTheme.bodyMedium!.withColor(Colors.red),
        );
      }
      return SizeableTextButton(
        onPressed: widget.onOpen,
        height: 32,
        text: 'Object',
        style: context.textTheme.bodyMedium!.toBold(),
      );
    }
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Builder(
              builder: (_) {
                if (widget.value == null) {
                  return Text(
                    'N/A',
                    style: context.textTheme.bodyMedium!.withColor(Colors.red),
                  );
                }
                if (widget.value is int) {
                  return Text(
                    widget.value.toString(),
                    style: context.textTheme.bodyMedium!.withColor(
                      Colors.purple,
                    ),
                  );
                }
                if (widget.value is String) {
                  return Text(
                    '"${widget.value}"',
                    style: context.textTheme.bodyMedium!.withColor(Colors.blue),
                  );
                }
                if (widget.value is bool) {
                  return Text(
                    widget.value.toString(),
                    style: context.textTheme.bodyMedium!.withColor(
                      (widget.value as bool) ? Colors.green : Colors.red,
                    ),
                  );
                }
                return Text(
                  widget.value.toString(),
                  style: context.textTheme.bodyMedium!.withColor(
                    Colors.orangeAccent,
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: widget.value.toString().isImageUrl(),
            child: IconButton(
              splashRadius: 16,
              icon: const Icon(Icons.preview_rounded, color: primaryColor),
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => ImagePreviewDialog(
                    path: widget.value.toString(),
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: widget.value.toString().isNotEmpty,
            child: SizedBox(
              height: 34,
              width: 60,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _copied
                    ? const Center(child: Icon(Icons.done, color: primaryColor))
                    : SizeableTextButton(
                        height: 34,
                        onPressed: () async {
                          setState(() => _copied = true);
                          await Clipboard.setData(
                            ClipboardData(text: widget.value.toString()),
                          );
                          Future.delayed(
                            const Duration(seconds: 2),
                            () => setState(() => _copied = false),
                          );
                        },
                        text: Localization.strings['copy']!,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
