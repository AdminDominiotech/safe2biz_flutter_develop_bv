// ignore_for_file: must_be_immutable
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';

class DesviacionModel extends Desviacion {
  DesviacionModel({
    required String id,
    required String ayc,
    required String descripcion,
  }) : super(
          id: id,
          ayc: ayc,
          descripcion: descripcion,
        );

  factory DesviacionModel.fromJson(Map<String, dynamic> json) =>
      DesviacionModel(
        id: json['g_tipo_causa_id'] != null
            ? json['g_tipo_causa_id'].toString()
            : '',
        ayc: json['ayc'] ?? '',
        descripcion: json['descripcion'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'g_tipo_causa_id': id,
        'descripcion': descripcion,
        'ayc': ayc,
      };

  Desviacion copyWith({
    String? id,
    String? ayc,
    String? descripcion,
  }) =>
      DesviacionModel(
        id: id ?? this.id,
        ayc: ayc ?? this.ayc,
        descripcion: descripcion ?? this.descripcion,
      );
}
