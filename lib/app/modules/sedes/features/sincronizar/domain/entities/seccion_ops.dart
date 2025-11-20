import 'package:equatable/equatable.dart';

class SeccionOps extends Equatable {
  SeccionOps({
    required this.id,
    required this.opsListaVerifCategoriaId,
    required this.opsListaVerificacionId,
    required this.nombre,
    required this.orden,
  });

  final String id;
  final String opsListaVerifCategoriaId;
  final String opsListaVerificacionId;
  final String nombre;
  final String orden;

  @override
  List<Object?> get props => [
        id,
        opsListaVerifCategoriaId,
        opsListaVerificacionId,
        nombre,
        orden,
      ];
}
