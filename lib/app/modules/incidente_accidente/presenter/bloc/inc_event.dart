part of 'inc_bloc.dart';

abstract class INCEvent extends Equatable {
  const INCEvent();

  @override
  List<Object> get props => [];
}

class InitEv extends INCEvent {
  final String idSede;

  const InitEv({required this.idSede});
  @override
  List<Object> get props => [idSede];
}

class UploadIncidentesAccidentesEv extends INCEvent {
  const UploadIncidentesAccidentesEv({required this.incidentesAccidentes});
  final List<IncidenteAccidente> incidentesAccidentes;
  @override
  List<Object> get props => [incidentesAccidentes];
}

class DeleteIncidenteAccidenteEv extends INCEvent {
  const DeleteIncidenteAccidenteEv({
    required this.incidenteAccidente,
  });
  final IncidenteAccidente incidenteAccidente;
  @override
  List<Object> get props => [incidenteAccidente];
}
