import 'dart:convert';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/ayc_nivel_riesgo.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/inc_mensuales_tipo.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/incidentes_seguridad.dart';

List<incidentes_seguridad_model> employeeFromJson(String str) =>
    List<incidentes_seguridad_model>.from(json.decode(str).map((x) => incidentes_seguridad_model.fromJson(x)));

String employeeToJson(List<incidentes_seguridad_model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class incidentes_seguridad_model extends incidentes_seguridad {


  incidentes_seguridad_model({

   // required String accidente,
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

   //   accidente : accidente,
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


  factory incidentes_seguridad_model.fromJson(json) =>
      incidentes_seguridad_model(
    //    accidente: json['Accidente'] ?? '',
        ene: json['Enero'] ?? 0,
        feb: json['Febrero'] ?? 0,
        mar: json['Marzo'] ?? 0,
        abr: json['Abril'] ?? 0,
        may: json['Mayo'] ?? 0,
        jun: json['Junio'] ?? 0,
        jul: json['Julio'] ?? 0,
        ago: json['Agosto'] ?? 0,
        set: json['Septiembre'] ?? 0,
        oct: json['Octubre'] ?? 0,
        nov: json['Noviembre'] ?? 0,
        dic: json['Diciembre'] ?? 0,
      );


  Map<String, dynamic> toJson() => {
   // 'Accidente': accidente,
    'Enero': ene,
    'Febrero': feb,
    'Marzo': mar,
    'Abril': abr,
    'Mayo': may,
    'Junio': jun,
    'Julio': jul,
    'Agosto' :ago,
    'Septiembre':set,
    'Octubre':oct,
    'Noviembre':nov,
    'Diciembre':dic,



  };

  incidentes_seguridad_model copyWith({
  //  String? accidente,
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

      incidentes_seguridad_model(
       //   accidente: accidente ?? this.accidente,
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