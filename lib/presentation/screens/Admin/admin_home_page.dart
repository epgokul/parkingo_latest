import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_bloc.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_event.dart';
import 'package:new_parkingo/presentation/screens/Admin/land_request_page.dart';
import 'package:new_parkingo/presentation/screens/Admin/remove_user_page.dart';
import 'package:new_parkingo/presentation/widgets/listTile/custom_list_tile.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "Logout",
        onPressed: () {
          context.read<AuthBloc>().add(SignOutEvent());
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.logout_outlined,
          color: Colors.red,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Welcome Admin!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomListTile(
                title: "Remove User",
                icon: Icons.person_remove,
                color: Colors.red,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RemoveUserPage(),
                      ));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomListTile(
                title: "Check Requests",
                icon: Icons.add_location_alt,
                color: Colors.amber,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LandRequestPage(),
                      ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
