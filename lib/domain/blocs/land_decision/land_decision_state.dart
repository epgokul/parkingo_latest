abstract class LandDecisionState {}

class LandDecisionInitial extends LandDecisionState {}

class LandDecisionLoading extends LandDecisionState {}

class LandDecisionAccepted extends LandDecisionState {}

class LandDecisionRejected extends LandDecisionState {}

class LandDecisionError extends LandDecisionState {
  final String message;

  LandDecisionError(this.message);
}
