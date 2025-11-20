part of 'detail_inc_bloc.dart';

abstract class DetailINCEvent extends Equatable {
  const DetailINCEvent();

  @override
  List<Object?> get props => [];
}

class InitEv extends DetailINCEvent {
  const InitEv({required this.incidenteAccidente});

  final IncidenteAccidente incidenteAccidente;
  @override
  List<Object> get props => [incidenteAccidente];
}

class ChangeDataEv extends DetailINCEvent {
  const ChangeDataEv({
    this.id,
    this.fbEmpleadoId,
    this.fbUeaPeId,
    this.incTipoReporte,
    this.incTipoReporteNombre,
    this.incSubTipoReporte,
    this.incSubTipoReporteNombre,
    this.incSegunTipo,
    this.incSegunTipoNombre,
    this.incPotencialPerdida,
    this.incPotencialPerdidaNombre,
    this.fbGerencia,
    this.fbGerenciaNombre,
    this.fbArea,
    this.fbAreaNombre,
    this.fecha,
    this.hora,
    this.lugar,
    this.descripcion,
    this.imagenPreReporteNombre,
    this.imagenPreReporteRuta,
    this.imagenReporteNombre,
    this.imagenReporteRuta,
    this.estado,
  });

  final int? id;
  final String? fbEmpleadoId;
  final String? fbUeaPeId;
  final String? incTipoReporte;
  final String? incTipoReporteNombre;
  final String? incSubTipoReporte;
  final String? incSubTipoReporteNombre;
  final String? incSegunTipo;
  final String? incSegunTipoNombre;
  final String? incPotencialPerdida;
  final String? incPotencialPerdidaNombre;
  final String? fbGerencia;
  final String? fbGerenciaNombre;
  final String? fbArea;
  final String? fbAreaNombre;
  final String? fecha;
  final String? hora;
  final String? lugar;
  final String? descripcion;
  final String? imagenPreReporteNombre;
  final String? imagenPreReporteRuta;
  final String? imagenReporteNombre;
  final String? imagenReporteRuta;
  final String? estado;

  @override
  List<Object?> get props => [
        id,
        fbEmpleadoId,
        fbUeaPeId,
        incTipoReporte,
        incTipoReporteNombre,
        incSubTipoReporte,
        incSubTipoReporteNombre,
        incSegunTipo,
        incSegunTipoNombre,
        incPotencialPerdida,
        incPotencialPerdidaNombre,
        fbGerencia,
        fbGerenciaNombre,
        fbArea,
        fbAreaNombre,
        fecha,
        hora,
        lugar,
        descripcion,
        imagenPreReporteNombre,
        imagenPreReporteRuta,
        imagenReporteNombre,
        imagenReporteRuta,
        estado,
      ];
}

class EditIncidenteAccidenteEv extends DetailINCEvent {
  const EditIncidenteAccidenteEv({
    required this.file1,
  });

  final File file1;
  @override
  List<Object> get props => [
        file1,
      ];
}

class UploadIncidenteAccidenteEv extends DetailINCEvent {
  const UploadIncidenteAccidenteEv({required this.incidenteAccidente});
  final IncidenteAccidente incidenteAccidente;
  @override
  List<Object> get props => [incidenteAccidente];
}

class DeleteIncidenteAccidenteEv extends DetailINCEvent {
  const DeleteIncidenteAccidenteEv({
    required this.incidenteAccidente,
  });
  final IncidenteAccidente incidenteAccidente;
  @override
  List<Object> get props => [incidenteAccidente];
}
