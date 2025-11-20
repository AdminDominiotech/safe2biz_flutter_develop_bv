import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/resultado_ops.dart';

class ResultadoOpsModel extends ResultadoOps {
  ResultadoOpsModel({
    required String id,
    required String opsTipoResultadoId,
    required String codigo,
    required String nombre,
    required String opsTipoChecklistId,
  }) : super(
          id: id,
          opsTipoResultadoId: opsTipoResultadoId,
          codigo: codigo,
          nombre: nombre,
          opsTipoChecklistId:opsTipoChecklistId
        );

  factory ResultadoOpsModel.fromJson(Map<String, dynamic> json) =>
      ResultadoOpsModel(
        id: '${json['ops_lista_verif_resultado_id']}',
        opsTipoResultadoId: '${json['ops_tipo_resultado_id']}',
        codigo: json['codigo'],
        nombre: json['nombre'],
          opsTipoChecklistId: '${json['ops_tipo_checklist_id']}',
      );

  Map<String, dynamic> toJson() => {
        'ops_lista_verif_resultado_id': id,
        'ops_tipo_resultado_id': opsTipoResultadoId,
        'codigo': codigo,
        'nombre': nombre,
        'ops_tipo_checklist_id':opsTipoChecklistId
      };
  ResultadoOpsModel copyWith({
    String? id,
    String? opsTipoResultadoId,
    String? codigo,
    String? nombre,
    String? opsTipoChecklistId,
  }) =>
      ResultadoOpsModel(
        id: id ?? this.id,
        opsTipoResultadoId: opsTipoResultadoId ?? this.opsTipoResultadoId,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
          opsTipoChecklistId : opsTipoChecklistId ?? this.opsTipoChecklistId
      );
}
