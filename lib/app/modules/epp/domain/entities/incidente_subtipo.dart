
import 'package:equatable/equatable.dart';

abstract class IncidenteSubtipo extends Equatable {
  IncidenteSubtipo({
    required this.nombre,
    required this.cantidad,


  });


  /*
  PendienteAprobarGerencia.fromMap(Map<String, dynamic> map) {
    gerencia = map[gerencia];
    cantidad = map[cantidad];
  }

   */


  /// ayc_registro_id
  String nombre;
  int cantidad;

  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [
    nombre,
    cantidad,

  ];
}

