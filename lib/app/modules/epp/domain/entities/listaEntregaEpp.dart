
import 'package:equatable/equatable.dart';

abstract class ListaEntregaEpp extends Equatable {
  ListaEntregaEpp({
    required this.epp_entrega_id,
    required this.fb_empleado_id,



  });


  /// ayc_registro_id
  /// ayc_registro_id
  int epp_entrega_id;
  int fb_empleado_id;


  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [
    epp_entrega_id,
    fb_empleado_id,


  ];
}


