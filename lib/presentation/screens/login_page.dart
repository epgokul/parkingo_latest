import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_bloc.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_event.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_state.dart';
import 'package:new_parkingo/presentation/screens/Admin/admin_home_page.dart';
import 'package:new_parkingo/presentation/screens/home_page.dart';
import 'package:new_parkingo/presentation/screens/signup_page.dart';
import 'package:new_parkingo/presentation/widgets/buttons/button.dart';
import 'package:new_parkingo/presentation/widgets/buttons/button_with_icon.dart';
import 'package:new_parkingo/presentation/widgets/textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print("current State: $state");
        if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("SignUp success")));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else if (state is AuthAuthenticatedAdmin) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Welcome Admin!")));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AdminHomePage()));
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("error:${state.message}")));
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            const Align(
                alignment: Alignment.center,
                child: Text(
                  "PARKINGO",
                  style: TextStyle(
                      fontSize: 50,
                      letterSpacing: 5,
                      fontWeight: FontWeight.bold),
                )),
            const Spacer(),
            const Text(
              "Email",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            CustomTextfield(
                obscureText: false,
                normalBorderColor: Colors.white,
                focusedBorderColor: Colors.black12,
                controller: emailController,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            CustomTextfield(
                obscureText: true,
                normalBorderColor: Colors.white,
                focusedBorderColor: Colors.black12,
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Column(
                children: [
                  CustomButton(
                    width: 300,
                    text: "Login",
                    color: Colors.amber,
                    textColor: Colors.white,
                    onTap: () {
                      context.read<AuthBloc>().add(SignInEvent(
                          emailController.text, passwordController.text));
                    },
                  ),
                  const Text(
                    "or",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonWithIcon(
                    text: "Continue with Google",
                    color: const Color.fromARGB(255, 239, 239, 239),
                    textColor: Colors.black,
                    icon: Icons.phone_android,
                    iconColor: Colors.black,
                    onTap: () {
                      context.read<AuthBloc>().add(SignInWithGoogleEvent());
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Dont have an account?"),
                      GestureDetector(
                        child: const Text(
                          " Create Now",
                          style: TextStyle(color: Colors.amber),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupPage()));
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Spacer()
          ],
        ),
      ),
    ));
  }
}
