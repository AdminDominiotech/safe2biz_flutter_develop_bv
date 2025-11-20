import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class Area extends Equatable {
  const Area({
    required this.id,
    required this.fbGerenciaId,
    required this.codigo,
    required this.nombre,
  });

  final String id;
  final String fbGerenciaId;
  final String codigo;
  final String nombre;

  @override
  List<Object> get props => [
        id,
        fbGerenciaId,
        codigo,
        nombre,
      ];
}
