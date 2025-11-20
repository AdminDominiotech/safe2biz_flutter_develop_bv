import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
 class Desviacion extends Equatable {
  Desviacion({
    required this.id,
    required this.ayc,
    required this.descripcion,
  });

  String id;
  String ayc;
  String descripcion;

  @override
  List<Object> get props => [
        id,
        ayc,
        descripcion,
      ];
}
