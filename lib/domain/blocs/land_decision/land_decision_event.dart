abstract class LandDecisionEvent {}

class AcceptLandRequest extends LandDecisionEvent {
  final String userId;
  AcceptLandRequest(this.userId);
}

class RejectLandRequest extends LandDecisionEvent {
  final String userId;
  RejectLandRequest(this.userId);
}
