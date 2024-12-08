import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:new_parkingo/domain/blocs/location_permission/location_permission_events.dart';
import 'location_permission_state.dart';

class LocationPermissionBloc
    extends Bloc<LocationPermissionEvent, LocationPermissionState> {
  LocationPermissionBloc() : super(PermissionInitial()) {
    on<CheckPermission>(_onCheckPermission);
    on<RequestPermission>(_onRequestPermission);
    on<OpenAppSettings>(_onOpenAppSettings);
  }

  Future<void> _onCheckPermission(
      CheckPermission event, Emitter<LocationPermissionState> emit) async {
    emit(PermissionLoading());
    try {
      PermissionStatus status = await Permission.location.status;

      if (status == PermissionStatus.granted) {
        emit(PermissionGranted());
      } else if (status == PermissionStatus.denied) {
        emit(PermissionDenied());
      } else if (status == PermissionStatus.permanentlyDenied) {
        emit(PermissionDeniedForever());
      }
    } catch (e) {
      emit(PermissionError(e.toString()));
    }
  }

  Future<void> _onRequestPermission(
      RequestPermission event, Emitter<LocationPermissionState> emit) async {
    emit(PermissionLoading());
    try {
      PermissionStatus status = await Permission.location.request();

      if (status == PermissionStatus.granted) {
        emit(PermissionGranted());
      } else if (status == PermissionStatus.denied) {
        emit(PermissionDenied());
      } else if (status == PermissionStatus.permanentlyDenied) {
        emit(PermissionDeniedForever());
      }
    } catch (e) {
      emit(PermissionError(e.toString()));
    }
  }

  void _onOpenAppSettings(
      OpenAppSettings event, Emitter<LocationPermissionState> emit) async {
    bool opened = await openAppSettings();
    if (!opened) {
      emit(PermissionError("Failed to open app settings"));
    }
  }
}
