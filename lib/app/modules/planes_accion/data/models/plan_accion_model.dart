// ignore_for_file: must_be_immutable

import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';
class PlanesAccionModel extends PlanAccion {
  const PlanesAccionModel({
    // Campos originales
    required String id,
    required String detalle,
    required String codigo,
    required String fechaEjec,
    required String responsable,
    required String origen,
    required String evidenciaNombre,
    required String evidenciaRuta,
    required String estado,
    required String fechaEjecucion,
    required String ueaId,
    required String obsRespCorr,
    required String fechaOrigen,
    required String responsableVerificador


  }) : super(
    id: id,
    detalle: detalle,
    codigo: codigo,
    fechaEjec: fechaEjec,
    responsable: responsable,
    origen: origen,
    evidenciaNombre: evidenciaNombre,
    evidenciaRuta: evidenciaRuta,
    estado: estado,
    fechaEjecucion: fechaEjecucion,
    ueaId: ueaId,
    obsRespCorr: obsRespCorr,
      fechaOrigen: fechaOrigen,
      responsableVerificador: responsableVerificador
  );


  factory PlanesAccionModel.fromJson(Map<String, dynamic> json) {

    return PlanesAccionModel(
      // Mapea cada campo de acuerdo a la respuesta JSON
      id: json['sac_accion_correctiva_id']?.toString() ?? '',
      detalle: json['accion_correctiva_detalle'] ?? '',
      codigo: json['codigo_accion_correctiva'] ?? '',
      fechaEjec: json['fecha_ejecucion'] ?? '',
      responsable: json['nombre_responsable_correccion'] ?? '',
      origen: json['origen'] != null ? json['origen'].toString() : '',
      evidenciaNombre: json['evidencia_nombre'] ?? '',
      evidenciaRuta: json['evidencia_ruta'] ?? '',
      estado: json['estado'] != null ? json['estado'].toString() : '',
      fechaEjecucion: json['fecha_ejecucion'] ?? '',
      ueaId: json['uea_id']?.toString() ?? '',
      obsRespCorr: json['obs_resp_corr'] ?? '',

      fechaOrigen: json['fecha_origen'] ?? '',
      responsableVerificador: json['nombre_responsable_verificador'] ?? '',

    );
  }



  Map<String, dynamic> toJson() {
    return {
      'sac_accion_correctiva_id': id,
      'accion_correctiva_detalle': detalle,
      'codigo_accion_correctiva': codigo,
      'fecha_acordada_ejecucion': fechaEjec,
      'nombre_responsable_correccion': responsable,
      'origen': origen,
      'evidencia_nombre': evidenciaNombre,
      'evidencia_ruta': evidenciaRuta,
      'uea_id': ueaId,
      'fecha_ejecucion': fechaEjecucion,
      'estado': estado,
      'obs_resp_corr': obsRespCorr,
      'fecha_origen' : fechaOrigen,
      'nombre_responsable_verificador' : responsableVerificador

    };
  }

  PlanesAccionModel copyWith({
    String? id,
    String? detalle,
    String? codigo,
    String? fechaEjec,
    String? responsable,
    String? origen,
    String? evidenciaNombre,
    String? evidenciaRuta,
    String? estado,
    String? fechaEjecucion,
    String? ueaId,
    String? obsRespCorr,
    String? fechaOrigen,
    String? responsableVerificador

  }) {
    return PlanesAccionModel(
      id: id ?? this.id,
      detalle: detalle ?? this.detalle,
      codigo: codigo ?? this.codigo,
      fechaEjec: fechaEjec ?? this.fechaEjec,
      responsable: responsable ?? this.responsable,
      origen: origen ?? this.origen,
      evidenciaNombre: evidenciaNombre ?? this.evidenciaNombre,
      evidenciaRuta: evidenciaRuta ?? this.evidenciaRuta,
      estado: estado ?? this.estado,
      fechaEjecucion: fechaEjecucion ?? this.fechaEjecucion,
      ueaId: ueaId ?? this.ueaId,
      obsRespCorr: obsRespCorr ?? this.obsRespCorr,
        fechaOrigen : fechaOrigen ?? this.fechaOrigen,
        responsableVerificador : responsableVerificador ?? this.responsableVerificador
    );
  }
}
