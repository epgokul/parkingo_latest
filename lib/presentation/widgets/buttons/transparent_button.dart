import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  const TransparentButton(
      {super.key, required this.text, this.onTap, required this.color});
  final String text;
  final void Function()? onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
            color: color,
            border:
                Border.all(style: BorderStyle.solid, color: color, width: 3),
            borderRadius: BorderRadius.circular(50),
            backgroundBlendMode: BlendMode.dst),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: color),
          ),
        )),
      ),
    );
  }
}
