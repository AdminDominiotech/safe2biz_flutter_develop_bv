part of 'detail_inc_bloc.dart';

abstract class DetailINCState extends Equatable {
  const DetailINCState();

  @override
  List<Object> get props => [];
}

class Init extends DetailINCState {}

class Loading extends DetailINCState {}

class CloseLoading extends DetailINCState {
  const CloseLoading();
}

class Loaded extends DetailINCState {
  const Loaded({
    required this.incidenteAccidente,
    required this.tipoReportes,
    required this.subTipoReportes,
    required this.detallePerdidas,
    required this.potencialPerdidas,
    required this.areas,
    required this.gerencias,
  });
  final IncidenteAccidente incidenteAccidente;
  final List<TipoReporte> tipoReportes;
  final List<SubTipoReporte> subTipoReportes;
  final List<DetallePerdida> detallePerdidas;
  final List<PotencialPerdida> potencialPerdidas;
  final List<Area> areas;
  final List<Gerencia> gerencias;
  @override
  List<Object> get props => [
        incidenteAccidente,
        tipoReportes,
        subTipoReportes,
        detallePerdidas,
        potencialPerdidas,
        areas,
        gerencias,
      ];
}

class UploadingIncidenteAccidente extends DetailINCState {}

class UploadedIncidenteAccidente extends DetailINCState {}

class EditingIncidenteAccidente extends DetailINCState {}

class EditedIncidenteAccidente extends DetailINCState {}

class FailureEditIncidenteAccidente extends DetailINCState {
  const FailureEditIncidenteAccidente({
    required this.error,
    required this.lastState,
  });
  final String error;
  final DetailINCState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class FailureUploadIncidenteAccidente extends DetailINCState {
  const FailureUploadIncidenteAccidente({
    required this.error,
    required this.lastState,
  });
  final String error;
  final DetailINCState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}

class DeletingIncidenteAccidente extends DetailINCState {
  const DeletingIncidenteAccidente() : super();
}

class DeletedIncidenteAccidente extends DetailINCState {
  const DeletedIncidenteAccidente() : super();
}

class FailureDeleteIncidenteAccidente extends DetailINCState {
  const FailureDeleteIncidenteAccidente({
    required this.error,
    required this.lastState,
  }) : super();
  final String error;
  final DetailINCState lastState;
  @override
  List<Object> get props => [
        error,
        lastState,
      ];
}
