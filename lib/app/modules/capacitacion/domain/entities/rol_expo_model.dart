import 'dart:convert';

import 'package:safe2biz/app/modules/capacitacion/domain/entities/rol_expo.dart';



List<RolExpoModel> RolExpoFromJson(String str) =>
    List<RolExpoModel>.from(json.decode(str).map((x) => RolExpoModel.fromJson(x)));

String RolExpoToJson(List<RolExpoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RolExpoModel extends RolExpo {


  RolExpoModel({


    required int id,
    required String rol,


  }) : super(

    id : id,
    rol: rol,

  );


  factory RolExpoModel.fromJson(json) =>
      RolExpoModel(
        id: json['cap_rol_capacitacion_id'] ?? 0,
        rol: json['rol'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'rol':  rol,
  };

  RolExpoModel copyWith({
    int? id,
    String? rol,

  }) =>

      RolExpoModel(
        id: id ?? this.id,
        rol: rol ?? this.rol,

      );


}