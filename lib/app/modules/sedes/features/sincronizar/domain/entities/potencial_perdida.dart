import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class PotencialPerdida extends Equatable {
  const PotencialPerdida({
    required this.id,
    required this.nombre,
    required this.codigo,
  });

  final String id;
  final String nombre;
  final String codigo;

  @override
  List<Object> get props => [
        id,
        nombre,
        codigo,
      ];
}
