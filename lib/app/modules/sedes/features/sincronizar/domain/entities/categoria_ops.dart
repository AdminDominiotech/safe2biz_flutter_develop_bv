import 'package:equatable/equatable.dart';

class CategoriaOps extends Equatable {
  CategoriaOps({
    required this.id,
    required this.opsListaVerificacionId,
    required this.nombre,
  });

  final String id;
  final String opsListaVerificacionId;
  final String nombre;

  @override
  List<Object> get props => [
        id,
        opsListaVerificacionId,
        nombre,
      ];
}
