part of 'ops_bloc.dart';

abstract class OpsState extends Equatable {
  const OpsState();

  @override
  List<Object> get props => [];
}

class Init extends OpsState {}

class Loading extends OpsState {}

class Loaded extends OpsState {
  Loaded(this.verifications);
  final List<VerificacionOps> verifications;

  @override
  List<Object> get props => [verifications];
}

class FailureGetVerifications extends OpsState {
  const FailureGetVerifications({
    required this.error,
    required this.lastState,
  });
  final String error;
  final OpsState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}
