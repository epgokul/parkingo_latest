import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:new_parkingo/presentation/widgets/custom_circular_progress.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  _GoogleMapViewState createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late Future<String?> _mapStyle;

  @override
  void initState() {
    super.initState();
    _mapStyle = _loadMapStyle();
  }

  Future<String?> _loadMapStyle() async {
    String themeMode =
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark
            ? 'dark'
            : 'light';

    debugPrint("Theme: $themeMode");

    String stylePath = themeMode == 'dark'
        ? 'assets/map_style/map_style_dark.json'
        : 'assets/map_style/map_style_light.json';

    return await rootBundle.loadString(stylePath);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _mapStyle,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CustomCircularProgress());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Failed to load map style'));
        }

        return GoogleMap(
          zoomControlsEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          trafficEnabled: true,
          buildingsEnabled: false,
          indoorViewEnabled: false,
          style: snapshot.data,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude, widget.longitude),
            zoom: 16.0,
          ),
        );
      },
    );
  }
}
