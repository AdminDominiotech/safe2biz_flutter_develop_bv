part of 'register_ops_bloc.dart';

abstract class RegisterOpsState extends Equatable {
  const RegisterOpsState();

  @override
  List<Object> get props => [];
}

class Init extends RegisterOpsState {}

class Loaded extends RegisterOpsState {
  Loaded({
    required this.resultadoOps,
    required this.idResultadoOps,
  });
  final List<ResultadoOps> resultadoOps;
  final String idResultadoOps;
}

class Loading extends RegisterOpsState {}

class SavingRegistroResultado extends RegisterOpsState {}

class SavedRegistroResultado extends RegisterOpsState {}

class CloseLoading extends RegisterOpsState {
  const CloseLoading();
}

class FailureSaveRegistroResultado extends RegisterOpsState {
  const FailureSaveRegistroResultado({
    required this.error,
    required this.lastState,
  });
  final String error;
  final RegisterOpsState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}
