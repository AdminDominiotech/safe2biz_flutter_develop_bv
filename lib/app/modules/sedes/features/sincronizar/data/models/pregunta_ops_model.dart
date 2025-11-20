import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/pregunta_ops.dart';

class PreguntaOpsModel extends PreguntaOps {
  PreguntaOpsModel({
    required String id,
    required String opsListaVerifSeccionId,
    required String opsListaVerifCategoriaId,
    required String opsListaVerificacionId,
    required String nombre,
    required String flagPregunta,
    required String orden,
    required String codigo,
  }) : super(
          id: id,
          opsListaVerifSeccionId: opsListaVerifSeccionId,
          opsListaVerifCategoriaId: opsListaVerifCategoriaId,
          opsListaVerificacionId: opsListaVerificacionId,
          nombre: nombre,
          flagPregunta: flagPregunta,
          orden: orden,
          codigo: codigo,
        );

  factory PreguntaOpsModel.fromJson(Map<String, dynamic> json) =>
      PreguntaOpsModel(
        id: '${json['ops_lista_verif_pregunta_id'] ?? ''}',
        opsListaVerifSeccionId: '${json['ops_lista_verif_seccion_id'] ?? ''}',
        opsListaVerifCategoriaId:
            '${json['ops_lista_verif_categoria_id'] ?? ''}',
        opsListaVerificacionId: '${json['ops_lista_verificacion_id'] ?? ''}',
        nombre: json['nombre'] ?? '',
        flagPregunta: '${json['flag_pregunta'] ?? ''}',
        orden: json['codigo'] ?? '',
        codigo: json['aux_codigo'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'ops_lista_verif_pregunta_id': id,
        'ops_lista_verif_seccion_id': opsListaVerifSeccionId,
        'ops_lista_verif_categoria_id': opsListaVerifCategoriaId,
        'ops_lista_verificacion_id': opsListaVerificacionId,
        'nombre': nombre,
        'flag_pregunta': flagPregunta,
        'orden': orden,
        'codigo': codigo,
      };

  PreguntaOpsModel copyWith({
    String? id,
    String? opsListaVerifSeccionId,
    String? opsListaVerifCategoriaId,
    String? opsListaVerificacionId,
    String? nombre,
    String? flagPregunta,
    String? orden,
    String? codigo,
  }) =>
      PreguntaOpsModel(
        id: id ?? this.id,
        opsListaVerifSeccionId:
            opsListaVerifSeccionId ?? this.opsListaVerifSeccionId,
        opsListaVerifCategoriaId:
            opsListaVerifCategoriaId ?? this.opsListaVerifCategoriaId,
        opsListaVerificacionId:
            opsListaVerificacionId ?? this.opsListaVerificacionId,
        nombre: nombre ?? this.nombre,
        flagPregunta: flagPregunta ?? this.flagPregunta,
        orden: orden ?? this.orden,
        codigo: codigo ?? this.codigo,
      );
}
