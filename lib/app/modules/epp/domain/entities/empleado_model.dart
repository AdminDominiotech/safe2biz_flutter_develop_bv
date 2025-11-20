import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safe2biz/app/modules/epp/domain/entities/empleado.dart';

List<EmpleadoModel> employeeFromJson(String str) =>
    List<EmpleadoModel>.from(json.decode(str).map((x) => EmpleadoModel.fromJson(x)));

String employeeToJson(List<EmpleadoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmpleadoModel extends Empleado {


  EmpleadoModel({

    required int fb_empleado_id,
    required int fb_uea_pe_id,
    required String nombreCompleto,
    required String numero_documento,
    required String cargo_nombre,
    required String gerencia_nombre,
    required String area_nombre,
    required String empresa,

    required String cargo_codigo,
    required String area_codigo,
    required int fb_area_id,
    required int fb_cargo_id,
    required int fb_puesto_trabajo_id,
    required String puesto_trabajo_codigo,
    required String puesto_trabajo_nombre,
    required String nombre_rol,
    required String codigo_rol,
    required int epp_rol_epp_id,
    required String fb_empresa_especializada,
    required String foto,



  }) : super(

      fb_empleado_id : fb_empleado_id,
      fb_uea_pe_id: fb_uea_pe_id,
      nombreCompleto: nombreCompleto,
      numero_documento: numero_documento,
      cargo_nombre: cargo_nombre,
      gerencia_nombre: gerencia_nombre,
      area_nombre:area_nombre,
      empresa:empresa,

      cargo_codigo:cargo_codigo,
      area_codigo:area_codigo,
      fb_area_id:fb_area_id,
      fb_cargo_id:fb_cargo_id,
      fb_puesto_trabajo_id:fb_puesto_trabajo_id,
      puesto_trabajo_codigo:puesto_trabajo_codigo,
      puesto_trabajo_nombre:puesto_trabajo_nombre,
      nombre_rol:nombre_rol,
      codigo_rol:codigo_rol,
      epp_rol_epp_id:epp_rol_epp_id,
      fb_empresa_especializada: fb_empresa_especializada,
    foto:foto
  );


  factory EmpleadoModel.fromJson(json) =>
      EmpleadoModel(
        fb_empleado_id: json['fb_empleado_id'] ?? 0,
        fb_uea_pe_id: json['fb_uea_pe_id'] ?? 0,
        nombreCompleto: json['nombreCompleto'] ?? '',
        numero_documento: json['numero_documento'] ?? '',
        gerencia_nombre: json['gerencia_nombre'] ?? '',
        cargo_nombre: json['cargo_nombre'] ?? '',
        area_nombre: json['area_nombre'] ?? '',
        empresa: json['empresa'] ?? '',

          cargo_codigo: json['cargo_codigo']?? '',
          area_codigo :json['area_codigo']?? 0,
          fb_area_id:json['fb_area_id']?? 0,
          fb_cargo_id:json['fb_cargo_id']?? 0,
          fb_puesto_trabajo_id  :json['fb_puesto_trabajo_id']??0,
          puesto_trabajo_codigo :json['puesto_trabajo_codigo']?? '',
          puesto_trabajo_nombre:json['puesto_trabajo_nombre']?? '',
          nombre_rol: json['nombre_rol'] ?? '',
          codigo_rol: json['codigo_rol'] ?? '',
          epp_rol_epp_id:json['epp_rol_epp_id']?? 0,
        fb_empresa_especializada:json['fb_empresa_especializada']?? '',
          foto:json['foto'] ?? '',


      );




  Map<String, dynamic> toJson() => {
    'fb_empleado_id': fb_empleado_id,
    'fb_uea_pe_id':  fb_uea_pe_id,
    'nombreCompleto': nombreCompleto,
    'numero_documento': numero_documento,
    'cargo_nombre': cargo_nombre,
    'gerencia_nombre': gerencia_nombre,
    'area_nombre': area_nombre,
    'empresa': empresa,
    'cargo_codigo' : cargo_codigo,
    'area_codigo':area_codigo,
    'fb_area_id':fb_area_id,
    'fb_cargo_id':fb_cargo_id,
    'fb_puesto_trabajo_id':fb_puesto_trabajo_id,
    'puesto_trabajo_codigo':puesto_trabajo_codigo,
    'puesto_trabajo_nombre':puesto_trabajo_nombre,
    'nombre_rol':nombre_rol,
    'codigo_rol':codigo_rol,
    'epp_rol_epp_id': epp_rol_epp_id,
    'fb_empresa_especializada': fb_empresa_especializada,
    'foto':foto




  };

  EmpleadoModel copyWith({
    int? fb_empleado_id,
    int? fb_uea_pe_id,
    String? nombreCompleto,
    String? numero_documento,
    String? cargo_nombre,
    String? gerencia_nombre,
    String? area_nombre,
    String? empresa,


     String? cargo_codigo,
     String? area_codigo,
     int? fb_area_id,
     int? fb_cargo_id,
     int? fb_puesto_trabajo_id,
     String? puesto_trabajo_codigo,
     String? puesto_trabajo_nombre,
    String? nombre_rol,
    String? codigo_rol,
    int? epp_rol_epp_id,
    String? fb_empresa_especializada,
    String? foto,


  }) =>

      EmpleadoModel(
        fb_empleado_id: fb_empleado_id ?? this.fb_empleado_id,
        fb_uea_pe_id: fb_uea_pe_id ?? this.fb_uea_pe_id,
        nombreCompleto: nombreCompleto ?? this.nombreCompleto,
        numero_documento: numero_documento ?? this.numero_documento,
        cargo_nombre: cargo_nombre ?? this.cargo_nombre,
        gerencia_nombre: gerencia_nombre ?? this.gerencia_nombre,
        area_nombre: area_nombre ?? this.area_nombre,
        empresa:empresa ?? this.empresa,
          cargo_codigo:cargo_codigo??this.cargo_codigo,
          area_codigo:area_codigo??this.area_codigo,
          fb_area_id:fb_area_id??this.fb_area_id,
          fb_cargo_id:fb_cargo_id??this.fb_cargo_id,
          fb_puesto_trabajo_id:fb_puesto_trabajo_id??this.fb_puesto_trabajo_id,
          puesto_trabajo_codigo:puesto_trabajo_codigo??this.puesto_trabajo_codigo,
          puesto_trabajo_nombre:puesto_trabajo_nombre??this.puesto_trabajo_nombre,
          nombre_rol:nombre_rol??this.nombre_rol,
          codigo_rol:codigo_rol??this.codigo_rol,
          epp_rol_epp_id:epp_rol_epp_id??this.epp_rol_epp_id,
          fb_empresa_especializada:fb_empresa_especializada??this.fb_empresa_especializada,
           foto:foto??this.foto
      );

}