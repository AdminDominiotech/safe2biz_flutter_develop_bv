import 'package:equatable/equatable.dart';

class RegistroGeneral extends Equatable {
  RegistroGeneral({
    required this.id,
    required this.fbUeaPeId,
    required this.codigo,
    required this.gTipoOrigenId,
    required this.fechaOps,
    required this.horaOps,
    required this.turno,
    required this.fbAreaId,
    required this.gRolEmpresaId,
    required this.fbEmpresaEspecializadaId,
    required this.fbEmpleadoId,
    required this.opsListaVerificacionId,
    required this.opsTipoResultadoId,
    required this.latitud,
    required this.longitud,
    required this.fbAreaNombre,
    required this.turnoNombre,
    required this.fbEmpresaEspecializadaNombre,
    required this.fbEmpleadoNombreCompleto,
    required this.idGeneradoSyncronizacion,

    required this.idOpsTipoInspeccion,
    required this.OpsTipoInspeccionText,

    required this.idOpsSubTipoInspeccion,
    required this.OpsSubTipoInspeccionText,

    required this.idOpsAlcanceInspeccion,
    required this.OpsAlcanceInspeccionText,

    required this.fbAuditorId,
    required this.auditorNombre,
    required this.involucrados,

    required this.inspectores,

    required this.estado,
    required this.flag,
    required this.alcance,
    required this.criterio,

    required this.fbVerificadorId,
    required this.verificadorNombre,

    required this.opsContratistaId,
    required this.tipoServicioNombre,
    required this.equipoAuditor,
    required this.personalAuditado,
    required this.contratistaNombre


  });

  final int id;
  final String fbUeaPeId;
  final String codigo;
  final String gTipoOrigenId;
  final String fechaOps;
  final String horaOps;
  final String turno;
  final String fbAreaId;
  final String gRolEmpresaId;
  final String fbEmpresaEspecializadaId;
  final String fbEmpleadoId;
  final String opsListaVerificacionId;
  final String opsTipoResultadoId;
  final String latitud;
  final String longitud;
  final String fbAreaNombre;
  final String turnoNombre;
  final String fbEmpresaEspecializadaNombre;
  final String fbEmpleadoNombreCompleto;
  final String idGeneradoSyncronizacion;
  final String estado;
  final String flag;
  final String alcance;
  final String criterio;
  final String idOpsTipoInspeccion;
  final String idOpsSubTipoInspeccion;
  final String idOpsAlcanceInspeccion;

  final String OpsSubTipoInspeccionText;
  final String OpsTipoInspeccionText;
  final String OpsAlcanceInspeccionText;

  final String fbAuditorId;
  final String auditorNombre;
  final String involucrados;

  final String fbVerificadorId;
  final String verificadorNombre;
  final String inspectores;

  final String opsContratistaId;
  final String tipoServicioNombre;
  final String equipoAuditor;
  final String personalAuditado;
  final String contratistaNombre;

  @override
  List<Object> get props => [
        id,
        fbUeaPeId,
        codigo,
        gTipoOrigenId,
        fechaOps,
        horaOps,
        turno,
        fbAreaId,
        gRolEmpresaId,
        fbEmpresaEspecializadaId,
        fbEmpleadoId,
        opsListaVerificacionId,
        opsTipoResultadoId,
        latitud,
        longitud,
        fbAreaNombre,
        turnoNombre,
        fbEmpresaEspecializadaNombre,
        fbEmpleadoNombreCompleto,
        idGeneradoSyncronizacion,
        estado,
        flag,
        alcance,
        criterio,
        idOpsTipoInspeccion,
        idOpsSubTipoInspeccion,
        idOpsAlcanceInspeccion,

        OpsSubTipoInspeccionText,
        OpsTipoInspeccionText,
        OpsAlcanceInspeccionText,

        fbAuditorId,
        auditorNombre,
        involucrados,

        fbVerificadorId,
        verificadorNombre,
        inspectores,

          opsContratistaId,
          tipoServicioNombre,
          equipoAuditor,
          personalAuditado,
    contratistaNombre

      ];
}
