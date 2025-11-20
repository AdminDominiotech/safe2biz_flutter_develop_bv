import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
enum Module {

  INC, //1
  AYC, //2
  PLAN_ACCION,  //3
  LIST_VERIFI,  //4
  GRAF_RENDIMIENTO,  //7
  GRAF_INC,
  REPORT_INC,   //5
  REPORT_PLAN_ACCION, //6//8
  ENTREGA_EPP,       //9
  AYC_BOT,           //10

  ESTAD_SEG,   //11
  INDIC_SEG,    //12
  CAP,
  SST,
  DAT,
  AUD


}

abstract class ItemModule extends Equatable {
  ItemModule({
    required this.id,
    required this.prefix,
    required this.name,
    required this.icon,
  });

  String id;
  Module prefix;
  String name;
  String icon;

  @override
  List<Object> get props => [
    id,
    prefix,
    name,
    icon,
  ];
}
