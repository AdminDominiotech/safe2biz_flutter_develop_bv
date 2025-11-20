import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class DetallePerdida extends Equatable {
  const DetallePerdida({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.tipoReporteId,
  });

  final String id;
  final String nombre;
  final String codigo;
  final String tipoReporteId;

  @override
  List<Object> get props => [
        id,
        nombre,
        codigo,
        tipoReporteId,
      ];
}
