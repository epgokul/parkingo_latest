import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_parkingo/presentation/widgets/buttons/button.dart';

class LocationSelector extends StatefulWidget {
  final Position? position;
  const LocationSelector(this.position, {super.key});

  @override
  State<LocationSelector> createState() => _LoactionSelectorState();
}

class _LoactionSelectorState extends State<LocationSelector> {
  GoogleMapController? googleMapController;
  LatLng? selectedLocation;
  Marker? selectedMarker;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            onMapCreated: (controller) {
              googleMapController = controller;
            },
            markers: selectedMarker != null ? {selectedMarker!} : {},
            onTap: (LatLng tappedLocation) {
              setState(() {
                selectedLocation = tappedLocation;
                selectedMarker = Marker(
                    draggable: true,
                    markerId: const MarkerId("Selected location"),
                    position: tappedLocation);
              });
            },
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
                zoom: 14,
                target: LatLng(
                    widget.position!.latitude, widget.position!.longitude))),
        Positioned(
          bottom: 15,
          right: 10,
          left: 10,
          child: CustomButton(
            text: "Select location",
            onTap: () {
              Navigator.of(context).pop(selectedLocation);
            },
            color: Colors.green,
            textColor: Colors.white,
            width: 300,
          ),
        )
      ],
    );
  }
}
