import 'package:equatable/equatable.dart';

class MapEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMap extends MapEvent {}

class UpdateLocation extends MapEvent {
  final double latitude;
  final double longitude;
  UpdateLocation(this.latitude, this.longitude);
  @override
  List<Object?> get props => [latitude, longitude];
}
