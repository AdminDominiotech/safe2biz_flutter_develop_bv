// ignore_for_file: must_be_immutable

import 'package:safe2biz/app/modules/sedes/domain/entities/entities.dart';

class SedeModel extends Sede {
  SedeModel({
    required String id,
    required String name,
    required String code,
    required String userId,
    required String fb_uea_base_id
  }) : super(
          id: id,
          name: name,
          code: code,
          userId: userId,
          fb_uea_base_id:fb_uea_base_id
        );


  factory SedeModel.fromJson(Map<String, dynamic> json) => SedeModel(
        id: json['fb_uea_pe_id'] != null ? json['fb_uea_pe_id'].toString() : '',
        name: json['nombre'] ?? '',
        code: json['codigo'] ?? '',
        userId: json['sc_user_id'] != null ? json['sc_user_id'].toString() : '',
        fb_uea_base_id: json['fb_uea_base_id'] != null ? json['fb_uea_base_id'].toString() : '',
      );

  Map<String, dynamic> toJson() => {
        'fb_uea_pe_id': id,
        'codigo': code,
        'nombre': name,
        'sc_user_id': userId,
        'fb_uea_base_id' : fb_uea_base_id
      };

  Sede copyWith({
    String? id,
    String? name,
    String? code,
    String? userId,
    String? fb_uea_base_id,
  }) =>
      SedeModel(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
        userId: userId ?? this.userId,
          fb_uea_base_id : fb_uea_base_id ?? this.fb_uea_base_id
      );
}
