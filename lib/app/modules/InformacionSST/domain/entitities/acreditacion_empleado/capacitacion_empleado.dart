
import 'package:equatable/equatable.dart';

abstract class CapacitacionEmpleado extends Equatable {
  CapacitacionEmpleado({


    required this.fb_empleado_id,
    required this.capacitacion,
    required this.flag_aptitud,


  });


  int fb_empleado_id;
  String capacitacion;
  int flag_aptitud;




  @override
  List<Object> get props => [

    fb_empleado_id,
    capacitacion,
    flag_aptitud,
  ];
}

