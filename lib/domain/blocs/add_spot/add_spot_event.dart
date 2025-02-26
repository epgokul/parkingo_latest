import 'package:equatable/equatable.dart';

abstract class AddSpotEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddSpotLocationSelected extends AddSpotEvent {
  final double latitude;
  final double longitude;

  AddSpotLocationSelected(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}

class AddSpotSuccess extends AddSpotEvent {
  final double latitude;
  final double longitude;
  final String description;
  final String place;
  final String district;
  final String ownerName;
  final String contactNumber;
  final Map<String, String> price;
  final String userId;

  AddSpotSuccess({
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.price,
    required this.place,
    required this.district,
    required this.contactNumber,
    required this.ownerName,
    required this.userId,
  });

  @override
  List<Object?> get props => [latitude, longitude, description, userId];
}

class AddSpotFailure extends AddSpotEvent {
  final String message;

  AddSpotFailure(this.message);

  @override
  List<Object?> get props => [message];
}
