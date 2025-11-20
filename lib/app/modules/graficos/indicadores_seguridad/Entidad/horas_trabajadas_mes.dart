
import 'package:equatable/equatable.dart';

abstract class horas_trabajadas_mes extends Equatable {
  horas_trabajadas_mes({
    required this.rol,
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


  String rol;
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
    rol,
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


