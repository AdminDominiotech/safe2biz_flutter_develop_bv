import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/categoria_ops.dart';

class CategoriaOpsModel extends CategoriaOps {
  CategoriaOpsModel({
    required String id,
    required String opsListaVerificacionId,
    required String nombre,
  }) : super(
          id: id,
          opsListaVerificacionId: opsListaVerificacionId,
          nombre: nombre,
        );

  factory CategoriaOpsModel.fromJson(Map<String, dynamic> json) =>
      CategoriaOpsModel(
        id: '${json['ops_lista_verif_categoria_id'] ?? ''}',
        opsListaVerificacionId: '${json['ops_lista_verificacion_id'] ?? ''}',
        nombre: json['nombre'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'ops_lista_verif_categoria_id': id,
        'ops_lista_verificacion_id': opsListaVerificacionId,
        'nombre': nombre,
      };
  CategoriaOpsModel copyWith({
    String? id,
    String? opsListaVerificacionId,
    String? nombre,
  }) =>
      CategoriaOpsModel(
        id: id ?? this.id,
        opsListaVerificacionId:
            opsListaVerificacionId ?? this.opsListaVerificacionId,
        nombre: nombre ?? this.nombre,
      );
}
