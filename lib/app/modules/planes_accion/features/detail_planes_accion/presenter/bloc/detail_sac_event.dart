part of 'detail_sac_bloc.dart';

abstract class DetailSACEvent extends Equatable {
  const DetailSACEvent();

  @override
  List<Object?> get props => [];
}

class InitEv extends DetailSACEvent {
  const InitEv({required this.planAccion});

  final PlanAccion planAccion;
  @override
  List<Object> get props => [planAccion];
}

class ChangeDataEv extends DetailSACEvent {
  const ChangeDataEv({
    this.id,
   // this.id_grisli,
    this.detalle,
    this.codigo,
    this.fechaEjec,
    this.responsable,
    this.origen,
    this.evidenciaNombre,
    this.evidenciaRuta,
    this.ueaId,
    this.fechaEjecucion,
    this.obsRespCorr,
    this.estado,
    this.fechaOrigen,
    this.responsableVerificador
    /* Campos de la sección condicional
    this.nombreGenerador,
    this.nivelRiesgoNombre,
    this.lugarProblema,
    this.causaInmediata,
    this.causaInmediataDetalle,
    this.causaBasica,
    this.causaBasicaDetalle,
    this.tipoAccionCorrectivaInmDetalle,
    this.calidadHallazgo,
    this.fechaDeteccionCondicion,
    this.code_emp,
    this.contratista_grisli
    +/
     */
  });

  final String? id;
  //final int? id_grisli;
  final String? detalle;
  final String? codigo;
  final String? fechaEjec;
  final String? responsable;
  final String? origen;
  final String? evidenciaNombre;
  final String? evidenciaRuta;
  final String? ueaId;
  final String? fechaEjecucion;
  final String? obsRespCorr;
  final String? estado;
  final String? fechaOrigen;
  final String? responsableVerificador;

  /* Nuevos campos de la sección condicional:
  final String? nombreGenerador;
  final String? nivelRiesgoNombre;
  final String? lugarProblema;
  final String? causaInmediata;
  final String? causaInmediataDetalle;
  final String? causaBasica;
  final String? causaBasicaDetalle;
  final String? tipoAccionCorrectivaInmDetalle;
  final String? calidadHallazgo;
  final String? fechaDeteccionCondicion;
  final String? code_emp;
  final int? contratista_grisli;
  +/
   */


  @override
  List<Object?> get props => [
    id,
  //  id_grisli,
    detalle,
    codigo,
    fechaEjec,
    responsable,
    origen,
    evidenciaNombre,
    evidenciaRuta,
    ueaId,
    fechaEjecucion,
    obsRespCorr,
    estado,
    fechaOrigen,
    responsableVerificador

  /*
    nombreGenerador,
    nivelRiesgoNombre,
    lugarProblema,
    causaInmediata,
    causaInmediataDetalle,
    causaBasica,
    causaBasicaDetalle,
    tipoAccionCorrectivaInmDetalle,
    calidadHallazgo,
    fechaDeteccionCondicion,
    code_emp,
    contratista_grisli
    */
  ];
}


class EditPlanAccionEv extends DetailSACEvent {
  const EditPlanAccionEv({required this.file1});
  final File file1;
  @override
  List<Object> get props => [file1];
}

class UploadPlanAccionEv extends DetailSACEvent {
  const UploadPlanAccionEv({required this.planAccion});
  final PlanAccion planAccion;
  @override
  List<Object> get props => [planAccion];
}

class DeletePlanAccionEv extends DetailSACEvent {
  const DeletePlanAccionEv({
    required this.planAccion,
  });
  final PlanAccion planAccion;
  @override
  List<Object> get props => [planAccion];
}
