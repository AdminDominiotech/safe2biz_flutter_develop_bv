part of 'register_inc_bloc.dart';

abstract class RegisterINCState extends Equatable {
  const RegisterINCState();

  @override
  List<Object?> get props => [];
}

class Init extends RegisterINCState {}

class Loading extends RegisterINCState {}

class Loaded extends RegisterINCState {
  const Loaded({
    required this.tipoReportes,
    required this.subTipoReportes,
    required this.detallePerdidas,
    required this.potencialPerdidas,
    required this.areas,
    required this.gerencias,
  });
  final List<TipoReporte> tipoReportes;
  final List<SubTipoReporte> subTipoReportes;
  final List<DetallePerdida> detallePerdidas;
  final List<PotencialPerdida> potencialPerdidas;
  final List<Area> areas;
  final List<Gerencia> gerencias;

  @override
  List<Object> get props => [
        tipoReportes,
        subTipoReportes,
        detallePerdidas,
        potencialPerdidas,
        areas,
        gerencias,
      ];
}

class SavingIncidenteAccidente extends RegisterINCState {}

class SavedIncidenteAccidente extends RegisterINCState {}

class FailureSaveIncidenteAccidente extends RegisterINCState {
  const FailureSaveIncidenteAccidente({
    required this.error,
    required this.lastState,
  });
  final String error;
  final RegisterINCState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}
