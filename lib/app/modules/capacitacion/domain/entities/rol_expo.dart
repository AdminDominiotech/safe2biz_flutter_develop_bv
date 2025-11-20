import 'package:equatable/equatable.dart';

abstract class RolExpo extends Equatable {
  RolExpo({
    required this.id,
    required this.rol,
  });


  /// ayc_registro_id
  /// ayc_registro_id
  int id;
  String rol;


  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [
    id,
    rol,


  ];
}

