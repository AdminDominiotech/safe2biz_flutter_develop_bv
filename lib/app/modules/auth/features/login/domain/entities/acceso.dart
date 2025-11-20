import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class Acceso extends Equatable {
  Acceso({
    required this.fbUeaPeId,
    required this.codigo,
    required this.modulos,
  });

  final String fbUeaPeId;
  final String codigo;
  final String modulos;

  Map<String, dynamic> toJson();

  @override
  List<Object> get props => [
        fbUeaPeId,
        codigo,
        modulos,
      ];
}
