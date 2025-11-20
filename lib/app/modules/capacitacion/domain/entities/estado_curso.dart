
import 'package:equatable/equatable.dart';

abstract class EstadoCurso extends Equatable {
  EstadoCurso({

    required this.id,
    required this.nombre,



  });


  /// ayc_registro_id
  /// ayc_registro_id
  int id;
  String nombre;


  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [
    id,
    nombre,


  ];
}

