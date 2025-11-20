import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class SubTipoReporte extends Equatable {
  const SubTipoReporte({
    required this.id,
    required this.nombre,
    required this.tipoReporteId,
  });

  final String id;
  final String nombre;
  final String tipoReporteId;

  @override
  List<Object> get props => [
        id,
        nombre,
        tipoReporteId,
      ];
}
