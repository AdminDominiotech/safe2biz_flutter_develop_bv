import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/seccion_ops.dart';

class SeccionOpsModel extends SeccionOps {
  SeccionOpsModel({
    required String id,
    required String opsListaVerifCategoriaId,
    required String opsListaVerificacionId,
    required String nombre,
    required String orden,
  }) : super(
          id: id,
          opsListaVerifCategoriaId: opsListaVerifCategoriaId,
          opsListaVerificacionId: opsListaVerificacionId,
          nombre: nombre,
          orden: orden,
        );

  factory SeccionOpsModel.fromJson(Map<String, dynamic> json) =>
      SeccionOpsModel(
        id: json['ops_lista_verif_seccion_id'].toString(),
        opsListaVerifCategoriaId:
            json['ops_lista_verif_categoria_id'].toString(),
        opsListaVerificacionId: json['ops_lista_verificacion_id'].toString(),
        nombre: json['nombre'] ?? '',
        orden: json['codigo'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'ops_lista_verif_seccion_id  ': id,
        'ops_lista_verif_categoria_id': opsListaVerifCategoriaId,
        'ops_lista_verificacion_id   ': opsListaVerificacionId,
        'nombre': nombre,
        'orden': orden,
      };
  SeccionOpsModel copyWith({
    String? id,
    String? opsListaVerifCategoriaId,
    String? opsListaVerificacionId,
    String? nombre,
    String? orden,
  }) =>
      SeccionOpsModel(
        id: id ?? this.id,
        opsListaVerifCategoriaId:
            opsListaVerifCategoriaId ?? this.opsListaVerifCategoriaId,
        opsListaVerificacionId:
            opsListaVerificacionId ?? this.opsListaVerificacionId,
        nombre: nombre ?? this.nombre,
        orden: orden ?? this.orden,
      );
}
