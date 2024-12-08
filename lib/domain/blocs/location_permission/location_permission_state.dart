import 'package:equatable/equatable.dart';

abstract class LocationPermissionState extends Equatable {
  @override
  List<Object> get props => [];
}

class PermissionInitial extends LocationPermissionState {}

class PermissionGranted extends LocationPermissionState {}

class PermissionDenied extends LocationPermissionState {}

class PermissionDeniedForever extends LocationPermissionState {}

class PermissionLoading extends LocationPermissionState {}

class PermissionError extends LocationPermissionState {
  final String message;

  PermissionError(this.message);

  @override
  List<Object> get props => [message];
}
