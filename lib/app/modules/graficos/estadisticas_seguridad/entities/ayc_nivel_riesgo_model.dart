import 'dart:convert';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/ayc_nivel_riesgo.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/inc_mensuales_tipo.dart';

List<ayc_nivel_riesgo_model> employeeFromJson(String str) =>
    List<ayc_nivel_riesgo_model>.from(json.decode(str).map((x) => ayc_nivel_riesgo_model.fromJson(x)));

String employeeToJson(List<ayc_nivel_riesgo_model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ayc_nivel_riesgo_model extends ayc_nivel_riesgo {


  ayc_nivel_riesgo_model({

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


  factory ayc_nivel_riesgo_model.fromJson(json) =>
      ayc_nivel_riesgo_model(
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

  ayc_nivel_riesgo_model copyWith({
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

      ayc_nivel_riesgo_model(
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