import 'dart:convert';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/ayc_nivel_riesgo.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/inc_mensuales_tipo.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/horas_trabajadas_mes.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/incidentes_seguridad.dart';

List<horas_trabajadas_mes_model> employeeFromJson(String str) =>
    List<horas_trabajadas_mes_model>.from(json.decode(str).map((x) => horas_trabajadas_mes_model.fromJson(x)));

String employeeToJson(List<horas_trabajadas_mes_model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class horas_trabajadas_mes_model extends horas_trabajadas_mes {


  horas_trabajadas_mes_model({

    required String rol,
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

      rol : rol,
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


  factory horas_trabajadas_mes_model.fromJson(json) =>
      horas_trabajadas_mes_model(
        rol: json['rol'] ?? '',
        ene: json['Enero'] ?? 0,
        feb: json['Febrero'] ?? 0,
        mar: json['Marzo'] ?? 0,
        abr: json['Abril'] ?? 0,
        may: json['Mayo'] ?? 0,
        jun: json['Junio'] ?? 0,
        jul: json['Julio'] ?? 0,
        ago: json['Agosto'] ?? 0,
        set: json['Setiembre'] ?? 0,
        oct: json['Octubre'] ?? 0,
        nov: json['Noviembre'] ?? 0,
        dic: json['Diciembre'] ?? 0,
      );


  Map<String, dynamic> toJson() => {
    'rol': rol,
    'Enero': ene,
    'Febrero': feb,
    'Marzo': mar,
    'Abril': abr,
    'Mayo': may,
    'Junio': jun,
    'Julio': jul,
    'Agosto' :ago,
    'Setiembre':set,
    'Octubre':oct,
    'Noviembre':nov,
    'Diciembre':dic,



  };

  horas_trabajadas_mes_model copyWith({
    String? rol,
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

      horas_trabajadas_mes_model(
          rol: rol ?? this.rol,
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