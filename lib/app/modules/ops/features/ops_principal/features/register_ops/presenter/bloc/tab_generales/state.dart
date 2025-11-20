part of 'bloc.dart';

abstract class TabOpsState extends Equatable {
  const TabOpsState();

  @override
  List<Object> get props => [];
}

class Init extends TabOpsState {}

class Loading extends TabOpsState {}

class CloseLoading extends TabOpsState {
  const CloseLoading();
}

class Loaded extends TabOpsState {
  const Loaded({
    required this.turnos,
    required this.empresas,
    required this.areas,
  });
  final List<Turno> turnos;
  final List<EmpresaEsp> empresas;
  final List<Area> areas;
  @override
  List<Object> get props => [
        turnos,
        empresas,
        areas,
      ];
}

class FailureLocalData extends TabOpsState {
  const FailureLocalData({
    required this.error,
    required this.lastState,
  });
  final String error;
  final TabOpsState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class SavingListaVerificacion extends TabOpsState {}

class SavedListaVerificacion extends TabOpsState {
  SavedListaVerificacion(this.idGeneral);
  final String idGeneral;
}

class FailureSaveListaVerificacion extends TabOpsState {
  const FailureSaveListaVerificacion({
    required this.error,
    required this.lastState,
  });
  final String error;
  final TabOpsState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}
