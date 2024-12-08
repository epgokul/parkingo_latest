import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      body: Column(
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  );
                }

                final landData = snapshot.data!;
                return ListView.builder(
                  itemCount: landData.length,
                  padding: const EdgeInsets.all(10.0), // Added padding
                  // ignore: body_might_complete_normally_nullable
                  itemBuilder: (context, index) {
                    var land = landData[index];
                    var name = land['owner_name'] ?? "Unknown";
                    var phone = land['contact_number'] ?? "N/A";
                    var userId = land['addedBy'] ?? "N/A";
                    double landLatitude = land['latitude'];
                    double landLongitude = land['longitude'];
                    bool isAccepted = land['approved'];

                    if (!isAccepted) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10.0), // Spacing
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
                              name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Phone Number: $phone",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "User ID: $userId",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w300),
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
                                    onTap: () {},
                                    color: Colors.red,
                                    textColor: Colors.white),
                                const SizedBox(
                                  width: 5,
                                ),
                                CustomButton(
                                    width: 100,
                                    text: "Accept",
                                    onTap: () {},
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
    );
  }
}
