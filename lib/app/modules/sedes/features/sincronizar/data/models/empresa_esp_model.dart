// ignore_for_file: must_be_immutable

import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';

class EmpresaEspModel extends EmpresaEsp {
  const EmpresaEspModel({
    required String id,
    required String razonSocial,
    required String rucEmpresa,
    required String gRolEmpresaId,
  }) : super(
          id: id,
          razonSocial: razonSocial,
          rucEmpresa: rucEmpresa,
          gRolEmpresaId: gRolEmpresaId,
        );

  factory EmpresaEspModel.fromJson(Map<String, dynamic> json) =>
      EmpresaEspModel(
        id: json['fb_empresa_especializada_id'] != null
            ? json['fb_empresa_especializada_id'].toString()
            : '',
        razonSocial: json['razon_social'] ?? '',
        rucEmpresa: json['ruc'] ?? '',
        gRolEmpresaId: json['g_rol_empresa_id'] != null
            ? json['g_rol_empresa_id'].toString()
            : '',
      );

  Map<String, dynamic> toJson() => {
        'fb_empresa_especializada_id': id,
        'razon_social': razonSocial,
        'ruc': rucEmpresa,
        'g_rol_empresa_id': gRolEmpresaId,
      };

  EmpresaEsp copyWith({
    String? id,
    String? razonSocial,
    String? rucEmpresa,
    String? gRolEmpresaId,
  }) =>
      EmpresaEspModel(
        id: id ?? this.id,
        razonSocial: razonSocial ?? this.razonSocial,
        rucEmpresa: rucEmpresa ?? this.rucEmpresa,
        gRolEmpresaId: gRolEmpresaId ?? this.gRolEmpresaId,
      );
}
