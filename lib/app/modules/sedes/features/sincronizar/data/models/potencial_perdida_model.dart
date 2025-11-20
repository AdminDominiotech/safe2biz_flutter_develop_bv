import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/potencial_perdida.dart';

// ignore: must_be_immutable
class PotencialPerdidaModel extends PotencialPerdida {
  const PotencialPerdidaModel({
    required String id,
    required String nombre,
    required String codigo,
  }) : super(
          id: id,
          nombre: nombre,
          codigo: codigo,
        );

  factory PotencialPerdidaModel.fromJson(Map<String, dynamic> json) =>
      PotencialPerdidaModel(
        id: json['inc_potencial_perdida_id'] != null
            ? json['inc_potencial_perdida_id'].toString()
            : '',
        nombre: json['nombre'] ?? '',
        codigo: json['codigo'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'inc_potencial_perdida_id': id,
        'nombre': nombre,
        'codigo': codigo,
      };

  PotencialPerdidaModel copyWith({
    String? id,
    String? nombre,
    String? codigo,
  }) =>
      PotencialPerdidaModel(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        codigo: codigo ?? this.codigo,
      );
}
