import 'dart:convert';


import 'package:safe2biz/app/modules/capacitacion/domain/entities/estado_curso.dart';



List<EstadoCursoModel> EstadoCursoFromJson(String str) =>
    List<EstadoCursoModel>.from(json.decode(str).map((x) => EstadoCursoModel.fromJson(x)));

String EstadoCursoToJson(List<EstadoCursoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EstadoCursoModel extends EstadoCurso {

  EstadoCursoModel({
    required int id,
    required String nombre,
  }) : super(

    id : id,
    nombre: nombre,

  );


  factory EstadoCursoModel.fromJson(json) =>
      EstadoCursoModel(
        id: json['cap_curso_estado_id'] ?? 0,
        nombre: json['nombre'] ?? '',

      );


  Map<String, dynamic> toJson() => {
    'cap_curso_estado_id': id,
    'nombre':  nombre,


  };

  EstadoCursoModel copyWith({
    int? id,
    String? nombre,

  }) =>

      EstadoCursoModel(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,

      );


}