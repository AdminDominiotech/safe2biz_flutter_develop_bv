import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';

class RegistroGeneralModel extends RegistroGeneral {
  RegistroGeneralModel({
    required int id,
    required String fbUeaPeId,
    required String codigo,
    required String gTipoOrigenId,
    required String fechaOps,
    required String horaOps,
    required String turno,
    required String fbAreaId,
    required String gRolEmpresaId,
    required String fbEmpresaEspecializadaId,
    required String fbEmpleadoId,
    required String opsListaVerificacionId,
    required String opsTipoResultadoId,
    required String latitud,
    required String longitud,
    required String fbAreaNombre,
    required String turnoNombre,
    required String fbEmpresaEspecializadaNombre,
    required String fbEmpleadoNombreCompleto,
    required String idGeneradoSyncronizacion,
    required String idOpsTipoInspeccion,
    required String idOpsSubTipoInspeccion,
    required String idOpsAlcanceInspeccion,
    required String estado,
    required String flag,
    required String alcance,
    required String criterio,

  required String OpsSubTipoInspeccionText,
  required String OpsTipoInspeccionText,
    required String OpsAlcanceInspeccionText,

    required String fbAuditorId,
    required String auditorNombre,
    required String  involucrados,

    required String inspectores,

    required String fbVerificadorId,
    required String verificadorNombre,

    required String opsContratistaId,
    required String tipoServicioNombre,
    required String equipoAuditor,
    required String personalAuditado,

    required String contratistaNombre

  }) : super(
          id: id,
          fbUeaPeId: fbUeaPeId,
          codigo: codigo,
          gTipoOrigenId: gTipoOrigenId,
          fechaOps: fechaOps,
          horaOps: horaOps,
          turno: turno,
          fbAreaId: fbAreaId,
          gRolEmpresaId: gRolEmpresaId,
          fbEmpresaEspecializadaId: fbEmpresaEspecializadaId,
          fbEmpleadoId: fbEmpleadoId,
          opsListaVerificacionId: opsListaVerificacionId,
          opsTipoResultadoId: opsTipoResultadoId,
          latitud: latitud,
          longitud: longitud,
          fbAreaNombre: fbAreaNombre,
          turnoNombre: turnoNombre,
          fbEmpresaEspecializadaNombre: fbEmpresaEspecializadaNombre,
          fbEmpleadoNombreCompleto: fbEmpleadoNombreCompleto,
          idGeneradoSyncronizacion: idGeneradoSyncronizacion,
          estado: estado,
          flag: flag,
          alcance: alcance,
          criterio: criterio,

          idOpsTipoInspeccion: idOpsTipoInspeccion,
          idOpsSubTipoInspeccion: idOpsSubTipoInspeccion,
          idOpsAlcanceInspeccion: idOpsAlcanceInspeccion,

          OpsSubTipoInspeccionText: OpsSubTipoInspeccionText,
          OpsTipoInspeccionText : OpsTipoInspeccionText,
          OpsAlcanceInspeccionText: OpsAlcanceInspeccionText,

          fbAuditorId: fbAuditorId,
          auditorNombre: auditorNombre,
          involucrados : involucrados,
          fbVerificadorId : fbVerificadorId,
          verificadorNombre : verificadorNombre,
          inspectores: inspectores,

        opsContratistaId : opsContratistaId,
        tipoServicioNombre : tipoServicioNombre,
        equipoAuditor : equipoAuditor,
        personalAuditado : personalAuditado,
      contratistaNombre:contratistaNombre

        );
  static String _asStr(Object? v) => (v ?? '').toString();
  // Helpers para castear seguro
  static int _asInt(Object? v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String && v.isNotEmpty) return int.tryParse(v) ?? 0;
    return 0;
  }
  factory RegistroGeneralModel.fromDb(Map<String, Object?> row) {
    return RegistroGeneralModel(
      id: _asInt(row['ops_registro_generales_id']),
      fbUeaPeId: _asStr(row['fb_uea_pe_id']),
      codigo: _asStr(row['codigo']),
      gTipoOrigenId: _asStr(row['g_tipo_origen_id']),
      fechaOps: _asStr(row['fecha_ops']),
      horaOps: _asStr(row['hora_ops']),
      turno: _asStr(row['turno']),
      fbAreaId: _asStr(row['fb_area_id']),
      alcance: _asStr(row['alcance']),
      criterio: _asStr(row['criterio']),
      gRolEmpresaId: _asStr(row['g_rol_empresa_id']),
      fbEmpresaEspecializadaId: _asStr(row['fb_empresa_especializada_id']),
      fbEmpleadoId: _asStr(row['fb_empleado_id']),
      opsListaVerificacionId: _asStr(row['ops_lista_verificacion_id']),
      opsTipoResultadoId: _asStr(row['ops_tipo_resultado_id']),
      latitud: _asStr(row['latitud']),
      longitud: _asStr(row['longitud']),
      fbAreaNombre: _asStr(row['fb_area_nombre']),
      turnoNombre: _asStr(row['turno_nombre']),
      fbEmpresaEspecializadaNombre: _asStr(row['fb_empresa_especializada_nombre']),
      fbEmpleadoNombreCompleto: _asStr(row['fb_empleado_nombre_completo']),
      idGeneradoSyncronizacion: _asStr(row['id_generado_syncronizacion']),
      idOpsSubTipoInspeccion: _asStr(row['ops_sub_tipo_inspeccion_id']),
      idOpsTipoInspeccion: _asStr(row['ops_tipo_inspeccion_id']),
      idOpsAlcanceInspeccion: _asStr(row['ops_alcance_inspeccion_id']),

      // Personas (id + texto)
      fbAuditorId: _asStr(row['fb_auditor_id']),
      auditorNombre: _asStr(row['auditor_nombre']),
      fbVerificadorId: _asStr(row['fb_verificador_id']),
      verificadorNombre: _asStr(row['verificador_nombre']),

      // TextAreas (¡ojo con los nombres!)
      involucrados: _asStr(row['ops_involucrados']),
      inspectores: _asStr(row['ops_inspectores']),

      // Contratista + extras
      opsContratistaId: _asStr(row['ops_contratista_id']),
      contratistaNombre: _asStr(row['contratista_nombre']),
      tipoServicioNombre: _asStr(row['tipo_servicio_nombre']),
      equipoAuditor: _asStr(row['equipo_auditor']),
      personalAuditado: _asStr(row['personal_auditado']),

      // Textos de combos
      OpsSubTipoInspeccionText: _asStr(row['ops_sub_tipo_inspeccion_text']),
      OpsTipoInspeccionText: _asStr(row['ops_tipo_inspeccion_text']),
      OpsAlcanceInspeccionText: _asStr(row['ops_alcance_inspeccion_text']),

      estado: _asStr(row['estado']),
      flag: _asStr(row['flag']),
    );
  }

  factory RegistroGeneralModel.fromJson(Map<String, dynamic> json) =>
      RegistroGeneralModel(
        id: json['ops_registro_generales_id'] ?? 0,
        fbUeaPeId: json['fb_uea_pe_id'] ?? '',
        codigo: json['codigo'] ?? '',
        gTipoOrigenId: json['g_tipo_origen_id'] ?? '',
        fechaOps: json['fecha_ops'] ?? '',
        horaOps: json['hora_ops'] ?? '',
        turno: json['turno'] ?? '',
        fbAreaId: json['fb_area_id'] ?? '',
        gRolEmpresaId: json['g_rol_empresa_id'] ?? '',
        fbEmpresaEspecializadaId: json['fb_empresa_especializada_id'] ?? '',
        fbEmpleadoId: json['fb_empleado_id'] ?? '',
        opsListaVerificacionId: json['ops_lista_verificacion_id'] ?? '',
        opsTipoResultadoId: json['ops_tipo_resultado_id'] ?? '',
        latitud: json['latitud'] ?? '',
        longitud: json['longitud'] ?? '',
        fbAreaNombre: json['fb_area_nombre'] ?? '',
        turnoNombre: json['turno_nombre'] ?? '',
        fbEmpresaEspecializadaNombre: json['fb_empresa_especializada_nombre'] ?? '',
        fbEmpleadoNombreCompleto: json['fb_empleado_nombre_completo'] ?? '',
        idGeneradoSyncronizacion: json['id_generado_syncronizacion'] ?? '',
        estado: json['estado'] ?? '',
        flag: json['flag'] ?? '',
        alcance: json['alcance'] ?? '',
        criterio: json['criterio'] ?? '',

          idOpsTipoInspeccion: json['ops_tipo_inspeccion_id'] ?? '',
          idOpsSubTipoInspeccion: json['ops_sub_tipo_inspeccion_id'] ?? '',
          idOpsAlcanceInspeccion: json['ops_alcance_inspeccion_id'] ?? '',

          OpsSubTipoInspeccionText : json['ops_sub_tipo_inspeccion_text'] ?? '',
          OpsTipoInspeccionText: json['ops_tipo_inspeccion_text'] ?? '',
          OpsAlcanceInspeccionText: json['ops_alcance_inspeccion_text'] ?? '',

          fbAuditorId : json['fb_auditor_id'] ?? '',
          auditorNombre : json['auditor_nombre'] ?? '',
          involucrados : json['ops_involucrados'] ?? '',
          fbVerificadorId : json['fb_verificador_id'] ?? '',
          verificadorNombre: json['verificador_nombre'] ?? '',
          inspectores: json['ops_inspectores'] ?? '',

        opsContratistaId: json['ops_contratista_id'] ?? '',
        tipoServicioNombre: json['tipo_servicio_nombre'] ?? '',
        equipoAuditor: json['equipo_auditor'] ?? '',
        personalAuditado: json['personal_auditado'] ?? '',
          contratistaNombre : json['contratista_nombre'] ?? ''
      );

  Map<String, dynamic> toJson() => {
        'ops_registro_generales_id': id,
        'fb_uea_pe_id': fbUeaPeId,
        'codigo': codigo,
        'g_tipo_origen_id': gTipoOrigenId,
        'fecha_ops': fechaOps,
        'hora_ops': horaOps,
        'turno': turno,
        'fb_area_id': fbAreaId,
        'g_rol_empresa_id': gRolEmpresaId,
        'fb_empresa_especializada_id': fbEmpresaEspecializadaId,
        'fb_empleado_id': fbEmpleadoId,
        'ops_lista_verificacion_id': opsListaVerificacionId,
        'ops_tipo_resultado_id': opsTipoResultadoId,
        'latitud': latitud,
        'longitud': longitud,
        'fb_area_nombre': fbAreaNombre,
        'turno_nombre': turnoNombre,
        'fb_empresa_especializada_nombre': fbEmpresaEspecializadaNombre,
        'fb_empleado_nombre_completo': fbEmpleadoNombreCompleto,
        'id_generado_syncronizacion': idGeneradoSyncronizacion,
        'estado': estado,
        'flag': flag,
        'alcance' : alcance,
        'criterio' : criterio,
        'ops_tipo_inspeccion_id' : idOpsTipoInspeccion,
        'ops_sub_tipo_inspeccion_id' : idOpsSubTipoInspeccion,
        'ops_alcance_inspeccion_id': idOpsAlcanceInspeccion,

        'ops_sub_tipo_inspeccion_text' :  OpsSubTipoInspeccionText,
        'ops_tipo_inspeccion_text': OpsTipoInspeccionText,
        'ops_alcance_inspeccion_text':OpsAlcanceInspeccionText,


        'fb_auditor_id' : fbAuditorId,
        'auditor_nombre': auditorNombre,



        'fb_verificador_id' : fbVerificadorId,
         'verificador_nombre' : verificadorNombre,

         'ops_inspectores' : inspectores,
        'ops_involucrados': involucrados,

    'ops_contratista_id' : opsContratistaId,
    'contratista_nombre' : contratistaNombre,

    'tipo_servicio_nombre' : tipoServicioNombre,

    'equipo_auditor' : equipoAuditor,
    'personal_auditado' : personalAuditado,

      };

  RegistroGeneralModel copyWith({
    int? id,
    String? fbUeaPeId,
    String? codigo,
    String? gTipoOrigenId,
    String? fechaOps,
    String? horaOps,
    String? turno,
    String? fbAreaId,
    String? gRolEmpresaId,
    String? fbEmpresaEspecializadaId,
    String? fbEmpleadoId,
    String? opsListaVerificacionId,
    String? opsTipoResultadoId,
    String? latitud,
    String? longitud,
    String? fbAreaNombre,
    String? turnoNombre,
    String? fbEmpresaEspecializadaNombre,
    String? fbEmpleadoNombreCompleto,
    String? idGeneradoSyncronizacion,
    String? estado,
    String? flag,
    String? alcance,
    String? criterio,
    String? idOpsTipoInspeccion,
    String? idOpsSubTipoInspeccion,
    String? idOpsAlcanceInspeccion,

    String? OpsSubTipoInspeccionText,
    String? OpsTipoInspeccionText,
    String? OpsAlcanceInspeccionText,

    String? fbAuditorId,
    String? auditorNombre,
    String? involucrados,

    String? fbVerificadorId,
    String? verificadorNombre,
    String? inspectores,

    String? opsContratistaId,
    String? tipoServicioNombre,
    String? equipoAuditor,
    String? personalAuditado,
    String? contratistaNombre

  }) =>
      RegistroGeneralModel(
        id: id ?? this.id,
        fbUeaPeId: fbUeaPeId ?? this.fbUeaPeId,
        codigo: codigo ?? this.codigo,
        gTipoOrigenId: gTipoOrigenId ?? this.gTipoOrigenId,
        fechaOps: fechaOps ?? this.fechaOps,
        horaOps: horaOps ?? this.horaOps,
        turno: turno ?? this.turno,
        fbAreaId: fbAreaId ?? this.fbAreaId,
        gRolEmpresaId: gRolEmpresaId ?? this.gRolEmpresaId,
        fbEmpresaEspecializadaId:
        fbEmpresaEspecializadaId ?? this.fbEmpresaEspecializadaId,
        fbEmpleadoId: fbEmpleadoId ?? this.fbEmpleadoId,
        opsListaVerificacionId:
        opsListaVerificacionId ?? this.opsListaVerificacionId,
        opsTipoResultadoId: opsTipoResultadoId ?? this.opsTipoResultadoId,
        latitud: latitud ?? this.latitud,
        longitud: longitud ?? this.longitud,
        fbAreaNombre: fbAreaNombre ?? this.fbAreaNombre,
        turnoNombre: turnoNombre ?? this.turnoNombre,
        fbEmpresaEspecializadaNombre:
        fbEmpresaEspecializadaNombre ?? this.fbEmpresaEspecializadaNombre,
        fbEmpleadoNombreCompleto:
        fbEmpleadoNombreCompleto ?? this.fbEmpleadoNombreCompleto,
        idGeneradoSyncronizacion:
        idGeneradoSyncronizacion ?? this.idGeneradoSyncronizacion,
        estado: estado ?? this.estado,
        flag: flag ?? this.flag,
        alcance: alcance ?? this.alcance,
        criterio: criterio ?? this.criterio,
          idOpsTipoInspeccion : idOpsTipoInspeccion ?? this.idOpsTipoInspeccion,
          idOpsSubTipoInspeccion : idOpsSubTipoInspeccion ?? this.idOpsSubTipoInspeccion,
          idOpsAlcanceInspeccion : idOpsAlcanceInspeccion ?? this.idOpsAlcanceInspeccion,

          OpsSubTipoInspeccionText : OpsSubTipoInspeccionText ?? this.OpsSubTipoInspeccionText,
          OpsTipoInspeccionText : OpsTipoInspeccionText ?? this.OpsTipoInspeccionText,
          OpsAlcanceInspeccionText : OpsAlcanceInspeccionText ?? this.OpsAlcanceInspeccionText,

          fbAuditorId : fbAuditorId ?? this.fbAuditorId,
          auditorNombre : auditorNombre ?? this.auditorNombre,
          involucrados : involucrados ?? this.involucrados,
          fbVerificadorId : fbVerificadorId ?? this.fbVerificadorId,
          verificadorNombre : verificadorNombre ?? this.verificadorNombre,
          inspectores : inspectores ?? this.inspectores,
        opsContratistaId : opsContratistaId ?? this.opsContratistaId,
        tipoServicioNombre : tipoServicioNombre ?? this.tipoServicioNombre,
        equipoAuditor : equipoAuditor ?? this.equipoAuditor,
        personalAuditado : personalAuditado ?? this.personalAuditado,
          contratistaNombre : contratistaNombre ?? this.contratistaNombre
      );
}
