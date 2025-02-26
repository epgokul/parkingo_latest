import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_parkingo/data/model/land_model.dart';
import 'package:new_parkingo/domain/entities/user_entity.dart';

class LandDetails extends StatefulWidget {
  final UserEntity user;
  const LandDetails({super.key, required this.user});

  @override
  State<LandDetails> createState() => _LandDetailsState();
}

class _LandDetailsState extends State<LandDetails> {
  LandModel? landModel; // Nullable to prevent uninitialized access
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchMarkerData();
  }

  void fetchMarkerData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('markers')
        .doc(widget.user.uid)
        .get();

    if (snapshot.exists && snapshot.data() != null) {
      setState(() {
        landModel = LandModel.fromjson(snapshot.data()!);
        isLoading = false; // Data loaded
      });
    } else {
      setState(() {
        isLoading = false; // Even if data is null, stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (landModel == null || landModel!.ownerName.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text(
            "You have no registered land\nGo back and add your land to show it here",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    var land = landModel!;
    var owner = land.ownerName;
    var description = land.description;
    var lat = land.latitude;
    var long = land.longitude;
    var price = land.price;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Owner: $owner",
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'Pricing\n',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                        text: '\nAuto: ',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: price.auto),
                    const TextSpan(
                        text: '\nCar: ',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: price.car),
                    const TextSpan(
                        text: '\nHeavy: ',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: price.heavy),
                    const TextSpan(
                        text: '\nBike: ',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: price.bike),
                    const TextSpan(
                        text: '\nBicycle: ',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: price.bicycle),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(land.contactNumber),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: MediaQuery.sizeOf(context).width,
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: GoogleMap(
                  indoorViewEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, long),
                    zoom: 20,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('land_marker'),
                      position: LatLng(lat, long),
                      infoWindow: InfoWindow(title: "$owner's Land"),
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
