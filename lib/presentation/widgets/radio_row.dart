import 'package:flutter/material.dart';
import 'package:new_parkingo/presentation/widgets/textfield.dart';

class RadioRow extends StatelessWidget {
  const RadioRow({
    super.key,
    required this.value,
    required this.onChanged,
    required this.controller,
    required this.vehicleType,
  });

  final bool value;
  final String vehicleType;
  final Function(bool?) onChanged;
  final TextEditingController controller;

  Widget showWidget(bool flag, TextEditingController controller) {
    return flag
        ? Container(
            alignment: Alignment.topRight,
            width: 150,
            child: CustomTextfield(
                obscureText: false,
                normalBorderColor: Colors.black,
                focusedBorderColor: Colors.amber,
                controller: controller,
                hintText: "Price per hour",
                keyboardType: TextInputType.number))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(2)),
          checkColor: Colors.white,
          activeColor: Colors.amber,
          value: value,
          onChanged: onChanged,
        ),
        Text(vehicleType),
        const SizedBox(
          width: 20,
        ),
        showWidget(value, controller),
      ],
    );
  }
}
