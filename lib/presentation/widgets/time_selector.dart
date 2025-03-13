import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSelector extends StatelessWidget {
  final String label;
  final DateTime time;
  final VoidCallback onTap;

  const TimeSelector(
      {super.key,
      required this.label,
      required this.time,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: (MediaQuery.sizeOf(context).width * 2 / 3) + 10,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.amber, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$label: "),
              Text(
                DateFormat('hh:mm a').format(time),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
