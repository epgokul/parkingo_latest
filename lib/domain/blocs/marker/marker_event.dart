import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:new_parkingo/data/model/land_model.dart';

abstract class MarkerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMarkersEvent extends MarkerEvent {
  final BuildContext context;
  LoadMarkersEvent(this.context);
}

class SelectMarkerEvent extends MarkerEvent {
  final LandModel marker;

  SelectMarkerEvent({required this.marker});

  @override
  List<Object?> get props => [marker];
}

class BookMarkerEvent extends MarkerEvent {
  final LandModel marker;
  BookMarkerEvent(this.marker);

  @override
  List<Object?> get props => [marker];
}
