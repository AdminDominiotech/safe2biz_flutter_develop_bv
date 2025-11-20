import 'package:equatable/equatable.dart';
abstract class PlanAccion extends Equatable {
  const PlanAccion({
    // Campos originales
    required this.id, // Se usará el id que antes era sgAccionCorrectivaId
    required this.detalle,
    required this.codigo,
    required this.fechaEjec, // Se elimina fechaAcordadaEjecucion
    required this.responsable, // Se elimina nombreResponsableCorreccion
    required this.origen, // Se elimina tipoOrigen
    required this.evidenciaNombre,
    required this.evidenciaRuta,
    required this.estado,
    required this.fechaEjecucion,
    required this.ueaId, // Se elimina fbUea
    required this.obsRespCorr, // Observaciones (obsRespCorr) se conserva
    required this.fechaOrigen,
    required this.responsableVerificador,

  });

  // Campos originales
  final String id;
  final String detalle;
  final String codigo;
  final String fechaEjec;
  final String responsable;
  final String origen;
  final String evidenciaNombre;
  final String evidenciaRuta;
  final String estado;
  final String fechaEjecucion;
  final String ueaId;
  final String obsRespCorr;
  final String fechaOrigen;
  final String responsableVerificador;


  @override
  List<Object> get props => [
    id,
    detalle,
    codigo,
    fechaEjec,
    responsable,
    origen,
    evidenciaNombre,
    evidenciaRuta,
    estado,
    fechaEjecucion,
    ueaId,
    obsRespCorr,
    fechaOrigen,
    responsableVerificador

  ];
}
