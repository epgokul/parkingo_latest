import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_parkingo/data/model/land_model.dart';

class MarkerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MarkerInitial extends MarkerState {}

class MarkersLoaded extends MarkerState {
  final Set<Marker> markers;
  MarkersLoaded({required this.markers});

  @override
  List<Object?> get props => [markers];
}

class MarkerSelectedState extends MarkerState {
  final LandModel marker;
  MarkerSelectedState(this.marker);

  @override
  List<Object?> get props => [marker];
}

class BookingSuccessState extends MarkerState {}

class MarkerErrorState extends MarkerState {
  final String message;
  MarkerErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
