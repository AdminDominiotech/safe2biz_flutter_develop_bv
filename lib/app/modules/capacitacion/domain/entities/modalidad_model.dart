import 'dart:convert';


import 'package:safe2biz/app/modules/capacitacion/domain/entities/estado_curso.dart';



List<ModalidadModel> EstadoCursoFromJson(String str) =>
    List<ModalidadModel>.from(json.decode(str).map((x) => ModalidadModel.fromJson(x)));

String EstadoCursoToJson(List<ModalidadModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModalidadModel extends EstadoCurso {


  ModalidadModel({


    required int id,
    required String nombre,


  }) : super(

    id : id,
    nombre: nombre,

  );


  factory ModalidadModel.fromJson(json) =>
      ModalidadModel(
        id: json['cap_curso_modalidad_id'] ?? 0,
        nombre: json['nombre'] ?? '',

      );


  Map<String, dynamic> toJson() => {
    'cap_curso_modalidad_id': id,
    'nombre':  nombre,


  };

  ModalidadModel copyWith({
    int? id,
    String? nombre,

  }) =>

      ModalidadModel(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,

      );
}