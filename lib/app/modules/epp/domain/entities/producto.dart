

import 'package:equatable/equatable.dart';


abstract class Producto extends Equatable {
  Producto({
    required this.epp_producto_id,
    required this.epp_equipo_id,
    required this.equipo_nombre,
    required this.equipo_descripcion,
    required this.tipo_equipo_nombre,
    required this.codigo,
    required this.nombre_proveedor,
    required this.marca,
    required this.modelo,
    required this.foto_prod,
    required this.observacion,

    required this.tipo_equipo_codigo,
    required this.equipo_codigo,
    required this.costo,
    required this.tiempo_recambio,


  });



  /// ayc_registro_id
  int epp_producto_id;
  int epp_equipo_id;
  String equipo_nombre;
  String equipo_descripcion;
  String tipo_equipo_nombre;
  String codigo;
  String nombre_proveedor;
  String marca;
  String modelo;
  String foto_prod;
  String observacion;

  String tipo_equipo_codigo;
  String equipo_codigo;
  double costo;

  int tiempo_recambio;




  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [
    epp_producto_id,
    epp_equipo_id,
    equipo_nombre,
    equipo_descripcion,
    tipo_equipo_nombre,
    codigo,
    nombre_proveedor,
    observacion,
    marca,
    modelo,
    foto_prod,
    tipo_equipo_codigo,
    equipo_codigo,
    costo,
    tiempo_recambio,

  ];
}


