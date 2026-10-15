part of 'sede_bloc.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object> get props => [];
}

class InitEv extends CompanyEvent {
  /// [forceRemote] obliga a consultar el servidor ignorando la cache local.
  /// Se usa al entrar desde el login: la lista guardada puede ser del usuario
  /// anterior o estar desactualizada. Si la consulta falla y existe cache, se
  /// muestra la cache para no dejar la pantalla vacia.
  const InitEv({this.forceRemote = false});

  final bool forceRemote;

  @override
  List<Object> get props => [forceRemote];
}

/// Refresca la lista de sedes consultando al servidor. Se dispara desde el
/// boton de refresco de la pantalla de SEDES. Solo debe emitirse cuando hay
/// conexion a internet (la validacion se hace en la vista antes de agregarlo).
class RefreshEv extends CompanyEvent {}
