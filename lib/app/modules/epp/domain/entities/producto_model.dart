import 'dart:convert';

import 'package:safe2biz/app/modules/epp/domain/entities/producto.dart';


List<ProductoModel> productFromJson(String str) =>
    List<ProductoModel>.from(json.decode(str).map((x) => ProductoModel.fromJson(x)));

String productToJson(List<ProductoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductoModel extends Producto {


  ProductoModel({

    required int epp_producto_id,
    required int epp_equipo_id,
    required String equipo_nombre,
    required String equipo_descripcion,
    required String tipo_equipo_nombre,
    required String codigo,
    required String nombre_proveedor,
    required String marca,
    required String modelo,
    required String foto_prod,
    required String observacion,

    required String tipo_equipo_codigo,
    required String equipo_codigo,
    required double costo,

    required int tiempo_recambio,



  }) : super(

    epp_producto_id : epp_producto_id,
    epp_equipo_id: epp_equipo_id,
    equipo_nombre: equipo_nombre,
    equipo_descripcion: equipo_descripcion,
    tipo_equipo_nombre: tipo_equipo_nombre,
    codigo: codigo,
    nombre_proveedor:nombre_proveedor,
      marca:marca,
    modelo:modelo,
      foto_prod:foto_prod,
      observacion:observacion,

      tipo_equipo_codigo:tipo_equipo_codigo,
      equipo_codigo:equipo_codigo,
      costo:costo,

      tiempo_recambio:tiempo_recambio,



  );


  factory ProductoModel.fromJson(json) =>
      ProductoModel(
        epp_producto_id: json['epp_producto_id'] ?? 0,
        epp_equipo_id: json['epp_equipo_id'] ?? 0,
        equipo_nombre: json['equipo_nombre'] ?? '',
        equipo_descripcion: json['equipo_descripcion'] ?? '',
        tipo_equipo_nombre: json['tipo_equipo_nombre'] ?? '',
        codigo: json['codigo'] ?? '',
        nombre_proveedor: json['nombre_proveedor'] ?? '',
        marca: json['marca'] ?? '',
        modelo: json['modelo'] ?? '',
        foto_prod:json['foto_prod'] ?? '',
        observacion: json['observacion'] ?? '',
        tipo_equipo_codigo:json['tipo_equipo_codigo'] ?? '',
        equipo_codigo: json['equipo_codigo'] ?? '',
        costo:json['costo'] ?? 0.0,
        tiempo_recambio:json['tiempo_recambio'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'epp_producto_id': epp_producto_id,
    'epp_equipo_id':  epp_equipo_id,
    'equipo_nombre': equipo_nombre,
    'equipo_descripcion': equipo_descripcion,
    'tipo_equipo_nombre': tipo_equipo_nombre,
    'codigo': codigo,
    'nombre_proveedor':  nombre_proveedor,
    'marca':  marca,
    'modelo': modelo,
    'foto_prod' : foto_prod,
    'observacion' : observacion,

    'tipo_equipo_codigo' :tipo_equipo_codigo,
    'equipo_codigo' : equipo_codigo,
    'costo' : costo,

    'tiempo_recambio':tiempo_recambio,

  };

  ProductoModel copyWith({
    int? epp_producto_id,
    int? epp_equipo_id,
    String? equipo_nombre,
    String? equipo_descripcion,
    String? tipo_equipo_nombre,
    String? codigo,
    String? nombre_proveedor,
    String? marca,
    String? modelo,
    String? observacion,

    String? foto_prod,

    String? tipo_equipo_codigo,
    String? equipo_codigo,
    double? costo,

    int? tiempo_recambio,

  }) =>

      ProductoModel(
        epp_producto_id: epp_producto_id ?? this.epp_producto_id,
        epp_equipo_id: epp_equipo_id ?? this.epp_equipo_id,
        equipo_nombre: equipo_nombre ?? this.equipo_nombre,
        equipo_descripcion: equipo_descripcion ?? this.equipo_descripcion,
        tipo_equipo_nombre: tipo_equipo_nombre ?? this.tipo_equipo_nombre,
        codigo: codigo ?? this.codigo,
        nombre_proveedor: nombre_proveedor ?? this.nombre_proveedor,
        marca:marca ?? this.marca,
        modelo:modelo ??this.modelo,
        foto_prod: foto_prod ?? this.foto_prod,
        observacion:observacion ?? this.observacion,


        tipo_equipo_codigo : tipo_equipo_codigo??this.tipo_equipo_codigo,
        equipo_codigo:equipo_codigo??this.equipo_codigo,
        costo:costo??this.costo,
        tiempo_recambio:tiempo_recambio??this.tiempo_recambio,
      );





}