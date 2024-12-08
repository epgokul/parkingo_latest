import 'package:equatable/equatable.dart';

abstract class AddSpotState extends Equatable {
  const AddSpotState();

  @override
  List<Object?> get props => [];
}

class AddSpotInitial extends AddSpotState {}

class AddSpotLoading extends AddSpotState {} // Optional loading state

class AddSpotSuccessState extends AddSpotState {
  @override
  List<Object?> get props => [];
}

class AddSpotFailState extends AddSpotState {
  final String message;

  const AddSpotFailState(this.message);

  @override
  List<Object?> get props => [message];
}
