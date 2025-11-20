import 'package:equatable/equatable.dart';

class ResultadoOps extends Equatable {
  ResultadoOps({
    required this.id,
    required this.opsTipoResultadoId,
    required this.codigo,
    required this.nombre,
    required this.opsTipoChecklistId
  });

  final String id;
  final String opsTipoResultadoId;
  final String codigo;
  final String nombre;
  final String opsTipoChecklistId;

  @override
  List<Object?> get props => [
        id,
        opsTipoResultadoId,
        codigo,
        nombre,
    opsTipoChecklistId
      ];
}
