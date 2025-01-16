import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_bloc.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_event.dart';
import 'package:new_parkingo/domain/blocs/auth/auth_state.dart';
import 'package:new_parkingo/domain/entities/user_entity.dart';
import 'package:new_parkingo/presentation/screens/add_land_page.dart';
import 'package:new_parkingo/presentation/widgets/buttons/button.dart';
import 'package:new_parkingo/presentation/widgets/custom_circular_progress.dart';
import 'package:new_parkingo/presentation/widgets/user_field.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const Center(child: CustomCircularProgress());
        } else if (state is AuthAuthenticated) {
          return ProfilePageAuthenticated(
            user: state.user,
          );
        } else if (state is UnAuthenticated) {
          return const ProfilePageUnAuthenticated();
        } else {
          // Handle any other possible states
          return const Center(child: Text('Unexpected auth state'));
        }
      },
    );
  }
}

class ProfilePageAuthenticated extends StatefulWidget {
  final UserEntity user;
  const ProfilePageAuthenticated({super.key, required this.user});

  @override
  State<ProfilePageAuthenticated> createState() =>
      _ProfilePageAuthenticatedState();
}

class _ProfilePageAuthenticatedState extends State<ProfilePageAuthenticated> {
  final ImagePicker _picker = ImagePicker();
  String? profilePicUrl;

  @override
  void initState() {
    super.initState();
    profilePicUrl = widget.user.profilePictureUrl;
  }

  Future<void> _pickAndUploadImage() async {
    try {
      // Open gallery to pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null && mounted) {
        // Dispatch the event with the selected image and user ID
        context.read<AuthBloc>().add(
              UploadProfilePictureEvent(
                userId: widget.user.uid,
                imageFile: File(image.path),
              ),
            );
      }
    } catch (e) {
      // Handle potential errors, e.g., user denied permission
      AuthError('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(SignOutEvent());
            },
            icon: const Icon(Icons.logout_rounded),
            color: Colors.redAccent,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    profilePicUrl ?? "",
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    iconSize: 35,
                    onPressed: _pickAndUploadImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),
            const SizedBox(height: 70),
            UserField(
              title: widget.user.displayName,
              icon: Icons.person,
              iconsize: 30,
              titlesize: 20,
            ),
            const SizedBox(height: 30),
            UserField(
              title: widget.user.email,
              icon: Icons.email_rounded,
              iconsize: 30,
              titlesize: 20,
            ),
            const SizedBox(height: 30),
            CustomButton(
                text: "Add Parking Spot",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddLandPage(
                                user: widget.user,
                              )));
                },
                color: Colors.amber,
                textColor: Colors.black,
                width: 300),
            const SizedBox(height: 30),
            Container()
          ],
        ),
      ),
    );
  }
}

class ProfilePageUnAuthenticated extends StatelessWidget {
  const ProfilePageUnAuthenticated({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You are not logged in'),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
