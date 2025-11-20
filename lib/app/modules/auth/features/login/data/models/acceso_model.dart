// ignore: must_be_immutable
import 'dart:convert';

import 'package:safe2biz/app/modules/auth/features/login/domain/entities/entities.dart';
// List<AccesoModel> accesosFromJson(String str) => List<AccesoModel>.from(json.decode(str).map((x) => AccesoModel.fromJson(x)));

// ignore: must_be_immutable
class AccesoModel extends Acceso {
  AccesoModel({
    required String fbUeaPeId,
    required String codigo,
    required String modulos,
  }) : super(
          fbUeaPeId: fbUeaPeId,
          codigo: codigo,
          modulos: modulos,
        );

  factory AccesoModel.fromJson(Map<String, dynamic> json) => AccesoModel(
        fbUeaPeId: '${json['fb_uea_pe_id'] ?? ''}',
        codigo: json['codigo'] ?? '',
        modulos: json['modulos'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'fb_uea_pe_id': fbUeaPeId,
        'codigo': codigo,
        'modulos': modulos,
      };

  static List<AccesoModel> accesosFromJson(String str) {
    if (str.isEmpty) {
      return [];
    }
    return List<AccesoModel>.from(
      json.decode(str).map((x) => AccesoModel.fromJson(x)),
    );
  }

  static AccesoModel castEntity(Acceso acceso) => acceso as AccesoModel;

  AccesoModel copyWith({
    String? fbUeaPeId,
    String? codigo,
    String? modulos,
  }) =>
      AccesoModel(
        fbUeaPeId: fbUeaPeId ?? this.fbUeaPeId,
        codigo: codigo ?? this.codigo,
        modulos: modulos ?? this.modulos,
      );
}
