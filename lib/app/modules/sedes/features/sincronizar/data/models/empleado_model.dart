// ignore_for_file: must_be_immutable

import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';

class EmpleadoModel extends Empleado {
  EmpleadoModel({
    required String id,
    required String fbUeaPeId,
    required String nombreCompleto,
    required String numeroDocumento,
    required String cargoNombre,
    required String gerenciaNombre,
    required String empresa,
  }) : super(
          id: id,
          fbUeaPeId: fbUeaPeId,
          nombreCompleto: nombreCompleto,
          numeroDocumento: numeroDocumento,
          cargoNombre: cargoNombre,
          gerenciaNombre: gerenciaNombre,
          empresa: empresa,
        );

  factory EmpleadoModel.fromJson(Map<String, dynamic> json) => EmpleadoModel(
        id: json['fb_empleado_id'] != null
            ? json['fb_empleado_id'].toString()
            : '',
        fbUeaPeId:
            json['fb_uea_pe_id'] != null ? json['fb_uea_pe_id'].toString() : '',
        nombreCompleto: json['nombreCompleto'] ?? '',
        numeroDocumento: json['numero_documento'] ?? '',
        cargoNombre: json['cargo_nombre'] ?? '',
        gerenciaNombre: json['gerencia_nombre'] ?? '',
        empresa: json['empresa'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'fb_empleado_id': id,
        'numero_documento': numeroDocumento,
        'nombreCompleto': nombreCompleto,
        'fb_uea_pe_id': fbUeaPeId,
        'cargo_nombre': cargoNombre,
        'gerencia_nombre': gerenciaNombre,
        'empresa': empresa,
      };

  Empleado copyWith({
    String? id,
    String? fbUeaPeId,
    String? nombreCompleto,
    String? numeroDocumento,
    String? cargoNombre,
    String? gerenciaNombre,
    String? empresa,
  }) =>
      EmpleadoModel(
        id: id ?? this.id,
        fbUeaPeId: fbUeaPeId ?? this.fbUeaPeId,
        nombreCompleto: nombreCompleto ?? this.nombreCompleto,
        numeroDocumento: numeroDocumento ?? this.numeroDocumento,
        cargoNombre: cargoNombre ?? this.cargoNombre,
        gerenciaNombre: gerenciaNombre ?? this.gerenciaNombre,
        empresa: empresa ?? this.empresa,
      );
}
