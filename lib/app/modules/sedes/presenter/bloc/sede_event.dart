part of 'sede_bloc.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object> get props => [];
}

class InitEv extends CompanyEvent {}

/// Refresca la lista de sedes consultando al servidor. Se dispara desde el
/// boton de refresco de la pantalla de SEDES. Solo debe emitirse cuando hay
/// conexion a internet (la validacion se hace en la vista antes de agregarlo).
class RefreshEv extends CompanyEvent {}
