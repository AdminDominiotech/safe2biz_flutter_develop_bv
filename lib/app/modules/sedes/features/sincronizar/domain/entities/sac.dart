import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class Sac extends Equatable {
  const Sac({
    required this.id,
    required this.detalle,
    required this.codigo,
    required this.fecha,
    required this.responsable,
    required this.origen,
    required this.fechaOrigen,
    required this.responsableVerificador,
  });

  final String id;
  final String detalle;
  final String codigo;
  final String fecha;
  final String responsable;
  final String origen;
  final String fechaOrigen;
  final String responsableVerificador;


  @override
  List<Object> get props => [
        id,
        detalle,
        codigo,
        fecha,
        responsable,
        origen,
    fechaOrigen,
  responsableVerificador

      ];
}
