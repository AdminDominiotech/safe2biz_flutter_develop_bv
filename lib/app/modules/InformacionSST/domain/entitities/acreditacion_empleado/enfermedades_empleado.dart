
import 'package:equatable/equatable.dart';

abstract class EnfermedadesEmpleado extends Equatable {
  EnfermedadesEmpleado({


    required this.fb_empleado_id,
    required this.enfermedad,



  });


  /// ayc_registro_id
  /// ayc_registro_id

  int fb_empleado_id;
  String enfermedad;




  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [

    fb_empleado_id,
    enfermedad,

  ];
}

