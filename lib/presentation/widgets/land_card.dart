import 'package:flutter/material.dart';

class LandCard extends StatelessWidget {
  final Map<String, dynamic> landData;
  const LandCard({super.key, required this.landData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.sizeOf(context).width - 50,
      decoration: const BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          )),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }
}

class ElementRow extends StatelessWidget {
  final String first;
  final String second;
  const ElementRow({super.key, required this.first, required this.second});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Text(first), Text(second)],
    );
  }
}

// ElementRow(
//               first: "Auto Rickshaw",
//               second: "${landData['price']['auto']}rs/hr"),
//           ElementRow(
//               first: "Bicycle", second: "${landData['price']['bicycle']}rs/hr"),
//           ElementRow(
//               first: "Bike", second: "${landData['price']['bike']}rs/hr"),
//           ElementRow(first: "Car", second: "${landData['price']['car']}rs/hr"),
//           ElementRow(
//               first: "Heavy vehicle",
//               second: "${landData['price']['heavy']}rs/hr"),
