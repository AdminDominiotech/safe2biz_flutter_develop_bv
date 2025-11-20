part of 'sincronizar_bloc.dart';

abstract class SincronizarEvent extends Equatable {
  const SincronizarEvent();

  @override
  List<Object> get props => [];
}

class InitEv extends SincronizarEvent {}

class GetModulosEv extends SincronizarEvent {
  final bool downloadAyC;
  final bool downloadINC;
  final bool downloadAC;
  final bool downloadOPS;

  const GetModulosEv({
    required this.downloadAyC,
    required this.downloadINC,
    required this.downloadAC,
    required this.downloadOPS,
  });
}

class GetModuloINCEv extends SincronizarEvent {}

class GetModuloAyCEv extends SincronizarEvent {}

class GetModuloACEv extends SincronizarEvent {}

class GetModuloOPSv extends SincronizarEvent {}