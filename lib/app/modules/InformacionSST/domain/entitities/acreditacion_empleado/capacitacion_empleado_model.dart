
import 'dart:convert';

import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/MiInformacion/g_medico_empleado.dart';
import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/acreditacion_empleado/capacitacion_empleado.dart';

List<CapacitacionEmpleadoModel> EstadoCursoFromJson(String str) =>
    List<CapacitacionEmpleadoModel>.from(json.decode(str).map((x) => CapacitacionEmpleadoModel.fromJson(x)));

String EstadoCursoToJson(List<CapacitacionEmpleadoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CapacitacionEmpleadoModel extends CapacitacionEmpleado {

  CapacitacionEmpleadoModel({

    required int fb_empleado_id,
    required String capacitacion,
    required int flag_aptitud,




  }) : super(

      fb_empleado_id: fb_empleado_id,
    capacitacion: capacitacion,
    flag_aptitud:flag_aptitud,

  );


  factory CapacitacionEmpleadoModel.fromJson(json) =>
      CapacitacionEmpleadoModel(

        fb_empleado_id: json['fb_empleado_id'] ?? 0,
        capacitacion: json['capacitacion'] ?? '',
        flag_aptitud: json['flag_aptitud'] ?? 0,

      );


  Map<String, dynamic> toJson() => {

    'fb_empleado_id':  fb_empleado_id,
    'capacitacion':  capacitacion,
    'flag_aptitud':  flag_aptitud,



  };

  CapacitacionEmpleadoModel copyWith({
    int? fb_empleado_id,
    String? codigo,
    int? flag_aptitud,


  }) =>

      CapacitacionEmpleadoModel(
        fb_empleado_id: fb_empleado_id ?? this.fb_empleado_id,
        capacitacion: codigo ?? this.capacitacion,
        flag_aptitud: flag_aptitud ?? this.flag_aptitud,



      );

}