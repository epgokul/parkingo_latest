import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_parkingo/domain/blocs/marker/marker_bloc.dart';
import 'package:new_parkingo/domain/blocs/marker/marker_event.dart';
import 'package:new_parkingo/domain/blocs/marker/marker_state.dart';
import 'package:new_parkingo/presentation/screens/search_screen.dart';
import 'package:new_parkingo/presentation/widgets/custom_circular_progress.dart';
import 'package:new_parkingo/presentation/widgets/google_map_view.dart';

class LoadedMapStack extends StatefulWidget {
  const LoadedMapStack(
      {super.key, required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  State<LoadedMapStack> createState() => _LoadedMapStackState();
}

class _LoadedMapStackState extends State<LoadedMapStack> {
  // Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController placeSearchController = TextEditingController();

  // Define a GlobalKey to control the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => MarkerBloc()..add(LoadMarkersEvent(context)),
      child: Scaffold(
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
            BlocBuilder<MarkerBloc, MarkerState>(
              builder: (BuildContext context, MarkerState state) {
                if (state is MarkersLoaded) {
                  return GoogleMapView(
                      latitude: widget.latitude,
                      longitude: widget.longitude,
                      marker: state.markers);
                } else if (state is MarkerErrorState) {
                  return const Center(
                    child: Text("Error Loading Marker"),
                  );
                } else if (state is MarkerSelectedState) {
                  return Center(
                    child: Text("State: $state"),
                  );
                }
                return const Center(child: CustomCircularProgress());
              },
            ),
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
                        color: Theme.of(context).canvasColor,
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ));
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
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
                          color: Theme.of(context).canvasColor),
                      child: const Text(
                        "Search",
                        style: TextStyle(
                            color: Colors.grey, letterSpacing: 4, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
