part of 'register_ayc_bloc.dart';

abstract class RegisterAyCState extends Equatable {
  const RegisterAyCState();

  @override
  List<Object> get props => [];
}

class Init extends RegisterAyCState {}

class Loading extends RegisterAyCState {}

class Loaded extends RegisterAyCState {
  const Loaded({
    required this.areas,
    required this.gerencias,
    required this.empresas,
    required this.desviaciones,
    required this.tipoEventos,
    required this.nivelRiesgos,
    required this.empleados,
  });
  final List<Area> areas;
  final List<Gerencia> gerencias;
  final List<EmpresaEsp> empresas;
  final List<Desviacion> desviaciones;
  final List<TipoEvento> tipoEventos;
  final List<NivelRiesgo> nivelRiesgos;
  final List<Empleado> empleados;
  @override
  List<Object> get props => [
        areas,
        gerencias,
        empresas,
        desviaciones,
        tipoEventos,
        nivelRiesgos,
        empleados,
      ];
}

class SavingActoCondicion extends RegisterAyCState {}

class SavedActoCondicion extends RegisterAyCState {}

class FailureSaveActoCondicion extends RegisterAyCState {
  const FailureSaveActoCondicion({
    required this.error,
    required this.lastState,
  });
  final String error;
  final RegisterAyCState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class CloseLoading extends RegisterAyCState {
  const CloseLoading();
}
