import 'package:equatable/equatable.dart';

abstract class LocationPermissionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckPermission extends LocationPermissionEvent {}

class RequestPermission extends LocationPermissionEvent {}

class OpenAppSettings extends LocationPermissionEvent {}
