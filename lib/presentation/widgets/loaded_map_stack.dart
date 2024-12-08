import 'package:flutter/material.dart';
import 'package:new_parkingo/presentation/widgets/google_map_view.dart';
import 'package:new_parkingo/presentation/widgets/textfield.dart';

class LoadedMapStack extends StatelessWidget {
  LoadedMapStack({super.key, required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
  final TextEditingController placeSearchController = TextEditingController();

  // Define a GlobalKey to control the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey, // Attach the key to the Scaffold
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Center(
                child: Text(
                  "PARKINGO",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                // Handle drawer item tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Handle drawer item tap
              },
            ),
          ],
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMapView(latitude: latitude, longitude: longitude),
          Positioned(
            top: 50,
            left: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.menu),
                  ),
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    top: 5,
                    bottom: 5,
                  ),
                  clipBehavior: Clip.hardEdge,
                  height: 50,
                  width: size.width - 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: CustomTextfield(
                    obscureText: false,
                    normalBorderColor: Colors.transparent,
                    focusedBorderColor: Colors.transparent,
                    controller: placeSearchController,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
