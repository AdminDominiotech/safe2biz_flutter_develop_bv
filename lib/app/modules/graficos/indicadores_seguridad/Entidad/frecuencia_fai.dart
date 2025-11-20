
import 'package:equatable/equatable.dart';

abstract class frecuencia_fai extends Equatable {
  frecuencia_fai({
    required this.anho,
    required this.nombre,
    required this.indicador,
  });

  int anho;
  String nombre;
  double indicador;

  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [

    anho,
    nombre,
    indicador

  ];
}


