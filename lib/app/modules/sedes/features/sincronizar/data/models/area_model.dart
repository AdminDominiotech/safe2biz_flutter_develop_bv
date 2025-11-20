// ignore_for_file: must_be_immutable

import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';

class AreaModel extends Area {
  const AreaModel({
    required String id,
    required String fbGerenciaId,
    required String codigo,
    required String nombre,
  }) : super(
          id: id,
          fbGerenciaId: fbGerenciaId,
          codigo: codigo,
          nombre: nombre,
        );

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        id: json['fb_area_id'] != null ? json['fb_area_id'].toString() : '',
        fbGerenciaId: json['fb_gerencia_id'] != null
            ? json['fb_gerencia_id'].toString()
            : '',
        codigo: json['codigo'] ?? '',
        nombre: json['nombre'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'fb_area_id': id,
        'fb_gerencia_id': fbGerenciaId,
        'nombre': nombre,
        'codigo': codigo,
      };

  Area copyWith({
    String? id,
    String? fbGerenciaId,
    String? codigo,
    String? nombre,
  }) =>
      AreaModel(
        id: id ?? this.id,
        fbGerenciaId: fbGerenciaId ?? this.fbGerenciaId,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
      );
}
