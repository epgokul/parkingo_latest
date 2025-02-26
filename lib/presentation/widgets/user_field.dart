import 'package:flutter/material.dart';

class UserField extends StatelessWidget {
  const UserField(
      {super.key,
      required this.title,
      required this.icon,
      required this.iconsize,
      required this.titlesize,
      this.onTap});
  final String title;
  final IconData icon;
  final double iconsize;
  final double titlesize;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: size.width / 10),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              size: iconsize,
            ),
            const SizedBox(
              width: 30,
            ),
            Text(
              title,
              maxLines: 2,
              style: TextStyle(fontSize: titlesize),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
