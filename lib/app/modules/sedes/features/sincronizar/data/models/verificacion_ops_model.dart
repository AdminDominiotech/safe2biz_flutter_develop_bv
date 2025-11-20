import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/verificacion_ops.dart';

class VerificacionOpsModel extends VerificacionOps {
  VerificacionOpsModel({
    required String id,
    required String opsTipoResultadoId,
    required String codigo,
    required String nombre,
    required String opsTipoChecklistId,
    required String opsSubTipoChecklistId,
  }) : super(
          id: id,
          opsTipoResultadoId: opsTipoResultadoId,
          codigo: codigo,
          nombre: nombre,
      opsTipoChecklistId:opsTipoChecklistId,
      opsSubTipoChecklistId: opsSubTipoChecklistId
        );

  factory VerificacionOpsModel.fromJson(Map<String, dynamic> json) =>
      VerificacionOpsModel(
        id: '${json['ops_lista_verificacion_id'] ?? ''}',
        opsTipoResultadoId: '${json['ops_tipo_resultado_id'] ?? ''}',
        codigo: json['codigo'] ?? '',
        nombre: json['nombre'] ?? '',
          opsTipoChecklistId: '${json['ops_tipo_checklist_id'] ?? ''}',
          opsSubTipoChecklistId : '${json['ops_sub_tipo_inspeccion_id'] ?? ''}',
      );

  Map<String, dynamic> toJson() => {
        'ops_lista_verificacion_id': id,
        'ops_tipo_resultado_id': opsTipoResultadoId,
        'codigo': codigo,
        'nombre': nombre,
        'ops_tipo_checklist_id' : opsTipoChecklistId,
    'ops_sub_tipo_inspeccion_id' : opsSubTipoChecklistId
      };

  VerificacionOpsModel copyWith({
    String? id,
    String? opsTipoResultadoId,
    String? codigo,
    String? nombre,
    String? opsTipoChecklistId,
    String? opsSubTipoChecklistId
  }) =>
      VerificacionOpsModel(
        id: id ?? this.id,
        opsTipoResultadoId: opsTipoResultadoId ?? this.opsTipoResultadoId,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
          opsTipoChecklistId: opsTipoChecklistId ?? this.opsTipoChecklistId,
          opsSubTipoChecklistId : opsSubTipoChecklistId ?? this.opsSubTipoChecklistId
      );
}
