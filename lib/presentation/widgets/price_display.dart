import 'package:flutter/material.dart';

class PriceDisplay extends StatelessWidget {
  final String price;

  const PriceDisplay({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'To Pay: ',
          style: TextStyle(
              fontSize: 30,
              color: Theme.of(context).textTheme.displayLarge?.color,
              fontFamily: 'Poppins'),
          children: <TextSpan>[
            TextSpan(
                text: price,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 35)),
            const TextSpan(text: ' rs/hr'),
          ],
        ),
      ),
    );
  }
}
