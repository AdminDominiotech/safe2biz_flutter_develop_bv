import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';

class TipoEventoModel extends TipoEvento {
  const TipoEventoModel({
    required String id,
    required String nombre,
  }) : super(
          id: id,
          nombre: nombre,
        );

  factory TipoEventoModel.fromJson(Map<String, dynamic> json) =>
      TipoEventoModel(
        id: json['inc_tipo_reporte_id'] != null
            ? json['inc_tipo_reporte_id'].toString()
            : '',
        nombre: json['nombre'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'inc_tipo_reporte_id': id,
        'nombre': nombre,
      };

  TipoEventoModel copyWith({
    String? id,
    String? nombre,
  }) =>
      TipoEventoModel(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
      );
}
