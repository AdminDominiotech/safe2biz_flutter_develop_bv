
import 'package:equatable/equatable.dart';

abstract class ExamenMedicoEmpleado extends Equatable {
  ExamenMedicoEmpleado({


    required this.fb_empleado_id,
    required this.examen_medico,
    required this.flag_aptitud,


  });


  int fb_empleado_id;
  String examen_medico;
  int flag_aptitud;



  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [

    fb_empleado_id,
    examen_medico,
    flag_aptitud,
  ];
}

