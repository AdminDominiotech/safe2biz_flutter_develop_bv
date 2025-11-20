import 'dart:convert';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/indice_severidad.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/frecuencia_mti.dart';

List<frecuencia_mti_model> employeeFromJson(String str) =>
    List<frecuencia_mti_model>.from(json.decode(str).map((x) => frecuencia_mti_model.fromJson(x)));

String employeeToJson(List<frecuencia_mti_model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class frecuencia_mti_model extends frecuencia_mti {


  frecuencia_mti_model({

    required int anho,
    required String nombre,
    required double indicador,


  }) : super(

    anho : anho,
    nombre: nombre,
    indicador: indicador,

  );


  factory frecuencia_mti_model.fromJson(json) =>
      frecuencia_mti_model(
        anho: json['anho'] ?? 0,
        nombre: json['nombre'] ?? '',
        indicador: json['indicador'] ?? 0.0,

      );

  Map<String, dynamic> toJson() => {

    'anho': anho,
    'nombre': nombre,
    'indicador': indicador,

  };

  frecuencia_mti_model copyWith({
    int? anho,
    String? nombre,
    double? indicador
  }) =>

      frecuencia_mti_model(
        anho: anho ?? this.anho,
        nombre: nombre ?? this.nombre,
        indicador: indicador ?? this.indicador,

      );

}