import 'dart:convert';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/inc_mensuales_tipo.dart';

List<inc_mensuales_tipo_model> employeeFromJson(String str) =>
    List<inc_mensuales_tipo_model>.from(json.decode(str).map((x) => inc_mensuales_tipo_model.fromJson(x)));

String employeeToJson(List<inc_mensuales_tipo_model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class inc_mensuales_tipo_model extends inc_mensuales_tipo {


  inc_mensuales_tipo_model({

    required String TipoIncidente,
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

    TipoIncidente : TipoIncidente,
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


  factory inc_mensuales_tipo_model.fromJson(json) =>
      inc_mensuales_tipo_model(
        TipoIncidente: json['TipoIncidente'] ?? '',
        ene: json['ene'] ?? 0,
        feb: json['feb'] ?? 0,
        mar: json['mar'] ?? 0,
        abr: json['abr'] ?? 0,
        may: json['may'] ?? 0,
        jun: json['jun'] ?? 0,
        jul: json['jul'] ?? 0,
        ago: json['ago'] ?? 0,
        set: json['set'] ?? 0,
        oct: json['oct'] ?? 0,
        nov: json['nov'] ?? 0,
        dic: json['dic'] ?? 0,
      );


  Map<String, dynamic> toJson() => {
    'TipoIncidente': TipoIncidente,
    'ene': ene,
    'feb': feb,
    'mar': mar,
    'abr': abr,
    'may': may,
    'jun': jun,
    'jul': jul,
    'ago' :ago,
    'set':set,
    'oct':oct,
    'nov':nov,
    'dic':dic,



  };

  inc_mensuales_tipo_model copyWith({
     String? TipoIncidente,
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

      inc_mensuales_tipo_model(
          TipoIncidente: TipoIncidente ?? this.TipoIncidente,
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