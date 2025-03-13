import 'package:flutter/material.dart';

class VehicleButton extends StatefulWidget {
  final String image;
  final String vehicleType;
  final bool colorSelector;
  final void Function()? onTap;
  const VehicleButton(
      {super.key,
      required this.image,
      required this.vehicleType,
      this.onTap,
      required this.colorSelector});

  @override
  State<VehicleButton> createState() => _VehicleButtonState();
}

class _VehicleButtonState extends State<VehicleButton> {
  @override
  Widget build(BuildContext context) {
    bool colorSelector = widget.colorSelector;
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        curve: Curves.linear,
        width: MediaQuery.sizeOf(context).width * 1 / 3,
        decoration: BoxDecoration(
            color: colorSelector ? Colors.green : Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(left: 5, right: 5),
        padding: const EdgeInsets.all(10),
        duration: const Duration(milliseconds: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.image,
              color: colorSelector
                  ? Colors.white
                  : Theme.of(context).textTheme.displayLarge?.color,
              height: 30,
              width: 50,
            ),
            Text(
              widget.vehicleType,
              style: TextStyle(
                  color: colorSelector
                      ? Colors.white
                      : Theme.of(context).textTheme.displayLarge?.color),
            )
          ],
        ),
      ),
    );
  }
}
