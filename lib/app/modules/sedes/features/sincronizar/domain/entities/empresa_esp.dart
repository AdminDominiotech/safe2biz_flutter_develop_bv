import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class EmpresaEsp extends Equatable {
  const EmpresaEsp({
    required this.id,
    required this.razonSocial,
    required this.rucEmpresa,
    required this.gRolEmpresaId,
  });

  final String id;
  final String razonSocial;
  final String rucEmpresa;
  final String gRolEmpresaId;

  @override
  List<Object> get props => [
        id,
        razonSocial,
        rucEmpresa,
        gRolEmpresaId,
      ];
}
