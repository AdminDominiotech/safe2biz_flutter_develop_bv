import 'package:equatable/equatable.dart';

class TipoResultado extends Equatable {
  TipoResultado({
    required this.id,
    required this.codigo,
    required this.nombre,
  });

  final String id;
  final String codigo;
  final String nombre;

  @override
  List<Object?> get props => [
        id,
        codigo,
        nombre,
      ];
}
