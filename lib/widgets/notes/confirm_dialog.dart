import 'package:flutter/cupertino.dart';

Future<bool?> showConfirmDialog(
    BuildContext context, String title, String content) {
  return showCupertinoDialog<bool>(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            isDefaultAction: false,
            isDestructiveAction: false,
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            isDefaultAction: true,
            isDestructiveAction: true,
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
