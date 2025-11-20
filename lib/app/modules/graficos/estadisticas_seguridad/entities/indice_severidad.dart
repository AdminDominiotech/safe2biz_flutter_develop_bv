
import 'package:equatable/equatable.dart';

abstract class indice_severidad extends Equatable {
  indice_severidad({
    required this.mes,
    required this.rol,
    required this.dias_per,
  });

  int mes;
  String rol;
  int dias_per;

  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [

    mes,
    rol,
    dias_per

  ];
}


