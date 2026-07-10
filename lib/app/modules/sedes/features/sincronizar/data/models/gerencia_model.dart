import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';

class GerenciaModel extends Gerencia {
  GerenciaModel({
    required String id,
    required String fbUeaPeId,
    required String codigo,
    required String nombre,
  }) : super(
          id: id,
          fbUeaPeId: fbUeaPeId,
          codigo: codigo,
          nombre: nombre,
        );

  factory GerenciaModel.fromJson(Map<String, dynamic> json) => GerenciaModel(
        id: json['fb_gerencia_id'] != null
            ? json['fb_gerencia_id'].toString()
            : '',
        fbUeaPeId:
            json['fb_uea_pe_id'] != null ? json['fb_uea_pe_id'].toString() : '',
        codigo: json['codigo'] ?? '',
        nombre: json['nombre'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'fb_gerencia_id': id,
    'fb_uea_pe_id': fbUeaPeId, // ✅ igual que el API/DB
    'codigo': codigo,
    'nombre': nombre,
  };

  Gerencia copyWith({
    String? id,
    String? fbUeaPeId,
    String? codigo,
    String? nombre,
  }) =>
      GerenciaModel(
        id: id ?? this.id,
        fbUeaPeId: fbUeaPeId ?? this.fbUeaPeId,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
      );
}
