import 'dart:convert';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/inc_mensuales_tipo.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/indice_frecuencia.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/indice_severidad.dart';

List<indice_frecuencia_model> employeeFromJson(String str) =>
    List<indice_frecuencia_model>.from(json.decode(str).map((x) => indice_frecuencia_model.fromJson(x)));

String employeeToJson(List<indice_frecuencia_model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class indice_frecuencia_model extends indice_frecuencia {


  indice_frecuencia_model({

    required int mes,
    required String rol,
    required int accidentes,

  }) : super(

    mes : mes,
    rol: rol,
    accidentes: accidentes,

  );


  factory indice_frecuencia_model.fromJson(json) =>
      indice_frecuencia_model(
        mes: json['mes'] ?? 0,
        rol: json['rol'] ?? '',
        accidentes: json['accidentes'] ?? 0,

      );

  Map<String, dynamic> toJson() => {

    'mes': mes,
    'rol': rol,
    'accidentes': accidentes,

  };

  indice_frecuencia_model copyWith({
    int? mes,
    String? rol,
    int? accidentes
  }) =>

      indice_frecuencia_model(
        mes: mes ?? this.mes,
        rol: rol ?? this.rol,
        accidentes: accidentes ?? this.accidentes,

      );
}