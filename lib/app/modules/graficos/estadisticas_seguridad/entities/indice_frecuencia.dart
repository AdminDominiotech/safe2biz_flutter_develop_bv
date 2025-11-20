
import 'package:equatable/equatable.dart';

abstract class indice_frecuencia extends Equatable {
  indice_frecuencia({
    required this.mes,
    required this.rol,
    required this.accidentes,
  });

  int mes;
  String rol;
  int accidentes;


  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [
    mes,
    rol,
    accidentes
  ];
}
