import 'package:equatable/equatable.dart';

class PreguntaOps extends Equatable {
  PreguntaOps({
    required this.id,
    required this.opsListaVerifSeccionId,
    required this.opsListaVerifCategoriaId,
    required this.opsListaVerificacionId,
    required this.nombre,
    required this.flagPregunta,
    required this.orden,
    required this.codigo,
  });

  final String id;
  final String opsListaVerifSeccionId;
  final String opsListaVerifCategoriaId;
  final String opsListaVerificacionId;
  final String nombre;
  final String flagPregunta;
  final String orden;
  final String codigo;

  @override
  List<Object?> get props => [
        id,
        opsListaVerifSeccionId,
        opsListaVerifCategoriaId,
        opsListaVerificacionId,
        nombre,
        flagPregunta,
        orden,
        codigo,
      ];
}
