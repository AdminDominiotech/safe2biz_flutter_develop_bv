import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/tipo_reporte.dart';

// ignore: must_be_immutable
class TipoReporteModel extends TipoReporte {
  const TipoReporteModel({
    required String id,
    required String nombre,
  }) : super(
          id: id,
          nombre: nombre,
        );

  factory TipoReporteModel.fromJson(Map<String, dynamic> json) =>
      TipoReporteModel(
        id: json['inc_tipo_reporte_id'] != null
            ? json['inc_tipo_reporte_id'].toString()
            : '',
        nombre: json['nombre'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'inc_tipo_reporte_id': id,
        'nombre': nombre,
      };

  TipoReporteModel copyWith({
    String? id,
    String? nombre,
  }) =>
      TipoReporteModel(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
      );
}
