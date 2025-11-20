part of 'detail_ops_bloc.dart';

abstract class DetailOpsState extends Equatable {
  const DetailOpsState();

  @override
  List<Object> get props => [];
}

class Init extends DetailOpsState {}

class RegistroResultadoLoaded extends DetailOpsState {
  RegistroResultadoLoaded({
    required this.registroResultado,
  });
  final RegistroResultado registroResultado;
}

class Loaded extends DetailOpsState {
  Loaded({
    required this.resultadoOps,
    required this.idResultadoOps,
  });
  final List<ResultadoOps> resultadoOps;
  final String idResultadoOps;
}

class Loading extends DetailOpsState {}

class SavingRegistroResultado extends DetailOpsState {}

class SavedRegistroResultado extends DetailOpsState {
  SavedRegistroResultado();
}

class EditingRegistroResultado extends DetailOpsState {}

class EditedRegistroResultado extends DetailOpsState {
  EditedRegistroResultado(this.idVerificacion);
  final String idVerificacion;

  @override
  List<Object> get props => [idVerificacion];
}

class CloseLoading extends DetailOpsState {
  const CloseLoading();
}

class FailureSaveRegistroResultado extends DetailOpsState {
  const FailureSaveRegistroResultado({
    required this.error,
    required this.lastState,
  });
  final String error;
  final DetailOpsState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class FailureEditRegistroResultado extends DetailOpsState {
  const FailureEditRegistroResultado({
    required this.error,
    required this.lastState,
  });
  final String error;
  final DetailOpsState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}
