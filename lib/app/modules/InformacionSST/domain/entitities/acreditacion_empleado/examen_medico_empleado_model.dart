
import 'dart:convert';

import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/acreditacion_empleado/examen_medico_empleado.dart';

List<ExamenMedicoEmpleadoModel> EstadoCursoFromJson(String str) =>
    List<ExamenMedicoEmpleadoModel>.from(json.decode(str).map((x) => ExamenMedicoEmpleadoModel.fromJson(x)));

String EstadoCursoToJson(List<ExamenMedicoEmpleadoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExamenMedicoEmpleadoModel extends ExamenMedicoEmpleado {

  ExamenMedicoEmpleadoModel({

    required int fb_empleado_id,
    required String examen_medico,
    required int flag_aptitud,




  }) : super(

    fb_empleado_id: fb_empleado_id,
    examen_medico: examen_medico,
    flag_aptitud:flag_aptitud,

  );


  factory ExamenMedicoEmpleadoModel.fromJson(json) =>
      ExamenMedicoEmpleadoModel(

        fb_empleado_id: json['fb_empleado_id'] ?? 0,
        examen_medico: json['examen_medico'] ?? '',
        flag_aptitud: json['flag_aptitud'] ?? 0,

      );


  Map<String, dynamic> toJson() => {

    'fb_empleado_id':  fb_empleado_id,
    'examen_medico':  examen_medico,
    'flag_aptitud':  flag_aptitud,

  };

  ExamenMedicoEmpleadoModel copyWith({
    int? fb_empleado_id,
    String? examen_medico,
    int? flag_aptitud,


  }) =>

      ExamenMedicoEmpleadoModel(
        fb_empleado_id: fb_empleado_id ?? this.fb_empleado_id,
        examen_medico: examen_medico ?? this.examen_medico,
        flag_aptitud: flag_aptitud ?? this.flag_aptitud,



      );

}