import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';

class NivelRiesgoModel extends NivelRiesgo {
  const NivelRiesgoModel({
    required String id,
    required String nombre,
  }) : super(
          id: id,
          nombre: nombre,
        );

  factory NivelRiesgoModel.fromJson(Map<String, dynamic> json) =>
      NivelRiesgoModel(
        id: json['g_nivel_riesgo_id'] != null
            ? json['g_nivel_riesgo_id'].toString()
            : '',
        nombre: json['nombre'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'g_nivel_riesgo_id': id,
        'nombre': nombre,
      };

  NivelRiesgoModel copyWith({
    String? id,
    String? nombre,
  }) =>
      NivelRiesgoModel(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
      );
}
