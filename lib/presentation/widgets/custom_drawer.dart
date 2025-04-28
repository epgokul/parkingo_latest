import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_bloc.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_event.dart';
import 'package:new_parkingo/presentation/screens/settings_page.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            const SafeArea(
              child: Icon(
                Icons.local_parking_rounded,
                size: 100,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "PARKINGO",
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  letterSpacing: 12,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                'Home',
                style: TextStyle(
                  letterSpacing: 10,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle drawer item tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(
                'Settings',
                style: TextStyle(
                  letterSpacing: 10,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money_rounded),
              title: const Text(
                'Bookings',
                style: TextStyle(
                  letterSpacing: 10,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text(
                'Logout',
                style: TextStyle(
                  letterSpacing: 10,
                ),
              ),
              onTap: () {
                context.read<AuthBloc>().add(SignOutEvent());
              },
            ),
          ],
        ),
      ),
    );
  }
}
