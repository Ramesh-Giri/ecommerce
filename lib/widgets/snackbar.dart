import 'package:MON_PARFUM/utilities/app_color.dart';
import 'package:flutter/material.dart';

class MessageHandler {
  static void showSnackBar(_scaffoldKey, message) {
    _scaffoldKey.currentState!.hideCurrentSnackBar();

    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: AppColor.appPrimary.withOpacity(0.8),
    ));
  }
}
