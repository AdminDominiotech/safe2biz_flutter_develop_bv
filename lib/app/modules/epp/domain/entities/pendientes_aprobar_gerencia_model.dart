import 'dart:convert';

import 'package:safe2biz/app/modules/epp/domain/entities/pendientes_aprobar_gerencia.dart';






List<PendienteAprobarGerencia> pendienteFromJson(String str) =>
    List<PendienteAprobarGerencia>.from(json.decode(str).map((x) => PendienteAprobarGerenciaModel.fromJson(x)));

String pendienteToJson(List<PendienteAprobarGerenciaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PendienteAprobarGerenciaModel extends PendienteAprobarGerencia {


  PendienteAprobarGerenciaModel({

    required String gerencia,
    required int cantidad


  }) : super(

    gerencia : gerencia,
    cantidad: cantidad,


  );


  factory PendienteAprobarGerenciaModel.fromJson(json) =>
      PendienteAprobarGerenciaModel(
        gerencia: json['gerencia'] ?? '',
        cantidad: json['cantidad'] ?? 0,

      );


  Map<String, dynamic> toJson() => {
    'gerencia': gerencia,
    'cantidad':  cantidad,


  };

  PendienteAprobarGerenciaModel copyWith({
    String? gerencia,
    int? cantidad,

  }) =>

      PendienteAprobarGerenciaModel(
        gerencia: gerencia ?? this.gerencia,
        cantidad: cantidad ?? this.cantidad,

      );





}