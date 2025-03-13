import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.text,
      required this.onTap,
      required this.color,
      required this.textColor,
      required this.width});
  final String text;
  final void Function() onTap;
  final Color color;
  final Color textColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
            child: Padding(
          padding:
              const EdgeInsets.only(left: 10.0, right: 10, top: 8, bottom: 8),
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: textColor),
          ),
        )),
      ),
    );
  }
}
