
import 'dart:convert';

import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/MiInformacion/g_medico_empleado.dart';

List<MedicoEmpleadoModel> EstadoCursoFromJson(String str) =>
    List<MedicoEmpleadoModel>.from(json.decode(str).map((x) => MedicoEmpleadoModel.fromJson(x)));

String EstadoCursoToJson(List<MedicoEmpleadoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MedicoEmpleadoModel extends MedicoEmpleado {

  MedicoEmpleadoModel({
    required int id,
    required String codigo,
    required String nombre,
    required String tipo_evaluacion_nombre,
    required String aptitud_nombre,
    required String medico_responsable,
    required String observacion_medica,
    required String centro_medico,
    required String fecha_ini,
    required String fecha_fin




  }) : super(

    id : id,
    codigo: codigo,
    nombre: nombre,
      tipo_evaluacion_nombre:tipo_evaluacion_nombre,
      aptitud_nombre:aptitud_nombre,
      medico_responsable:medico_responsable,
      observacion_medica:observacion_medica,
      centro_medico:centro_medico,
      fecha_ini:fecha_ini,
      fecha_fin:fecha_fin

  );


  factory MedicoEmpleadoModel.fromJson(json) =>
      MedicoEmpleadoModel(
        id: json['exa_grupo_examen_medico_id'] ?? 0,
        codigo: json['codigo'] ?? '',
        nombre: json['nombre'] ?? '',

        tipo_evaluacion_nombre: json['tipo_evaluacion_nombre'] ?? '',
        aptitud_nombre: json['aptitud_nombre'] ?? '',
        medico_responsable: json['medico_responsable'] ?? '',
        observacion_medica: json['observacion_medica'] ?? '',
        centro_medico: json['centro_medico'] ?? '',
        fecha_ini: json['fecha_ini'] ?? '',
        fecha_fin: json['fecha_fin'] ?? '',

      );


  Map<String, dynamic> toJson() => {
    'exa_grupo_examen_medico_id': id,
    'codigo':  codigo,
    'nombre':  nombre,

    'tipo_evaluacion_nombre':  tipo_evaluacion_nombre,
    'aptitud_nombre':  aptitud_nombre,
    'medico_responsable':  medico_responsable,
    'observacion_medica':  observacion_medica,
    'centro_medico':  centro_medico,
    'fecha_ini':  fecha_ini,
    'fecha_fin':  fecha_fin,



  };

  MedicoEmpleadoModel copyWith({
    int? id,
    String? codigo,
    String? nombre,

    String? tipo_evaluacion_nombre,
    String? aptitud_nombre,
    String? medico_responsable,
    String? observacion_medica,
    String? centro_medico,
    String? fecha_ini,
    String? fecha_fin


  }) =>

      MedicoEmpleadoModel(
        id: id ?? this.id,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,

        tipo_evaluacion_nombre : tipo_evaluacion_nombre ?? this.tipo_evaluacion_nombre,
        aptitud_nombre: aptitud_nombre ?? this.aptitud_nombre,
        medico_responsable: medico_responsable ?? this.medico_responsable,
        observacion_medica: observacion_medica ?? this.observacion_medica,
        centro_medico: centro_medico ?? this.centro_medico,

        fecha_ini: fecha_ini ?? this.fecha_ini,
        fecha_fin: fecha_fin ?? this.fecha_fin,
      );

}