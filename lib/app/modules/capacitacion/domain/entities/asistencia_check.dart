
import 'package:equatable/equatable.dart';

abstract class AsistenciaCheck extends Equatable {
  AsistenciaCheck({

    required this.fb_empleado_id,

  });

  /// ayc_registro_id
  /// ayc_registro_id
  int fb_empleado_id;

  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [

    fb_empleado_id,


  ];
}

