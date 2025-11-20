import 'dart:convert';


import 'package:safe2biz/app/modules/epp/domain/entities/listaEntregaEpp.dart';


List<ListaEntregaEppModel> ListaEntregaEppFromJson(String str) =>
    List<ListaEntregaEppModel>.from(json.decode(str).map((x) => ListaEntregaEppModel.fromJson(x)));

String ListaEntregaEppToJson(List<ListaEntregaEppModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListaEntregaEppModel extends ListaEntregaEpp {


  ListaEntregaEppModel({

    required int epp_entrega_id,
    required int fb_empleado_id


  }) : super(

    epp_entrega_id : epp_entrega_id,
    fb_empleado_id: fb_empleado_id,

  );


  factory ListaEntregaEppModel.fromJson(json) =>
      ListaEntregaEppModel(
        epp_entrega_id: json['epp_entrega_id'] ?? 0,
        fb_empleado_id: json['fb_empleado_id'] ?? 0,

      );


  Map<String, dynamic> toJson() => {
    'epp_entrega_id': epp_entrega_id,
    'fb_empleado_id':  fb_empleado_id,


  };

  ListaEntregaEppModel copyWith({
    int? epp_entrega_id,
    int? fb_empleado_id,

  }) =>

      ListaEntregaEppModel(
        epp_entrega_id: epp_entrega_id ?? this.epp_entrega_id,
        fb_empleado_id: fb_empleado_id ?? this.fb_empleado_id,

      );


}