import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';

class RegistroResultadoModel extends RegistroResultado {
  RegistroResultadoModel({
    required int id,
    required String opsRegistroGeneralesId,
    required String opsListaVerifPreguntaId,
    required String opsListaVerifSeccionId,
    required String opsListaVerifCategoriaId,
    required String opsListaVerifResultadoId,
    required String observacion,
    required String rutaImagen,
    required String nombreImagen,
    required String idGeneradoSyncronizacion,
    required String auxCodigo,
    required int estado,
  }) : super(
          id: id,
          opsRegistroGeneralesId: opsRegistroGeneralesId,
          opsListaVerifPreguntaId: opsListaVerifPreguntaId,
          opsListaVerifSeccionId: opsListaVerifSeccionId,
          opsListaVerifCategoriaId: opsListaVerifCategoriaId,
          opsListaVerifResultadoId: opsListaVerifResultadoId,
          observacion: observacion,
          rutaImagen: rutaImagen,
          nombreImagen: nombreImagen,
          idGeneradoSyncronizacion: idGeneradoSyncronizacion,
          auxCodigo: auxCodigo,
          estado:estado
        );

  factory RegistroResultadoModel.fromJson(Map<String, dynamic> json) =>
      RegistroResultadoModel(
        id: json["ops_registro_resultado_id"] ?? 0,
        opsRegistroGeneralesId: json["ops_registro_generales_id"] ?? '',
        opsListaVerifPreguntaId: json["ops_lista_verif_pregunta_id"] ?? '',
        opsListaVerifSeccionId: json["ops_lista_verif_seccion_id"] ?? '',
        opsListaVerifCategoriaId: json["ops_lista_verif_categoria_id"] ?? '',
        opsListaVerifResultadoId: json["ops_lista_verif_resultado_id"] ?? '',
        observacion: json["observacion"] ?? '',
        rutaImagen: json["ruta_imagen"] ?? '',
        nombreImagen: json["nombre_imagen"] ?? '',
        idGeneradoSyncronizacion: json["id_generado_syncronizacion"] ?? '',
        auxCodigo: json["aux_codigo"] ?? '',
        estado: json["estado"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "ops_registro_resultado_id": id,
        "ops_registro_generales_id": opsRegistroGeneralesId,
        "ops_lista_verif_pregunta_id": opsListaVerifPreguntaId,
        "ops_lista_verif_seccion_id": opsListaVerifSeccionId,
        "ops_lista_verif_categoria_id": opsListaVerifCategoriaId,
        "ops_lista_verif_resultado_id": opsListaVerifResultadoId,
        "observacion": observacion,
        "ruta_imagen": rutaImagen,
        "nombre_imagen": nombreImagen,
        "id_generado_syncronizacion": idGeneradoSyncronizacion,
        "aux_codigo": auxCodigo,
        "estado" : estado
      };
  RegistroResultadoModel copyWith({
    int? id,
    String? opsRegistroGeneralesId,
    String? opsListaVerifPreguntaId,
    String? opsListaVerifSeccionId,
    String? opsListaVerifCategoriaId,
    String? opsListaVerifResultadoId,
    String? observacion,
    String? rutaImagen,
    String? nombreImagen,
    String? idGeneradoSyncronizacion,
    String? auxCodigo,
    int? estado,
  }) =>
      RegistroResultadoModel(
        id: id ?? this.id,
        opsRegistroGeneralesId:
            opsRegistroGeneralesId ?? this.opsRegistroGeneralesId,
        opsListaVerifPreguntaId:
            opsListaVerifPreguntaId ?? this.opsListaVerifPreguntaId,
        opsListaVerifSeccionId:
            opsListaVerifSeccionId ?? this.opsListaVerifSeccionId,
        opsListaVerifCategoriaId:
            opsListaVerifCategoriaId ?? this.opsListaVerifCategoriaId,
        opsListaVerifResultadoId:
            opsListaVerifResultadoId ?? this.opsListaVerifResultadoId,
        observacion: observacion ?? this.observacion,
        rutaImagen: rutaImagen ?? this.rutaImagen,
        nombreImagen: nombreImagen ?? this.nombreImagen,
        idGeneradoSyncronizacion:
            idGeneradoSyncronizacion ?? this.idGeneradoSyncronizacion,
        auxCodigo: auxCodigo ?? this.auxCodigo,
        estado: estado ?? this.estado
      );
}
