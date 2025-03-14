import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_parkingo/domain/blocs/land_decision/land_decision_bloc.dart';
import 'package:new_parkingo/domain/blocs/land_decision/land_decision_event.dart';
import 'package:new_parkingo/domain/blocs/land_decision/land_decision_state.dart';
import 'package:new_parkingo/presentation/widgets/buttons/button.dart';
import 'package:new_parkingo/presentation/widgets/custom_circular_progress.dart';

class LandRequestPage extends StatefulWidget {
  const LandRequestPage({super.key});

  @override
  State<LandRequestPage> createState() => _LandRequestPageState();
}

// Fetch land request details from Firestore
Future<List<Map<String, dynamic>>> fetchLandRequestDetails() async {
  try {
    final ref = FirebaseFirestore.instance.collection('markers');
    final querySnapshot = await ref.get();
    return querySnapshot.docs
        .map(
          // ignore: unnecessary_cast
          (doc) => doc.data() as Map<String, dynamic>,
        )
        .toList();
  } catch (e) {
    return [];
  }
}

// Add delay for loading simulation
Future<List<Map<String, dynamic>>> fetchLandRequestDetailsWithDelay() async {
  await Future.delayed(const Duration(seconds: 2)); // Added 'await'
  return fetchLandRequestDetails();
}

Future<void> openLocationViewer(
    {required BuildContext context,
    required double latitude,
    required double longitude}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GoogleMap(
              indoorViewEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 20, // Adjust zoom level as needed
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('land_marker'),
                  position: LatLng(latitude, longitude),
                  infoWindow: const InfoWindow(title: "Land Location"),
                ),
              },
            ),
          ),
        ),
      );
    },
  );
}

class _LandRequestPageState extends State<LandRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Land Requests",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
      body: BlocListener<LandDecisionBloc, LandDecisionState>(
        listener: (BuildContext context, LandDecisionState state) {
          if (state is LandDecisionLoading) {
            const Center(child: CustomCircularProgress());
          } else if (state is LandDecisionAccepted) {
            fetchLandRequestDetailsWithDelay();
          } else if (state is LandDecisionRejected) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Land Request Rejected!")));
          }
        },
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchLandRequestDetailsWithDelay(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomCircularProgress(),
                          SizedBox(height: 20),
                          Text(
                            "Fetching Land details",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No land requests found.",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    );
                  }

                  final allLandData = snapshot.data!;
                  List<Map<String, dynamic>> landData = allLandData
                      .where((land) => land['approved'] == false)
                      .toList();

                  if (landData.isEmpty) {
                    return const Center(
                      child: Text(
                        "No approved land requests found.",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: landData.length,
                    padding: const EdgeInsets.all(10.0), // Added padding
                    // ignore: body_might_complete_normally_nullable
                    itemBuilder: (context, index) {
                      var land = landData[index];
                      var name = land['owner_name'] ?? "Unknown";
                      var phone = land['contact_number'] ?? "N/A";
                      var description = land['description'] ?? "N/A";
                      double landLatitude = land['latitude'];
                      double landLongitude = land['longitude'];
                      bool isAccepted = land['approved'];
                      Map<String, dynamic> pricing = land['price'];
                      var autoPrice = pricing['auto'];
                      var carPrice = pricing['car'];
                      var bicyclePrice = pricing['bicycle'];
                      var bikePrice = pricing['bike'];
                      var heavyPrice = pricing['heavy'];
                      var userId = land['addedBy'];

                      if (!isAccepted) {
                        return Container(
                          margin:
                              const EdgeInsets.only(bottom: 10.0), // Spacing
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: index % 2 != 0
                                ? Colors.amber[200]
                                : Colors.amber[50],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$name's Land",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Phone Number: $phone",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '$description',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Auto rickshaw: ${autoPrice}rs",
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                "Car: ${carPrice}rs",
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                "Bike: ${bikePrice}rs",
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                "Heavy vehicle: ${heavyPrice}rs",
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                "Bicycle: ${bicyclePrice}rs",
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: CustomButton(
                                    text: "View Land Marker",
                                    onTap: () {
                                      openLocationViewer(
                                          context: context,
                                          latitude: landLatitude,
                                          longitude: landLongitude);
                                    },
                                    color: Colors.amber,
                                    textColor: Colors.white,
                                    width: MediaQuery.sizeOf(context).width),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomButton(
                                      width: 100,
                                      text: "Decline",
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                                "Reject the Land request made by $name?"),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  )),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Reject",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ))
                                            ],
                                          ),
                                        );
                                      },
                                      color: Colors.red,
                                      textColor: Colors.white),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  CustomButton(
                                      width: 100,
                                      text: "Accept",
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                                "Accept the Land request made by $name?"),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    context
                                                        .read<
                                                            LandDecisionBloc>()
                                                        .add(AcceptLandRequest(
                                                            userId));
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Accept",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ))
                                            ],
                                          ),
                                        );
                                      },
                                      color: Colors.green,
                                      textColor: Colors.white),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
