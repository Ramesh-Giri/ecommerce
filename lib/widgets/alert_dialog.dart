import 'package:flutter/cupertino.dart';

class MyAlertDialog {
  static void showMyDialog(
    context, {
    required String title,
    required String description,
    required Function() tapNo,
    required Function() tapYes,
  }) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(description),
              actions: [
                CupertinoDialogAction(
                  child: const Text('No'),
                  onPressed: tapNo,
                ),
                CupertinoDialogAction(
                  child: const Text('Yes'),
                  isDestructiveAction: true,
                  onPressed: tapYes,
                ),
              ],
            ));
  }
}
