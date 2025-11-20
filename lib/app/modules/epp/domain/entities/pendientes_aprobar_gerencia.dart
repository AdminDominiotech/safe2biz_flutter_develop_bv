
import 'package:equatable/equatable.dart';

abstract class PendienteAprobarGerencia extends Equatable {
  PendienteAprobarGerencia({
    required this.gerencia,
    required this.cantidad,


  });

  /// ayc_registro_id
  String gerencia ;
  int cantidad;

  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [
    gerencia,
    cantidad,

  ];
}

