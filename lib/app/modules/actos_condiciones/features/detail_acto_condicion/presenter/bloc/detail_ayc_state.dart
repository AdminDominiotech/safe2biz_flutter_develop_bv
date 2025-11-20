part of 'detail_ayc_bloc.dart';

abstract class DetailAycState extends Equatable {
  const DetailAycState();

  @override
  List<Object> get props => [];
}

class Init extends DetailAycState {}

class Loading extends DetailAycState {}

class Loaded extends DetailAycState {
  const Loaded({
    required this.actoCondicion,
    required this.areas,
    required this.gerencias,
    required this.empresas,
    required this.desviaciones,
    required this.tipoEventos,
    required this.nivelRiesgos,
    required this.empleados,
  });
  final ActoCondicion actoCondicion;
  final List<Area> areas;
  final List<Gerencia> gerencias;
  final List<EmpresaEsp> empresas;
  final List<Desviacion> desviaciones;
  final List<TipoEvento> tipoEventos;
  final List<NivelRiesgo> nivelRiesgos;
  final List<Empleado> empleados;
  @override
  List<Object> get props => [
        actoCondicion,
        areas,
        gerencias,
        empresas,
        desviaciones,
        tipoEventos,
        nivelRiesgos,
        empleados,
      ];
}

class UploadingActoCondicion extends DetailAycState {}

class UploadedActoCondicion extends DetailAycState {}

class EditingActoCondicion extends DetailAycState {}

class EditedActoCondicion extends DetailAycState {}

class CloseLoading extends DetailAycState {
  const CloseLoading();
}

class FailureEditActoCondicion extends DetailAycState {
  const FailureEditActoCondicion({
    required this.error,
    required this.lastState,
  });
  final String error;
  final DetailAycState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class FailureUploadActoCondicion extends DetailAycState {
  const FailureUploadActoCondicion({
    required this.error,
    required this.lastState,
  });
  final String error;
  final DetailAycState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class DeletingActoCondicion extends DetailAycState {
  const DeletingActoCondicion() : super();
}

class DeletedActoCondicion extends DetailAycState {
  const DeletedActoCondicion() : super();
}

class FailureDeleteActoCondicion extends DetailAycState {
  const FailureDeleteActoCondicion({
    required this.error,
    required this.lastState,
  }) : super();
  final String error;
  final DetailAycState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}
