// ignore_for_file: must_be_immutable

import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';

class SacModel extends Sac {
  const SacModel({
    required String id,
    required String detalle,
    required String codigo,
    required String fecha,
    required String responsable,
    required String responsableVerificador,
    required String fechaOrigen,
    required String origen,
  }) : super(
            id: id,
            detalle: detalle,
            codigo: codigo,
            fecha: fecha,
            responsable: responsable,
            origen: origen,
            fechaOrigen: fechaOrigen,
            responsableVerificador: responsableVerificador);

  factory SacModel.fromJson(Map<String, dynamic> json) => SacModel(
        id: json['sac_accion_correctiva_id'] != null
            ? json['sac_accion_correctiva_id'].toString()
            : '',
        detalle: json['accion_correctiva_detalle'] ?? '',
        codigo: json['codigo_accion_correctiva'] ?? '',
        fecha: json['fecha_acordada_ejecucion'] ?? '',
        responsable: json['nombre_responsable_correccion'] ?? '',
    responsableVerificador: json['nombre_responsable_verificador'] ?? '',
    fechaOrigen: json['fecha_origen'] ?? '',
        origen: json['origen'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'sac_accion_correctiva_id': id,
        'accion_correctiva_detalle': detalle,
        'codigo_accion_correctiva': codigo,
        'fecha_acordada_ejecucion': fecha,
        'nombre_responsable_correccion': responsable,
        'origen': origen,
        'fecha_origen' : fechaOrigen,
        'nombre_responsable_verificador' : responsableVerificador
      };

  Sac copyWith({
    String? id,
    String? detalle,
    String? codigo,
    String? fecha,
    String? responsable,
    String? origen,
    String? fechaOrigen,
    String? responsableVerificador
  }) =>
      SacModel(
        id: id ?? this.id,
        detalle: detalle ?? this.detalle,
        codigo: codigo ?? this.codigo,
        fecha: fecha ?? this.fecha,
        responsable: responsable ?? this.responsable,
        origen: origen ?? this.origen,
          fechaOrigen: fechaOrigen ?? this.fechaOrigen,
          responsableVerificador : responsableVerificador ?? this.responsableVerificador
      );
}
