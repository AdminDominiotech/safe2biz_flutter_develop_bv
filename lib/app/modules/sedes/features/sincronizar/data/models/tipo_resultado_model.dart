import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/tipo_resultado.dart';

class TipoResultadoModel extends TipoResultado {
  TipoResultadoModel({
    required String id,
    required String codigo,
    required String nombre,
  }) : super(
          id: id,
          codigo: codigo,
          nombre: nombre,
        );

  factory TipoResultadoModel.fromJson(Map<String, dynamic> json) =>
      TipoResultadoModel(
        id: json['ops_tipo_resultado_id'] ?? '',
        codigo: json['codigo'] ?? '',
        nombre: json['nombre'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'ops_tipo_resultado_id': id,
        'codigo': codigo,
        'nombre': nombre,
      };

  TipoResultadoModel copyWith({
    String? id,
    String? codigo,
    String? nombre,
  }) =>
      TipoResultadoModel(
        id: id ?? this.id,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
      );
}
