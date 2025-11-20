import 'dart:convert';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/indice_severidad.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/frecuencia_lti.dart';

List<frecuencia_lti_model> employeeFromJson(String str) =>
    List<frecuencia_lti_model>.from(json.decode(str).map((x) => frecuencia_lti_model.fromJson(x)));

String employeeToJson(List<frecuencia_lti_model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class frecuencia_lti_model extends frecuencia_lti {


  frecuencia_lti_model({

    required int anho,
    required String nombre,
    required double indicador,


  }) : super(

    anho : anho,
    nombre: nombre,
    indicador: indicador,

  );


  factory frecuencia_lti_model.fromJson(json) =>
      frecuencia_lti_model(
        anho: json['anho'] ?? 0,
        nombre: json['nombre'] ?? '',
        indicador: json['indicador'] ?? 0.0,

      );

  Map<String, dynamic> toJson() => {

    'anho': anho,
    'nombre': nombre,
    'indicador': indicador,

  };

  frecuencia_lti_model copyWith({
    int? anho,
    String? nombre,
    double? indicador
  }) =>

      frecuencia_lti_model(
        anho: anho ?? this.anho,
        nombre: nombre ?? this.nombre,
        indicador: indicador ?? this.indicador,

      );

}