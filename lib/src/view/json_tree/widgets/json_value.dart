part of '../json_tree.dart';

class _JsonValue extends StatelessWidget {
  const _JsonValue({
    required this.value,
    required this.onOpen,
    Key? key,
  }) : super(key: key);

  final dynamic value;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    if (_itemCanExpand(value)) {
      if (value is List) {
        if ((value as List).isEmpty) {
          return Text(
            'Empty List',
            style: context.theme.textTheme.bodyText2!.copyWith(
              color: Colors.red,
            ),
          );
        }
        return SizeableTextButton(
          height: 32,
          onPressed: onOpen,
          text: 'List[${(value as List).length}]',
          style: context.theme.textTheme.bodyText2!.copyWith(
            color: Colors.red,
          ),
        );
      }
      return SizeableTextButton(
        onPressed: onOpen,
        height: 32,
        text: 'Object',
        style: context.theme.textTheme.bodyText2!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Builder(
              builder: (_) {
                if (value == null) {
                  return Text(
                    'N/A',
                    style: context.theme.textTheme.bodyText2!.copyWith(
                      color: Colors.red,
                    ),
                  );
                }
                if (value is int) {
                  return Text(
                    value.toString(),
                    style: context.theme.textTheme.bodyText2!.copyWith(
                      color: Colors.purple,
                    ),
                  );
                }
                if (value is String) {
                  return Text(
                    '"$value"',
                    style: context.theme.textTheme.bodyText2!.copyWith(
                      color: Colors.blue,
                    ),
                  );
                }
                if (value is bool) {
                  return Text(
                    value.toString(),
                    style: context.theme.textTheme.bodyText2!.copyWith(
                      color: (value as bool) ? Colors.green : Colors.red,
                    ),
                  );
                }
                return Text(
                  value.toString(),
                  style: context.theme.textTheme.bodyText2!.copyWith(
                    color: Colors.orangeAccent,
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: value.toString().isNotEmpty,
            child: SizeableTextButton(
              height: 34,
              onPressed: () => Clipboard.setData(
                ClipboardData(text: value.toString()),
              ),
              text: Localization.strings['copy']!,
            ),
          ),
        ],
      ),
    );
  }
}
