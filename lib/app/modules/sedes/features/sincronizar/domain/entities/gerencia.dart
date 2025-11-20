import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class Gerencia extends Equatable {
  Gerencia({
    required this.id,
    required this.fbUeaPeId,
    required this.codigo,
    required this.nombre,
  });

  final String id;
  final String fbUeaPeId;
  final String codigo;
  final String nombre;

  @override
  List<Object> get props => [
        id,
        fbUeaPeId,
        codigo,
        nombre,
      ];
}
