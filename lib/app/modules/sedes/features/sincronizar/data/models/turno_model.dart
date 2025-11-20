// ignore_for_file: must_be_immutable

import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';

class TurnoModel extends Turno {
  const TurnoModel({
    required String id,
    required String codigo,
    required String nombre,
  }) : super(
          id: id,
          codigo: codigo,
          nombre: nombre,
        );

  factory TurnoModel.fromJson(Map<String, dynamic> json) => TurnoModel(
        id: json['id'] != null ? json['fb_area_id'].toString() : '',
        codigo: json['codigo'] ?? '',
        nombre: json['nombre'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'fb_area_id': id,
        'nombre': nombre,
        'codigo': codigo,
      };

  Turno copyWith({
    String? id,
    String? codigo,
    String? nombre,
  }) =>
      TurnoModel(
        id: id ?? this.id,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
      );
}
