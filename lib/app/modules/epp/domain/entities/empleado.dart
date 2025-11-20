
import 'package:equatable/equatable.dart';

abstract class Empleado extends Equatable {
  Empleado({
    required this.fb_empleado_id,
    required this.fb_uea_pe_id,
    required this.nombreCompleto,
    required this.numero_documento,
    required this.cargo_nombre,
    required this.gerencia_nombre,
    required this.area_nombre,
    required this.empresa,

    required this.cargo_codigo,
    required this.area_codigo,
    required this.fb_area_id,
    required this.fb_cargo_id,
    required this.fb_puesto_trabajo_id,
    required this.puesto_trabajo_codigo,
    required this.puesto_trabajo_nombre,
    required this.nombre_rol,
    required this.codigo_rol,
    required this.epp_rol_epp_id,
    required this.fb_empresa_especializada,
    required this.foto



  });


  /// ayc_registro_id
  int fb_empleado_id;
  int fb_uea_pe_id;
  String nombreCompleto;
  String numero_documento;
  String cargo_nombre;
  String gerencia_nombre;
  String area_nombre;
  String empresa;
  String cargo_codigo;
  String area_codigo;
  int fb_area_id;
  int fb_cargo_id;
  int fb_puesto_trabajo_id;
  String puesto_trabajo_codigo;
  String puesto_trabajo_nombre;
  String nombre_rol;
  String codigo_rol;
  int epp_rol_epp_id;
  String fb_empresa_especializada;
  String foto;

  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [
    fb_empleado_id,
    fb_uea_pe_id,
    nombreCompleto,
    numero_documento,
    cargo_nombre,
    gerencia_nombre,
    area_nombre,
    empresa,

  cargo_codigo,
  area_codigo,
  fb_area_id,
  fb_cargo_id,
  fb_puesto_trabajo_id,
  puesto_trabajo_codigo,
  puesto_trabajo_nombre,
    nombre_rol,
  codigo_rol,
    epp_rol_epp_id,
    fb_empresa_especializada,
    foto

  ];


}




