
import 'package:equatable/equatable.dart';

abstract class plan_accion extends Equatable {
  plan_accion({
    required this.nombre,
    required this.ene,
    required this.feb,
    required this.mar,
    required this.abr,
    required this.may,
    required this.jun,
    required this.jul,
    required this.ago,
    required this.set,
    required this.oct,
    required this.nov,
    required this.dic,

  });


  String nombre;
  int ene;
  int feb;
  int mar;
  int abr;
  int may;
  int jun;
  int jul;
  int ago;
  int set;
  int oct;
  int nov;
  int dic;




  /// 0: create,1: online
  //String estado;
  @override
  List<Object> get props => [
    nombre,
    ene,
    feb,
    mar,
    abr,
    may,
    jun,
    jul,
    ago,
    set,
    oct,
    nov,
    dic,



  ];
}


