import 'dart:convert';


import 'package:safe2biz/app/modules/actos_condiciones/data/models/bsaf.dart';
import 'package:safe2biz/app/modules/epp/domain/entities/listaEntregaEpp.dart';


List<BsafModel> BsafModelFromJson(String str) =>
    List<BsafModel>.from(json.decode(str).map((x) => BsafModel.fromJson(x)));

String BsafModelToJson(List<BsafModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BsafModel extends Bsaf {

  BsafModel({
    required String inc_bsaf_id,
    required String nombre
  }) : super(
    inc_bsaf_id : inc_bsaf_id,
    nombre: nombre,
  );


  factory BsafModel.fromJson(json) =>
      BsafModel(
        inc_bsaf_id: json['inc_bsaf_id'] ?? '',
        nombre: json['nombre'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'inc_bsaf_id': inc_bsaf_id,
    'nombre':  nombre,
  };

  BsafModel copyWith({
    String? inc_bsaf_id,
    String? nombre,

  }) =>

      BsafModel(
        inc_bsaf_id: inc_bsaf_id ?? this.inc_bsaf_id,
        nombre: nombre ?? this.nombre,

      );


}