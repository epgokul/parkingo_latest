import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_parkingo/domain/blocs/map/map_event.dart';
import 'package:new_parkingo/domain/blocs/map/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<LoadMap>(_onLoadMap);
    on<UpdateLocation>(_updateLocation);
  }
  Future<void> _onLoadMap(LoadMap event, Emitter<MapState> emit) async {
    emit(MapLoading());
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled");
      }
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied.");
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition();

      // Emit the loaded state with the current position
      emit(MapLoaded(position.latitude, position.longitude));
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  FutureOr<void> _updateLocation(
      UpdateLocation event, Emitter<MapState> emit) async {
    Position position = await Geolocator.getCurrentPosition();

    // Emit the updated location
    emit(MapLoaded(position.latitude, position.longitude));
  }
}
