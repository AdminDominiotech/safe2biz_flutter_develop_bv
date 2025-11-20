
import 'package:equatable/equatable.dart';

abstract class MedicoEmpleado extends Equatable {
  MedicoEmpleado({

    required this.id,
    required this.codigo,
    required this.nombre,
    required this.tipo_evaluacion_nombre,
    required this.aptitud_nombre,
    required this.medico_responsable,
    required this.observacion_medica,
    required this.centro_medico,
    required this.fecha_ini,
    required this.fecha_fin



  });


  /// ayc_registro_id
  /// ayc_registro_id
  int id;
  String codigo;
  String nombre;
  String tipo_evaluacion_nombre;
  String aptitud_nombre;
  String medico_responsable;
  String observacion_medica;
  String centro_medico;
  String fecha_ini;
  String fecha_fin;

  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [
    id,
    codigo,
    nombre,
    tipo_evaluacion_nombre,
    aptitud_nombre,
    medico_responsable,
    observacion_medica,
    centro_medico,
    fecha_ini,
    fecha_fin

  ];
}

