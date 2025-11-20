import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class NivelRiesgo extends Equatable {
  const NivelRiesgo({
    required this.id,
    required this.nombre,
  });

  final String id;
  final String nombre;

  @override
  List<Object> get props => [
        id,
        nombre,
      ];
}
