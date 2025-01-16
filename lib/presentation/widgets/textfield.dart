import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield(
      {super.key,
      required this.obscureText,
      required this.normalBorderColor,
      required this.focusedBorderColor,
      required this.controller,
      required this.keyboardType,
      this.hintText,
      this.onTap});

  final bool obscureText;
  final Color normalBorderColor;
  final Color focusedBorderColor;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? hintText;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      onTap: onTap,
      cursorColor: Colors.black,
      maxLength: null,
      cursorHeight: 18,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        labelStyle: const TextStyle(fontFamily: 'WorkSans'),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: focusedBorderColor),
        ),
      ),
      obscureText: obscureText,
      controller: controller,
      keyboardType: keyboardType,
    );
  }
}
