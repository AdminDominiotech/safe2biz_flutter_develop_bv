// ignore_for_file: must_be_immutable

import 'package:safe2biz/app/modules/sedes/domain/entities/entities.dart';

class SedeModel extends Sede {
  SedeModel({
    required String id,
    required String name,
    required String code,
    required String userId,
  }) : super(
          id: id,
          name: name,
          code: code,
          userId: userId,
        );

  factory SedeModel.fromJson(Map<String, dynamic> json) => SedeModel(
        id: json['fb_uea_pe_id'] != null ? json['fb_uea_pe_id'].toString() : '',
        name: json['nombre'] ?? '',
        code: json['codigo'] ?? '',
        userId: json['sc_user_id'] != null ? json['sc_user_id'].toString() : '',
      );

  Map<String, dynamic> toJson() => {
        'fb_uea_pe_id': id,
        'codigo': code,
        'nombre': name,
        'sc_user_id': userId,
      };

  Sede copyWith({
    String? id,
    String? name,
    String? code,
    String? userId,
  }) =>
      SedeModel(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
        userId: userId ?? this.userId,
      );
}
