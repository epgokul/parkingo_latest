import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      this.onTap});
  final String title;
  final IconData icon;
  final Color color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: color,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      leading: Icon(
        icon,
        size: 30,
        color: Colors.white,
      ),
      onTap: onTap,
    );
  }
}
