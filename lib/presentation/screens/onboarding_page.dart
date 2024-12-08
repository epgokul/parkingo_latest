import 'package:flutter/material.dart';
import 'package:new_parkingo/presentation/screens/landing_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  void onChangedFunction(int value) {
    setState(() {
      currentIndex = value;
    });
  }

  void onTap() {
    setState(() {
      if (currentIndex != 2) {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.decelerate);
        currentIndex++;
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LandingScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _pageController,
          onPageChanged: onChangedFunction,
          children: const <Widget>[
            Page(
              text: "Tired of Finding\nParking Spots?",
              subtitle: "Let us guide you!",
              imageSrc: 'assets/images/tired.png',
            ),
            Page(
              text: "Save Money\nAnd Time",
              subtitle: "Dont waste time searching for Parking Spots.",
              imageSrc: 'assets/images/happy.png',
            ),
            Page(
              text: "Want to Earn\nWith Us?",
              subtitle: "Have land? Why not make a profit out of it?!",
              imageSrc: 'assets/images/earn.png',
            ),
          ],
        ),
        Positioned(
          bottom: 50,
          left: size.width / 2 - 24,
          child: Row(
            children: [
              Indicator(positionIndex: 0, currentIndex: currentIndex),
              const SizedBox(
                width: 5,
              ),
              Indicator(positionIndex: 1, currentIndex: currentIndex),
              const SizedBox(
                width: 5,
              ),
              Indicator(positionIndex: 2, currentIndex: currentIndex),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
        Positioned(
            right: 20,
            bottom: 20,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.amber,
                ),
                child: const Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ))
      ]),
    );
  }
}

class Page extends StatelessWidget {
  const Page(
      {super.key,
      required this.text,
      required this.subtitle,
      required this.imageSrc});
  final String text, subtitle, imageSrc;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(size.width, size.height * 0.5),
                  painter: CustomPaintShape(),
                ),
                ClipPath(
                  clipper: ShapeClipper(),
                  child: Image.asset(
                    imageSrc,
                    height: size.height / 2,
                    fit: BoxFit.cover,
                  ),
                )
              ]),
          const SizedBox(
            height: 20,
          ),
          Text(
            text,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            subtitle,
            style: const TextStyle(
                letterSpacing: 2, fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator(
      {super.key, required this.positionIndex, required this.currentIndex});
  final int positionIndex, currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: positionIndex == currentIndex ? 10 : 5,
      width: 10,
      decoration: BoxDecoration(
          color: positionIndex == currentIndex ? Colors.amber : Colors.grey,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}

class CustomPaintShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, size.height * 0.1);
    path.quadraticBezierTo(0, 0, size.width * 0.1, 0);
    path.lineTo(size.width * 0.9, 0);
    path.quadraticBezierTo(size.width, 0, size.width, size.height * 0.1);
    path.lineTo(size.width, size.height * 0.83);
    path.quadraticBezierTo(
        size.width, size.height * 0.93, size.width * 0.9, size.height * 0.95);
    path.lineTo(size.width * 0.15, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height * 0.8);

    path.close();

    // Draw the shape on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ShapeClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.1);
    path.quadraticBezierTo(0, 0, size.width * 0.1, 0);
    path.lineTo(size.width * 0.9, 0);
    path.quadraticBezierTo(size.width, 0, size.width, size.height * 0.1);
    path.lineTo(size.width, size.height * 0.83);
    path.quadraticBezierTo(
        size.width, size.height * 0.93, size.width * 0.9, size.height * 0.95);
    path.lineTo(size.width * 0.15, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height * 0.8);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}
