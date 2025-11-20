import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/sub_tipo_reporte.dart';

// ignore: must_be_immutable
class SubTipoReporteModel extends SubTipoReporte {
  const SubTipoReporteModel({
    required String id,
    required String nombre,
    required String tipoReporteId,
  }) : super(
          id: id,
          nombre: nombre,
          tipoReporteId: tipoReporteId,
        );

  factory SubTipoReporteModel.fromJson(Map<String, dynamic> json) =>
      SubTipoReporteModel(
        id: json['inc_sub_tipo_reporte_id'] != null
            ? json['inc_sub_tipo_reporte_id'].toString()
            : '',
        nombre: json['nombre'] ?? '',
        tipoReporteId: json['inc_tipo_reporte_id'] != null
            ? json['inc_tipo_reporte_id'].toString()
            : '',
      );

  Map<String, dynamic> toJson() => {
        'inc_sub_tipo_reporte_id': id,
        'nombre': nombre,
        'inc_tipo_reporte_id': tipoReporteId,
      };

  SubTipoReporteModel copyWith({
    String? id,
    String? nombre,
    String? tipoReporteId,
  }) =>
      SubTipoReporteModel(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        tipoReporteId: tipoReporteId ?? this.tipoReporteId,
      );
}
