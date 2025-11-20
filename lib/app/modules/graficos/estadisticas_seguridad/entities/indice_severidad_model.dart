import 'dart:convert';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/indice_severidad.dart';

List<indice_severidad_model> employeeFromJson(String str) =>
    List<indice_severidad_model>.from(json.decode(str).map((x) => indice_severidad_model.fromJson(x)));

String employeeToJson(List<indice_severidad_model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class indice_severidad_model extends indice_severidad {


  indice_severidad_model({

    required int mes,
    required String rol,
    required int dias_per,


  }) : super(

    mes : mes,
    rol: rol,
    dias_per: dias_per,

  );


  factory indice_severidad_model.fromJson(json) =>
      indice_severidad_model(
        mes: json['mes'] ?? 0,
        rol: json['rol'] ?? '',
        dias_per: json['dias_per'] ?? 0,

      );

  Map<String, dynamic> toJson() => {

    'mes': mes,
    'rol': rol,
    'dias_per': dias_per,

  };

  indice_severidad_model copyWith({
    int? mes,
    String? rol,
    int? dias_per
  }) =>

      indice_severidad_model(
        mes: mes ?? this.mes,
        rol: rol ?? this.rol,
        dias_per: dias_per ?? this.dias_per,

      );

}