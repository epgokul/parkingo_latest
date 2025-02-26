import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_parkingo/domain/blocs/land_decision/land_decision_event.dart';
import 'package:new_parkingo/domain/blocs/land_decision/land_decision_state.dart';

class LandDecisionBloc extends Bloc<LandDecisionEvent, LandDecisionState> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  LandDecisionBloc() : super(LandDecisionInitial()) {
    on<AcceptLandRequest>(_onAcceptLandRequest);
  }

  FutureOr<void> _onAcceptLandRequest(
      AcceptLandRequest event, Emitter<LandDecisionState> emit) {
    emit(LandDecisionLoading());
    try {
      _firebaseFirestore
          .collection('markers')
          .doc(event.userId)
          .update({'approved': true});
      emit(LandDecisionAccepted());
    } catch (e) {
      emit(LandDecisionError(e.toString()));
    }
  }
}
