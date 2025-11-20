import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class Empleado extends Equatable {
  Empleado({
    required this.id,
    required this.fbUeaPeId,
    required this.nombreCompleto,
    required this.numeroDocumento,
    required this.cargoNombre,
    required this.gerenciaNombre,
    required this.empresa,
  });

  String id;
  String fbUeaPeId;
  String nombreCompleto;
  String numeroDocumento;
  String cargoNombre;
  String gerenciaNombre;
  String empresa;

  @override
  List<Object> get props => [
        id,
        fbUeaPeId,
        nombreCompleto,
        numeroDocumento,
        cargoNombre,
        gerenciaNombre,
        empresa
      ];
}
