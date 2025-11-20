part of 'bloc.dart';

abstract class TabGeneralDetailOpsState extends Equatable {
  const TabGeneralDetailOpsState();

  @override
  List<Object> get props => [];
}

class Init extends TabGeneralDetailOpsState {}

class Loading extends TabGeneralDetailOpsState {}

class CloseLoading extends TabGeneralDetailOpsState {
  const CloseLoading();
}

class Loaded extends TabGeneralDetailOpsState {
  const Loaded({
    required this.turnos,
    required this.empresas,
    required this.areas,
    required this.registrosResultados,
  });
  final List<Turno> turnos;
  final List<EmpresaEsp> empresas;
  final List<Area> areas;
  final List<RegistroResultado> registrosResultados;
  @override
  List<Object> get props => [
        turnos,
        empresas,
        areas,
        registrosResultados,
      ];
}

class FailureLocalData extends TabGeneralDetailOpsState {
  const FailureLocalData({
    required this.error,
    required this.lastState,
  });
  final String error;
  final TabGeneralDetailOpsState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class EditingListaVerificacion extends TabGeneralDetailOpsState {}

class EditedListaVerificacion extends TabGeneralDetailOpsState {}

class FailureEditListaVerificacion extends TabGeneralDetailOpsState {
  const FailureEditListaVerificacion({
    required this.error,
    required this.lastState,
  });
  final String error;
  final TabGeneralDetailOpsState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class UploadingRegistrosGenerales extends TabGeneralDetailOpsState {}

class UploadedRegistrosGenerales extends TabGeneralDetailOpsState {}

class FailureUploadRegistrosGenerales extends TabGeneralDetailOpsState {
  const FailureUploadRegistrosGenerales({
    required this.error,
    required this.lastState,
  });
  final String error;
  final TabGeneralDetailOpsState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class DeletingRegistrosGenerales extends TabGeneralDetailOpsState {
  const DeletingRegistrosGenerales() : super();
}

class DeletedRegistrosGenerales extends TabGeneralDetailOpsState {
  const DeletedRegistrosGenerales() : super();
}

class FailureDeleteRegistrosGenerales extends TabGeneralDetailOpsState {
  const FailureDeleteRegistrosGenerales({
    required this.error,
    required this.lastState,
  }) : super();
  final String error;
  final TabGeneralDetailOpsState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}
