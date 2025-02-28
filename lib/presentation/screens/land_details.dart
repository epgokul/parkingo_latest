import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_parkingo/data/model/land_model.dart';
import 'package:new_parkingo/domain/entities/user_entity.dart';
import 'package:new_parkingo/presentation/widgets/custom_circular_progress.dart';

class LandDetails extends StatefulWidget {
  final UserEntity user;
  const LandDetails({super.key, required this.user});

  @override
  State<LandDetails> createState() => _LandDetailsState();
}

class _LandDetailsState extends State<LandDetails> {
  LandModel? landModel;
  bool isLoading = true;

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
        body: const Center(child: CustomCircularProgress()),
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
    var price = land.price;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            indoorViewEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(land.latitude, land.longitude),
              zoom: 18,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('land_marker'),
                position: LatLng(land.latitude, land.longitude),
                infoWindow: InfoWindow(title: "${land.ownerName}'s Land"),
              ),
            },
          ),
          Container(
            height: MediaQuery.sizeOf(context).height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.transparent,
              Color.fromARGB(255, 60, 60, 60)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          CustomScrollView(
            scrollBehavior: const MaterialScrollBehavior(),
            anchor: 0.6,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      height: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${land.ownerName}'s Land",
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      land.description,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      land.district,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      land.place,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      land.contactNumber,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Pricing",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.white)),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 200,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Auto: ${price.auto}\nCar: ${price.car}\nBike: ${price.bike}\nHeavy: ${price.heavy}\nBicycle: ${price.bicycle}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.sizeOf(context).height * (3 / 8))
                  ],
                ),
              )),
            ],
          ),
          Positioned(
              left: 20,
              top: 50,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }
}
