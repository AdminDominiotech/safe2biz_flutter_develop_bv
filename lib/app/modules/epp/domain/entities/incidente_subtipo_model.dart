import 'dart:convert';

import 'package:safe2biz/app/modules/epp/domain/entities/incidente_subtipo.dart';






List<IncidenteSubtipo> IncidenteSubtipoFromJson(String str) =>
    List<IncidenteSubtipo>.from(json.decode(str).map((x) => IncidenteSubtipoModel.fromJson(x)));

String IncidenteSubtipoToJson(List<IncidenteSubtipoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IncidenteSubtipoModel extends IncidenteSubtipo {


  IncidenteSubtipoModel({

    required String nombre,
    required int cantidad


  }) : super(

    nombre : nombre,
    cantidad: cantidad,


  );


  factory IncidenteSubtipoModel.fromJson(json) =>
      IncidenteSubtipoModel(
        nombre: json['nombre'] ?? '',
        cantidad: json['cantidad'] ?? 0,

      );


  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'cantidad':  cantidad,


  };

  IncidenteSubtipoModel copyWith({
    String? nombre,
    int? cantidad,

  }) =>

      IncidenteSubtipoModel(
        nombre: nombre ?? this.nombre,
        cantidad: cantidad ?? this.cantidad,

      );





}