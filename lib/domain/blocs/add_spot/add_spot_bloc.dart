import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_parkingo/domain/blocs/add_spot/add_spot_event.dart';
import 'package:new_parkingo/domain/blocs/add_spot/add_spot_state.dart';

class AddSpotBloc extends Bloc<AddSpotEvent, AddSpotState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AddSpotBloc() : super(AddSpotInitial()) {
    on<AddSpotLocationSelected>(_onLocationSelected);
    on<AddSpotSuccess>(_onSpotAddedSuccessful);
  }

  FutureOr<void> _onLocationSelected(
      AddSpotLocationSelected event, Emitter emit) {}

  FutureOr<void> _onSpotAddedSuccessful(
      AddSpotSuccess event, Emitter emit) async {
    emit(AddSpotInitial());
    try {
      await _firestore.collection('markers').add({
        'latitude': event.latitude,
        'longitude': event.longitude,
        'description': event.description,
        'price': event.price,
        'owner_name': event.ownerName,
        'contact_number': event.contactNumber,
        'addedBy': event.userId,
        'approved': false
      });
      emit(AddSpotSuccessState());
    } catch (e) {
      emit(AddSpotFailState("Failed to add spot: $e"));
    }
  }
}
