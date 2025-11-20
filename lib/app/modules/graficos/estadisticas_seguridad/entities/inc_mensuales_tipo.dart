
import 'package:equatable/equatable.dart';

abstract class inc_mensuales_tipo extends Equatable {
  inc_mensuales_tipo({
    required this.TipoIncidente,
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


  String TipoIncidente;
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
 TipoIncidente,
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


