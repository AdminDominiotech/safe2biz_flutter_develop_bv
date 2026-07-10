import 'package:equatable/equatable.dart';

// ignore: must_be_immutable

abstract class Area extends Equatable {
  const Area({
    required this.id,
    required this.fbGerenciaId,
    required this.codigo,
    required this.nombre,
    required this.fb_uea_base_id,
    required this.flagMinaInterior
  });

  final String id;
  final String fbGerenciaId;
  final String codigo;
  final String nombre;
  final String fb_uea_base_id;
  final String flagMinaInterior;

  @override
  List<Object> get props => [
        id,
        fbGerenciaId,
        codigo,
        nombre,
        fb_uea_base_id,
        flagMinaInterior
      ];
}
