import 'package:flutter/material.dart';

class PriceField extends StatelessWidget {
  final String price;
  final String assetImage;
  const PriceField({super.key, required this.price, required this.assetImage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        Image.asset(
          assetImage,
          height: 30,
          color: Theme.of(context).textTheme.displayLarge?.color,
        ),
        const Spacer(),
        Text("$price rs/hr"),
        const Spacer(),
        const Spacer(),
        const Spacer(),
        const Spacer(),
      ],
    );
  }
}
