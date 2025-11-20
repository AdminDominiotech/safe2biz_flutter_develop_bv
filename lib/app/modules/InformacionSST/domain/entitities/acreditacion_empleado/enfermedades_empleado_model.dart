
import 'dart:convert';

import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/acreditacion_empleado/enfermedades_empleado.dart';
import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/acreditacion_empleado/examen_medico_empleado.dart';

List<EnfermedadesEmpleadoModel> EstadoCursoFromJson(String str) =>
    List<EnfermedadesEmpleadoModel>.from(json.decode(str).map((x) => EnfermedadesEmpleadoModel.fromJson(x)));

String EstadoCursoToJson(List<EnfermedadesEmpleadoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EnfermedadesEmpleadoModel extends EnfermedadesEmpleado {

  EnfermedadesEmpleadoModel({

    required int fb_empleado_id,
    required String enfermedad,





  }) : super(

    fb_empleado_id: fb_empleado_id,
    enfermedad: enfermedad,


  );


  factory EnfermedadesEmpleadoModel.fromJson(json) =>

      EnfermedadesEmpleadoModel(
        fb_empleado_id: json['fb_empleado_id'] ?? '',
        enfermedad: json['enfermedad'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'fb_empleado_id':  fb_empleado_id,
    'enfermedad':  enfermedad,
  };

  EnfermedadesEmpleadoModel copyWith({
    int? fb_empleado_id,
    String? enfermedad,



  }) =>

      EnfermedadesEmpleadoModel(
        fb_empleado_id: fb_empleado_id ?? this.fb_empleado_id,
        enfermedad: enfermedad ?? this.enfermedad,




      );

}