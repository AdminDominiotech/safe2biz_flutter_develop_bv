
import 'dart:convert';

import 'package:safe2biz/app/modules/capacitacion/domain/entities/asistencia_check.dart';

List<AsistenciaCheckModel> EstadoCursoFromJson(String str) =>
    List<AsistenciaCheckModel>.from(json.decode(str).map((x) => AsistenciaCheckModel.fromJson(x)));

String EstadoCursoToJson(List<AsistenciaCheckModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AsistenciaCheckModel extends AsistenciaCheck {

  AsistenciaCheckModel({
    required int fb_empleado_id,

  }) : super(

    fb_empleado_id : fb_empleado_id,


  );


  factory AsistenciaCheckModel.fromJson(json) =>
      AsistenciaCheckModel(

        fb_empleado_id: json['fb_empleado_id'] ?? 0,

      );


  Map<String, dynamic> toJson() => {
    'fb_empleado_id':  fb_empleado_id,

  };

  AsistenciaCheckModel copyWith({

    int? fb_empleado_id,

  }) =>

      AsistenciaCheckModel(

        fb_empleado_id: fb_empleado_id ?? this.fb_empleado_id,

      );


}