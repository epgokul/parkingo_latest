import 'package:flutter/material.dart';
import 'package:new_parkingo/presentation/screens/login_page.dart';
import 'package:new_parkingo/presentation/screens/signup_page.dart';
import 'package:new_parkingo/presentation/widgets/buttons/button.dart';
import 'package:new_parkingo/presentation/widgets/buttons/transparent_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                "P A R K I N G O",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              CustomButton(
                  width: 300,
                  text: "Login",
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  color: Colors.amber,
                  textColor: Colors.white),
              const SizedBox(
                height: 20,
              ),
              TransparentButton(
                text: "Sign Up",
                color: Colors.amber,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupPage()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
