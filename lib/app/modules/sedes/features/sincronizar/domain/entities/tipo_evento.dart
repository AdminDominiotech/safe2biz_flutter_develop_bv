import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class TipoEvento extends Equatable {
  const TipoEvento({
    required this.id,
    required this.nombre,
  });

  final String id;
  final String nombre;

  @override
  List<Object> get props => [
        id,
        nombre,
      ];
}
