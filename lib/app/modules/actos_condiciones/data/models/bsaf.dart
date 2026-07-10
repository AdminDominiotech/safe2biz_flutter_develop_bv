import 'package:equatable/equatable.dart';

abstract class Bsaf extends Equatable {
  Bsaf({
    required this.inc_bsaf_id,
    required this.nombre,



  });

  String inc_bsaf_id;
  String nombre;


  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [
    inc_bsaf_id,
    nombre,


  ];
}


