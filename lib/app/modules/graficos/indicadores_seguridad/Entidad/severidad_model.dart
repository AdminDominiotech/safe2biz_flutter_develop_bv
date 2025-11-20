import 'dart:convert';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/indice_severidad.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/frecuencia_mti.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/severidad.dart';

List<severidad_model> employeeFromJson(String str) =>
    List<severidad_model>.from(json.decode(str).map((x) => severidad_model.fromJson(x)));

String employeeToJson(List<severidad_model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class severidad_model extends severidad {


  severidad_model({

    required int anho,
    required String nombre,
    required double indicador,


  }) : super(

    anho : anho,
    nombre: nombre,
    indicador: indicador,

  );


  factory severidad_model.fromJson(json) =>
      severidad_model(
        anho: json['anho'] ?? 0,
        nombre: json['nombre'] ?? '',
        indicador: json['indicador'] ?? 0.0,

      );

  Map<String, dynamic> toJson() => {

    'anho': anho,
    'nombre': nombre,
    'indicador': indicador,

  };

  severidad_model copyWith({
    int? anho,
    String? nombre,
    double? indicador
  }) =>

      severidad_model(
        anho: anho ?? this.anho,
        nombre: nombre ?? this.nombre,
        indicador: indicador ?? this.indicador,

      );

}