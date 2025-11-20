import 'package:equatable/equatable.dart';

class VerificacionOps extends Equatable {
  VerificacionOps({
    required this.id,
    required this.opsTipoResultadoId,
    required this.codigo,
    required this.nombre,
    required this.opsTipoChecklistId,
    required this.opsSubTipoChecklistId
  });

  final String id;
  final String opsTipoResultadoId;
  final String codigo;
  final String nombre;
  final String opsTipoChecklistId;
  final String opsSubTipoChecklistId;

  @override
  List<Object?> get props => [
        id,
        opsTipoResultadoId,
        codigo,
        nombre,
    opsTipoChecklistId,
    opsSubTipoChecklistId
      ];
}
