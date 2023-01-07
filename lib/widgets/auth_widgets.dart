import 'package:flutter/material.dart';

import '../utilities/app_color.dart';

class AuthMainButton extends StatelessWidget {
  final String label;
  final Function() onTap;

  const AuthMainButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: AppColor.appPrimary,
        borderRadius: BorderRadius.circular(25.0),
        child: MaterialButton(
          minWidth: double.infinity,
          onPressed: onTap,
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class HaveAccount extends StatelessWidget {
  final String haveAccount;
  final String actionLabel;
  final Function() onTap;

  const HaveAccount(
      {Key? key,
      required this.onTap,
      required this.actionLabel,
      required this.haveAccount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(haveAccount,
            style:
                const TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic)),
        TextButton(
          child: Text(
            actionLabel,
            style: TextStyle(
                color: AppColor.appPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          onPressed: onTap,
        ),
      ],
    );
  }
}

class AuthHeaderLabel extends StatelessWidget {
  final String headerLabel;

  const AuthHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerLabel,
            style: const TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/welcome_screen');
              },
              icon: const Icon(Icons.home_work))
        ],
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide:
        BorderSide(color: AppColor.appPrimary.withOpacity(0.2), width: 1.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppColor.appPrimary, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppColor.appPrimary, width: 2.0),
  ),
);

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^[a-zA-Z0-9]+[\-\_\.]*[a-zA-Z0-9]*[@][a-zA-Z0-9]{2,}[\.][a-zA-Z]{2,3}$')
        .hasMatch(this);
  }
}
