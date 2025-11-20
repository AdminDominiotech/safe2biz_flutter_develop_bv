import 'package:equatable/equatable.dart';

abstract class IncidenteAccidente extends Equatable {
  final int id;
  final String fbEmpleadoId;
  final String fbUeaPeId;
  final String incTipoReporte;
  final String incTipoReporteNombre;
  final String incSubTipoReporte;
  final String incSubTipoReporteNombre;
  final String incSegunTipo;
  final String incSegunTipoNombre;
  final String incPotencialPerdida;
  final String incPotencialPerdidaNombre;
  final String fbGerencia;
  final String fbGerenciaNombre;
  final String fbArea;
  final String fbAreaNombre;
  final String fecha;
  final String hora;
  final String lugar;
  final String descripcion;
  final String imagenPreReporteNombre;
  final String imagenPreReporteRuta;
  final String imagenReporteNombre;
  final String imagenReporteRuta;
  final String estado;

  IncidenteAccidente({
    required this.id,
    required this.fbEmpleadoId,
    required this.fbUeaPeId,
    required this.incTipoReporte,
    required this.incTipoReporteNombre,
    required this.incSubTipoReporte,
    required this.incSubTipoReporteNombre,
    required this.incSegunTipo,
    required this.incSegunTipoNombre,
    required this.incPotencialPerdida,
    required this.incPotencialPerdidaNombre,
    required this.fbGerencia,
    required this.fbGerenciaNombre,
    required this.fbArea,
    required this.fbAreaNombre,
    required this.fecha,
    required this.hora,
    required this.lugar,
    required this.descripcion,
    required this.imagenPreReporteNombre,
    required this.imagenPreReporteRuta,
    required this.imagenReporteNombre,
    required this.imagenReporteRuta,
    required this.estado,
  });

  @override
  List<Object?> get props => [
    id, fbEmpleadoId, fbUeaPeId, incTipoReporte, incTipoReporteNombre,
    incSubTipoReporte, incSubTipoReporteNombre, incSegunTipo, incSegunTipoNombre,
    incPotencialPerdida, incPotencialPerdidaNombre, fbGerencia, fbGerenciaNombre,
    fbArea, fbAreaNombre, fecha, hora, lugar, descripcion, imagenPreReporteNombre,
    imagenPreReporteRuta, imagenReporteNombre, imagenReporteRuta, estado,
  ];
}

class ConcreteIncidenteAccidente extends IncidenteAccidente {
  ConcreteIncidenteAccidente({
    required int id,
    required String fbEmpleadoId,
    required String fbUeaPeId,
    required String incTipoReporte,
    required String incTipoReporteNombre,
    required String incSubTipoReporte,
    required String incSubTipoReporteNombre,
    required String incSegunTipo,
    required String incSegunTipoNombre,
    required String incPotencialPerdida,
    required String incPotencialPerdidaNombre,
    required String fbGerencia,
    required String fbGerenciaNombre,
    required String fbArea,
    required String fbAreaNombre,
    required String fecha,
    required String hora,
    required String lugar,
    required String descripcion,
    required String imagenPreReporteNombre,
    required String imagenPreReporteRuta,
    required String imagenReporteNombre,
    required String imagenReporteRuta,
    required String estado,
  }) : super(
    id: id,
    fbEmpleadoId: fbEmpleadoId,
    fbUeaPeId: fbUeaPeId,
    incTipoReporte: incTipoReporte,
    incTipoReporteNombre: incTipoReporteNombre,
    incSubTipoReporte: incSubTipoReporte,
    incSubTipoReporteNombre: incSubTipoReporteNombre,
    incSegunTipo: incSegunTipo,
    incSegunTipoNombre: incSegunTipoNombre,
    incPotencialPerdida: incPotencialPerdida,
    incPotencialPerdidaNombre: incPotencialPerdidaNombre,
    fbGerencia: fbGerencia,
    fbGerenciaNombre: fbGerenciaNombre,
    fbArea: fbArea,
    fbAreaNombre: fbAreaNombre,
    fecha: fecha,
    hora: hora,
    lugar: lugar,
    descripcion: descripcion,
    imagenPreReporteNombre: imagenPreReporteNombre,
    imagenPreReporteRuta: imagenPreReporteRuta,
    imagenReporteNombre: imagenReporteNombre,
    imagenReporteRuta: imagenReporteRuta,
    estado: estado,
  );

  factory ConcreteIncidenteAccidente.fromMap(Map<String, dynamic> map) {
    return ConcreteIncidenteAccidente(
      id: map['id'],
      fbEmpleadoId: map['fbEmpleadoId'],
      fbUeaPeId: map['fbUeaPeId'],
      incTipoReporte: map['incTipoReporte'],
      incTipoReporteNombre: map['incTipoReporteNombre'],
      incSubTipoReporte: map['incSubTipoReporte'],
      incSubTipoReporteNombre: map['incSubTipoReporteNombre'],
      incSegunTipo: map['incSegunTipo'],
      incSegunTipoNombre: map['incSegunTipoNombre'],
      incPotencialPerdida: map['incPotencialPerdida'],
      incPotencialPerdidaNombre: map['incPotencialPerdidaNombre'],
      fbGerencia: map['fbGerencia'],
      fbGerenciaNombre: map['fbGerenciaNombre'],
      fbArea: map['fbArea'],
      fbAreaNombre: map['fbAreaNombre'],
      fecha: map['fecha'],
      hora: map['hora'],
      lugar: map['lugar'],
      descripcion: map['descripcion'],
      imagenPreReporteNombre: map['imagenPreReporteNombre'],
      imagenPreReporteRuta: map['imagenPreReporteRuta'],
      imagenReporteNombre: map['imagenReporteNombre'],
      imagenReporteRuta: map['imagenReporteRuta'],
      estado: map['estado'],
    );
  }
}
