import 'dart:convert';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/ayc_nivel_riesgo.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/inc_mensuales_tipo.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/plan_accion.dart';

List<plan_accion_model> employeeFromJson(String str) =>
    List<plan_accion_model>.from(json.decode(str).map((x) => plan_accion_model.fromJson(x)));

String employeeToJson(List<plan_accion_model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class plan_accion_model extends plan_accion {


  plan_accion_model({

    required String nombre,
    required  int ene,
    required  int feb,
    required  int mar,
    required  int abr,
    required  int may,
    required  int jun,
    required  int jul,
    required  int ago,
    required  int set,
    required  int oct,
    required  int nov,
    required  int dic,




  }) : super(

      nombre : nombre,
      ene: ene,
      feb: feb,
      mar: mar,
      abr: abr,
      may: may,
      jun:jun,
      jul:jul,
      ago:ago,
      set:set,
      oct:oct,
      nov:nov,
      dic:dic

  );


  factory plan_accion_model.fromJson(json) =>
      plan_accion_model(
        nombre: json['nombre'] ?? '',
        ene: json['ene'] ?? 0,
        feb: json['feb'] ?? 0,
        mar: json['mar'] ?? 0,
        abr: json['abr'] ?? 0,
        may: json['may'] ?? 0,
        jun: json['jun'] ?? 0,
        jul: json['jul'] ?? 0,
        ago: json['ago'] ?? 0,
        set: json['sep'] ?? 0,
        oct: json['oct'] ?? 0,
        nov: json['nov'] ?? 0,
        dic: json['dic'] ?? 0,
      );


  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'ene': ene,
    'feb': feb,
    'mar': mar,
    'abr': abr,
    'may': may,
    'jun': jun,
    'jul': jul,
    'ago' :ago,
    'sep':set,
    'oct':oct,
    'nov':nov,
    'dic':dic,



  };

  plan_accion_model copyWith({
    String? nombre,
    int? ene,
    int? feb,
    int? mar,
    int? abr,
    int? may,
    int? jun,
    int? jul,
    int? ago,
    int? set,
    int? oct,
    int? nov,
    int? dic,
  }) =>

      plan_accion_model(
          nombre: nombre ?? this.nombre,
          ene: ene ?? this.ene,
          feb: feb ?? this.feb,
          mar: mar ?? this.mar,
          abr: abr ?? this.abr,
          may: may ?? this.may,
          jun: jun ?? this.jun,
          jul:jul ?? this.jul,
          ago:ago??this.ago,
          set:set??this.set,
          oct:oct??this.oct,
          nov:nov??this.nov,
          dic:dic??this.dic
      );

}