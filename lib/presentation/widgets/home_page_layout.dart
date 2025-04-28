import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_parkingo/data/api/firebase_api.dart';
import 'package:new_parkingo/domain/blocs/navigation/navigation_bloc.dart';
import 'package:new_parkingo/presentation/screens/notification_screen.dart';
import 'package:new_parkingo/presentation/screens/profile_page.dart';
import 'package:new_parkingo/presentation/widgets/loaded_map_stack.dart';

class HomePageLayout extends StatefulWidget {
  const HomePageLayout(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.userId});
  final double latitude;
  final double longitude;
  final String userId;

  @override
  State<HomePageLayout> createState() => _HomePageLayoutState();
}

class _HomePageLayoutState extends State<HomePageLayout> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  void _initializeFCM() async {
    String? fcmToken = await FirebaseApi().initNotification();

    debugPrint("FCM Token: $fcmToken");
    try {
      await _firebaseFirestore
          .collection('tokens')
          .doc(widget.userId)
          .set({'token': fcmToken});
    } catch (e) {
      debugPrint("Error adding FCM Token to the firestore: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
            showSelectedLabels: false,
            iconSize: 30,
            landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
            currentIndex: state.selectedIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
                activeIcon: Icon(
                  Icons.home,
                  color: Colors.amber,
                  size: 40,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
                activeIcon: Icon(
                  Icons.person,
                  color: Colors.amber,
                  size: 40,
                ),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: "Notifications",
                  activeIcon: Icon(
                    Icons.notifications,
                    color: Colors.amber,
                    size: 40,
                  )),
            ],
            onTap: (value) {
              context.read<NavigationBloc>().add(TabChanged(value));
            },
          );
        },
      ),
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          switch (state.selectedIndex) {
            case 0:
              return LoadedMapStack(
                  latitude: widget.latitude,
                  longitude:
                      widget.longitude); // Show the Profile page for index 0
            case 1:
              return const ProfilePage(); //show the Profile page for index 1
            case 2:
              return const NotificationScreen(); // Show the Notifications page for index 2
            default:
              return LoadedMapStack(
                  latitude: widget.latitude,
                  longitude: widget.longitude); // Default case
          }
        },
      ),
    );
  }
}
