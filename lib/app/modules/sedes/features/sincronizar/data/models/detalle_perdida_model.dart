// ignore: must_be_immutable
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/detalle_perdida.dart';

class DetallePerdidaModel extends DetallePerdida {
  const DetallePerdidaModel({
    required String id,
    required String nombre,
    required String codigo,
    required String tipoReporteId,
  }) : super(
          id: id,
          nombre: nombre,
          codigo: codigo,
          tipoReporteId: tipoReporteId,
        );

  factory DetallePerdidaModel.fromJson(Map<String, dynamic> json) =>
      DetallePerdidaModel(
        id: json['inc_segun_tipo_id'] != null
            ? json['inc_segun_tipo_id'].toString()
            : '',
        nombre: json['nombre'] ?? '',
        codigo: json['codigo'] ?? '',
        tipoReporteId: json['inc_tipo_reporte_id'] != null
            ? json['inc_tipo_reporte_id'].toString()
            : '',
      );

  Map<String, dynamic> toJson() => {
        'inc_segun_tipo_id': id,
        'nombre': nombre,
        'codigo': codigo,
        'inc_tipo_reporte_id': tipoReporteId,
      };

  DetallePerdidaModel copyWith({
    String? id,
    String? nombre,
    String? codigo,
    String? tipoReporteId,
  }) =>
      DetallePerdidaModel(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        codigo: codigo ?? this.codigo,
        tipoReporteId: tipoReporteId ?? this.tipoReporteId,
      );
}
