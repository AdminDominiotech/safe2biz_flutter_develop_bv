// ignore_for_file: must_be_immutable

import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';

class AreaModel extends Area {

  const AreaModel({
    required String id,
    required String fbGerenciaId,
    required String codigo,
    required String nombre,
    required String fb_uea_base_id,
    required String flagMinaInterior,
  }) : super(
          id: id,
          fbGerenciaId: fbGerenciaId,
          codigo: codigo,
          nombre: nombre,
          fb_uea_base_id: fb_uea_base_id,
          flagMinaInterior: flagMinaInterior
        );

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        id: json['fb_area_id'] != null ? json['fb_area_id'].toString() : '',
        fbGerenciaId: json['fb_gerencia_id'] != null
            ? json['fb_gerencia_id'].toString()
            : '',
        codigo: json['codigo'] ?? '',
        nombre: json['nombre'] ?? '',
      fb_uea_base_id : json['fb_uea_base_id'] != null ? json['fb_uea_base_id'].toString() : '',
      flagMinaInterior: json['flag_mina_interior'] != null ? json['flag_mina_interior'].toString() : '0',
      );

  Map<String, dynamic> toJson() => {
        'fb_area_id': id,
        'fb_gerencia_id': fbGerenciaId,
        'nombre': nombre,
        'codigo': codigo,
        'fb_uea_base_id' : fb_uea_base_id,
        'flag_mina_interior': flagMinaInterior
      };

  Area copyWith({
    String? id,
    String? fbGerenciaId,
    String? codigo,
    String? nombre,
    String? fb_uea_base_id,
    String? flagMinaInterior
  }) =>
      AreaModel(
        id: id ?? this.id,
        fbGerenciaId: fbGerenciaId ?? this.fbGerenciaId,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
          fb_uea_base_id : fb_uea_base_id ?? this.fb_uea_base_id,
          flagMinaInterior: flagMinaInterior ?? this.flagMinaInterior
      );
}
