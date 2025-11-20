import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class Turno extends Equatable {
  const Turno({
    required this.id,
    required this.codigo,
    required this.nombre,
  });

  final String id;
  final String codigo;
  final String nombre;

  @override
  List<Object> get props => [
        id,
        codigo,
        nombre,
      ];
}
