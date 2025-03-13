import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_parkingo/data/model/land_model.dart';
import 'package:new_parkingo/domain/blocs/marker/marker_event.dart';
import 'package:new_parkingo/domain/blocs/marker/marker_state.dart';
import 'package:new_parkingo/presentation/screens/book_spot.dart';
import 'package:new_parkingo/presentation/widgets/buttons/button.dart';
import 'package:new_parkingo/presentation/widgets/price_field.dart';

class MarkerBloc extends Bloc<MarkerEvent, MarkerState> {
  MarkerBloc() : super(MarkerInitial()) {
    on<LoadMarkersEvent>(_onLoadMarkers);
    on<SelectMarkerEvent>(_onSelectMarker);
    on<BookMarkerEvent>(_onBookMarker);
  }

  FutureOr<void> _onLoadMarkers(
      LoadMarkersEvent event, Emitter<MarkerState> emit) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('markers').get();

      List<LandModel> markerDataList = snapshot.docs
          .where((doc) => doc['approved'] == true)
          .map((doc) => LandModel.fromjson(doc.data()))
          .toList();

      Set<Marker> markers = markerDataList.map((marker) {
        return Marker(
            markerId: MarkerId(marker.addedBy),
            position: LatLng(marker.latitude, marker.longitude),
            infoWindow: const InfoWindow(title: "Parking Spot"),
            onTap: () {
              _showBookingBottomSheet(event.context, marker);
            });
      }).toSet();

      emit(MarkersLoaded(markers: markers));
    } catch (e) {
      emit(MarkerErrorState("Failed to load markers"));
    }
  }

  FutureOr<void> _onSelectMarker(
      SelectMarkerEvent event, Emitter<MarkerState> emit) {
    emit(MarkerSelectedState(event.marker));
  }

  FutureOr<void> _onBookMarker(
      BookMarkerEvent event, Emitter<MarkerState> emit) async {
    try {
      final ownerName = event.marker.ownerName;
      debugPrint("Booking requested for $ownerName's land");
    } catch (e) {
      emit(MarkerErrorState(e.toString()));
    }
  }

  void _showBookingBottomSheet(BuildContext context, LandModel marker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height:
              MediaQuery.of(context).size.height * 0.6, // 60% of screen height
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                floating: true,
                backgroundColor: Colors.amberAccent,
                expandedHeight: 150,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text("Book Parking Spot"),
                  centerTitle: true,
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Owner Name: ${marker.ownerName}",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.color),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Contact number: ${marker.contactNumber}",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.color),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).copyWith().canvasColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pricing",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              PriceField(
                                  price: marker.price.auto,
                                  assetImage: 'assets/icons/auto_rickshaw.png'),
                              const SizedBox(
                                height: 10,
                              ),
                              PriceField(
                                  price: marker.price.car,
                                  assetImage: 'assets/icons/car.png'),
                              const SizedBox(
                                height: 10,
                              ),
                              PriceField(
                                  price: marker.price.heavy,
                                  assetImage: 'assets/icons/lorry.png'),
                              const SizedBox(
                                height: 10,
                              ),
                              PriceField(
                                  price: marker.price.bike,
                                  assetImage: 'assets/icons/motorcycle.png'),
                              const SizedBox(
                                height: 10,
                              ),
                              PriceField(
                                  price: marker.price.bicycle,
                                  assetImage: 'assets/icons/bicycle.png'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                            text: "Proceed to Booking",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookSpot(
                                      marker: marker,
                                    ),
                                  ));
                            },
                            color: Colors.green,
                            textColor: Colors.white,
                            width: MediaQuery.sizeOf(context).width)
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
