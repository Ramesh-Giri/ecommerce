import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  const YellowButton(
      {Key? key,
      required this.label,
      required this.onTap,
      required this.widthRation})
      : super(key: key);

  final String label;
  final Function() onTap;
  final double widthRation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.0,
      width: MediaQuery.of(context).size.width * widthRation,
      decoration: BoxDecoration(
          color: Colors.yellow, borderRadius: BorderRadius.circular(25)),
      child: MaterialButton(
        onPressed: onTap,
        child: Text(
          label,
        ),
      ),
    );
  }
}
