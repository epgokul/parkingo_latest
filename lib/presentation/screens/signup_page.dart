import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_bloc.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_event.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_state.dart';
import 'package:new_parkingo/presentation/screens/home_page.dart';
import 'package:new_parkingo/presentation/widgets/buttons/button.dart';
import 'package:new_parkingo/presentation/widgets/textfield.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Sign up success")));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error:${state.message}")));
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 30.0,
                right: 30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "PARKINGO",
                      style: TextStyle(
                          fontSize: 50,
                          letterSpacing: 5,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  CustomTextfield(
                    obscureText: false,
                    normalBorderColor: Colors.white,
                    focusedBorderColor: Colors.black12,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "User Name",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  CustomTextfield(
                    obscureText: false,
                    normalBorderColor: Colors.white,
                    focusedBorderColor: Colors.black12,
                    controller: userNameController,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Password",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  CustomTextfield(
                    obscureText: true,
                    normalBorderColor: Colors.white,
                    focusedBorderColor: Colors.black12,
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Confirm Password",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  CustomTextfield(
                    obscureText: true,
                    normalBorderColor: Colors.white,
                    focusedBorderColor: Colors.black12,
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomButton(
                      text: "Sign In",
                      width: 300,
                      color: Colors.amber,
                      textColor: Colors.white,
                      onTap: () {
                        var email = emailController.text;
                        var password = passwordController.text;
                        var displayName = userNameController.text;
                        context
                            .read<AuthBloc>()
                            .add(SignUpEvent(email, password, displayName));
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
