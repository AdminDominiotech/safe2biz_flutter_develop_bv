import 'dart:convert';
import 'dart:io';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/indice_frecuencia_model.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/indice_severidad_model.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/frecuencia_lti_model.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/frecuencia_fai_model.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/frecuencia_mti_model.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/horas_trabajadas_mes_model.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/incidentes_seguridad_model.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/Entidad/severidad_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:ui' as ui;
import 'dart:typed_data';

final NumberFormat format = NumberFormat('#.##');
//Severidad
List<double> SeveridadY1 =  [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00];

//Frecuencia
List<int> FrecuenciaY1 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
List<int> FrecuenciaY2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
//FrecuenciaMTI
List<double> FrecuenciaMTIY1 =  [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00];

//FrecuenciaLTI
List<double> FrecuenciaLTIY1 =  [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00];

//FrecuenciaFAI
List<double> FrecuenciaFAIY1 = [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00];


//Incidentes Mensuales de Seguridad
List<int> IncSegY1 =[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; //Lesion con primeros Aux   (FAI)
List<int> IncSegY2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];  //Lesion con tiempo perdido (LTI)
List<int> IncSegY3 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];   //Lesion con trat. medidco  (MTI)
List<int> IncSegY4 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];   //Near Miss (NM)

//Incidentes Horas trabajadas


List<int> HorasTrabY1 =[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; //Lesion con primeros Aux   (FAI)
List<int> HorasTrabY2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];  //Lesion con tiempo perdido (LTI)


//["Ene", "Feb", "Mar",    "Abr", "May", "Jun",      "Jul", "Ago", "Set",     "Oct", "Nov", "Dic"];
List<String> SeveridadX = ["", "", "",    "", "", "",      "", "", "",     "", "", ""];
//List<String> FrecuenciaX = ["", "", "",    "", "", "",      "", "", "",     "", "", ""];




List<String> IncSegX = ["Ene", "Feb", "Mar",    "Abr", "May", "Jun",      "Jul", "Ago", "Set",     "Oct", "Nov", "Dic"];

List<String> HorasTraX =["Ene", "Feb", "Mar",    "Abr", "May", "Jun",      "Jul", "Ago", "Set",     "Oct", "Nov", "Dic"];



bool trat_medico = true;
bool tiempo_perd = false;
bool primeros_aux = false;
Color? pushButtonMed = Colors.teal;
Color? pushButtonTiempo  =Color(0xFF5283B0);
Color? pushButtonAux =Color(0xFF5283B0);

//Opc
bool indVisibility = true;
bool incVisibility = false;

Border? borderBottomOpc;

Border borderInd = Border(bottom: BorderSide(width: 3, color: Color(0XFFFF9F40)), );
Border borderInc = Border(bottom: BorderSide(width: 0));

//


//FILTROS mes
bool isSevMes = false;
bool isFrecMes = false;

String dropdownValue = '2020'; //Inicialización del año en 2020
String dropdownValueMes = 'Abril';
String dropdownValueAmb = 'Todos';

//Clase indicadores de seguridad
SqlDb sqlDb = SqlDb();

final localSqliteInstance = LocalSqlite();
final authController = AuthController(sqlite: localSqliteInstance);

class IndicadoresSeguridad extends StatefulWidget {
  final String? sede;
  const IndicadoresSeguridad({Key? key, this.sede}) : super(key: key);

  @override
  State<IndicadoresSeguridad> createState() => _IndicadoresSeguridadState();
}
class _IndicadoresSeguridadState extends State<IndicadoresSeguridad> {

  //Incidentes seguridad
  List<ChartDataIncSeguridad> _chartDataIncSeguridad = [
    ChartDataIncSeguridad(IncSegX[0], IncSegY1[0].toDouble(),  IncSegY2[0].toDouble(),  IncSegY3[0].toDouble(),  IncSegY4[0].toDouble(), Colors.teal),
    ChartDataIncSeguridad(IncSegX[1], IncSegY1[1].toDouble(),  IncSegY2[1].toDouble(),  IncSegY3[1].toDouble(),  IncSegY4[1].toDouble(), Colors.teal),
    ChartDataIncSeguridad(IncSegX[2], IncSegY1[2].toDouble(),  IncSegY2[2].toDouble(),  IncSegY3[2].toDouble(),  IncSegY4[2].toDouble(), Colors.teal),
    ChartDataIncSeguridad(IncSegX[3], IncSegY1[3].toDouble(),  IncSegY2[3].toDouble(),  IncSegY3[3].toDouble(),  IncSegY4[3].toDouble(), Colors.teal),
    ChartDataIncSeguridad(IncSegX[4], IncSegY1[4].toDouble(),  IncSegY2[4].toDouble(),  IncSegY3[4].toDouble(),  IncSegY4[4].toDouble(), Colors.teal),
    ChartDataIncSeguridad(IncSegX[5], IncSegY1[5].toDouble(),  IncSegY2[5].toDouble(),  IncSegY3[5].toDouble(),  IncSegY4[5].toDouble(), Colors.teal),
    ChartDataIncSeguridad(IncSegX[6], IncSegY1[6].toDouble(),  IncSegY2[6].toDouble(),  IncSegY3[6].toDouble(),  IncSegY4[6].toDouble(), Colors.teal),
    ChartDataIncSeguridad(IncSegX[7], IncSegY1[7].toDouble(),  IncSegY2[7].toDouble(),  IncSegY3[7].toDouble(),  IncSegY4[7].toDouble(), Colors.teal),
    ChartDataIncSeguridad(IncSegX[8], IncSegY1[8].toDouble(),  IncSegY2[8].toDouble(),  IncSegY3[8].toDouble(),  IncSegY4[8].toDouble(), Colors.teal),
    ChartDataIncSeguridad(IncSegX[9], IncSegY1[9].toDouble(),  IncSegY2[9].toDouble(),  IncSegY3[9].toDouble(),  IncSegY4[9].toDouble(), Colors.teal),
    ChartDataIncSeguridad(IncSegX[10], IncSegY1[10].toDouble(),  IncSegY2[10].toDouble(),  IncSegY3[10].toDouble(),  IncSegY4[10].toDouble(), Colors.teal),
    ChartDataIncSeguridad(IncSegX[11], IncSegY1[11].toDouble(),  IncSegY2[11].toDouble(),  IncSegY3[11].toDouble(),  IncSegY4[11].toDouble(), Colors.teal),
  ];


  //Horas trabajadas

  List<ChartDataHorasTrab>  _chartDataHorasTrabajadas = [
    ChartDataHorasTrab(HorasTraX[0], HorasTrabY1[0].toDouble(), HorasTrabY2[0].toDouble(), Colors.teal),
    ChartDataHorasTrab(HorasTraX[1],  HorasTrabY1[1].toDouble(), HorasTrabY2[1].toDouble(), Colors.teal),
    ChartDataHorasTrab(HorasTraX[2], HorasTrabY1[2].toDouble(), HorasTrabY2[2].toDouble(), Colors.teal),
    ChartDataHorasTrab(HorasTraX[3],  HorasTrabY1[3].toDouble(), HorasTrabY2[3].toDouble(), Colors.teal),
    ChartDataHorasTrab(HorasTraX[4],  HorasTrabY1[4].toDouble(), HorasTrabY2[4].toDouble(), Colors.teal),
    ChartDataHorasTrab(HorasTraX[5],  HorasTrabY1[5].toDouble(), HorasTrabY2[5].toDouble(), Colors.teal),
    ChartDataHorasTrab(HorasTraX[6],  HorasTrabY1[6].toDouble(), HorasTrabY2[6].toDouble(), Colors.teal),
    ChartDataHorasTrab(HorasTraX[7],  HorasTrabY1[7].toDouble(), HorasTrabY2[7].toDouble(), Colors.teal),
    ChartDataHorasTrab(HorasTraX[8],  HorasTrabY1[8].toDouble(), HorasTrabY2[8].toDouble(), Colors.teal),
    ChartDataHorasTrab(HorasTraX[9],  HorasTrabY1[9].toDouble(), HorasTrabY2[9].toDouble(), Colors.teal),
    ChartDataHorasTrab(HorasTraX[10],  HorasTrabY1[10].toDouble(), HorasTrabY2[10].toDouble(), Colors.teal),
    ChartDataHorasTrab(HorasTraX[11],  HorasTrabY1[11].toDouble(), HorasTrabY2[11].toDouble(), Colors.teal),
  ];



  List<ChartDataSeveridad>           _chartDataSeveridad = [
    ChartDataSeveridad(SeveridadX[0], SeveridadY1[0], Colors.teal),
    ChartDataSeveridad(SeveridadX[1], SeveridadY1[1],  Colors.teal),
    ChartDataSeveridad(SeveridadX[2], SeveridadY1[2], Colors.teal),
    ChartDataSeveridad(SeveridadX[3], SeveridadY1[3], Colors.teal),
    ChartDataSeveridad(SeveridadX[4], SeveridadY1[4], Colors.teal),
    ChartDataSeveridad(SeveridadX[5], SeveridadY1[5], Colors.teal),
    ChartDataSeveridad(SeveridadX[6], SeveridadY1[6], Colors.teal),
    ChartDataSeveridad(SeveridadX[7], SeveridadY1[7], Colors.teal),
    ChartDataSeveridad(SeveridadX[8], SeveridadY1[8], Colors.teal),
    ChartDataSeveridad(SeveridadX[9], SeveridadY1[9], Colors.teal),
    ChartDataSeveridad(SeveridadX[10], SeveridadY1[10], Colors.teal),
    ChartDataSeveridad(SeveridadX[11], SeveridadY1[11],Colors.teal),
  ];

  List<ChartDataFrecuenciaMTI>  _chartDataFrecuenciaMTI = [
    ChartDataFrecuenciaMTI(SeveridadX[0], FrecuenciaMTIY1[0]),
    ChartDataFrecuenciaMTI(SeveridadX[1], FrecuenciaMTIY1[1]),
    ChartDataFrecuenciaMTI(SeveridadX[2], FrecuenciaMTIY1[2]),
    ChartDataFrecuenciaMTI(SeveridadX[3], FrecuenciaMTIY1[3]),
    ChartDataFrecuenciaMTI(SeveridadX[4], FrecuenciaMTIY1[4]),
    ChartDataFrecuenciaMTI(SeveridadX[5], FrecuenciaMTIY1[5]),
    ChartDataFrecuenciaMTI(SeveridadX[6], FrecuenciaMTIY1[6]),
    ChartDataFrecuenciaMTI(SeveridadX[7], FrecuenciaMTIY1[7]),
    ChartDataFrecuenciaMTI(SeveridadX[8], FrecuenciaMTIY1[8]),
    ChartDataFrecuenciaMTI(SeveridadX[9], FrecuenciaMTIY1[9]),
    ChartDataFrecuenciaMTI(SeveridadX[10], FrecuenciaMTIY1[10]),
    ChartDataFrecuenciaMTI(SeveridadX[11], FrecuenciaMTIY1[11]),
  ];




  List<ChartDataFrecuenciaLTI> _chartDataFrecuenciaLTI = [
    ChartDataFrecuenciaLTI(SeveridadX[0], FrecuenciaLTIY1[0]),
    ChartDataFrecuenciaLTI(SeveridadX[1], FrecuenciaLTIY1[1]),
    ChartDataFrecuenciaLTI(SeveridadX[2], FrecuenciaLTIY1[2]),
    ChartDataFrecuenciaLTI(SeveridadX[3], FrecuenciaLTIY1[3]),
    ChartDataFrecuenciaLTI(SeveridadX[4], FrecuenciaLTIY1[4]),
    ChartDataFrecuenciaLTI(SeveridadX[5], FrecuenciaLTIY1[5]),
    ChartDataFrecuenciaLTI(SeveridadX[6], FrecuenciaLTIY1[6]),
    ChartDataFrecuenciaLTI(SeveridadX[7], FrecuenciaLTIY1[7]),
    ChartDataFrecuenciaLTI(SeveridadX[8], FrecuenciaLTIY1[8]),
    ChartDataFrecuenciaLTI(SeveridadX[9], FrecuenciaLTIY1[9]),
    ChartDataFrecuenciaLTI(SeveridadX[10], FrecuenciaLTIY1[10]),
    ChartDataFrecuenciaLTI(SeveridadX[11], FrecuenciaLTIY1[11]),
  ];

  List<ChartDataFrecuenciaFAI>  _chartDataFrecuenciaFAI = [
    ChartDataFrecuenciaFAI(SeveridadX[0], FrecuenciaFAIY1[0]),
    ChartDataFrecuenciaFAI(SeveridadX[1], FrecuenciaFAIY1[1]),
    ChartDataFrecuenciaFAI(SeveridadX[2], FrecuenciaFAIY1[2]),
    ChartDataFrecuenciaFAI(SeveridadX[3], FrecuenciaFAIY1[3]),
    ChartDataFrecuenciaFAI(SeveridadX[4], FrecuenciaFAIY1[4]),
    ChartDataFrecuenciaFAI(SeveridadX[5], FrecuenciaFAIY1[5]),
    ChartDataFrecuenciaFAI(SeveridadX[6], FrecuenciaFAIY1[6]),
    ChartDataFrecuenciaFAI(SeveridadX[7], FrecuenciaFAIY1[7]),
    ChartDataFrecuenciaFAI(SeveridadX[8], FrecuenciaFAIY1[8]),
    ChartDataFrecuenciaFAI(SeveridadX[9], FrecuenciaFAIY1[9]),
    ChartDataFrecuenciaFAI(SeveridadX[10], FrecuenciaFAIY1[10]),
    ChartDataFrecuenciaFAI(SeveridadX[11], FrecuenciaFAIY1[11]),
  ];


  void _refreshChart() async {
    setState(() {

      //Incidentes de Seguridad

      _chartDataIncSeguridad = [
        ChartDataIncSeguridad(IncSegX[0], IncSegY1[0].toDouble(),  IncSegY2[0].toDouble(),  IncSegY3[0].toDouble(),  IncSegY4[0].toDouble(), Colors.teal),
        ChartDataIncSeguridad(IncSegX[1], IncSegY1[1].toDouble(),  IncSegY2[1].toDouble(),  IncSegY3[1].toDouble(),  IncSegY4[1].toDouble(), Colors.teal),
        ChartDataIncSeguridad(IncSegX[2], IncSegY1[2].toDouble(),  IncSegY2[2].toDouble(),  IncSegY3[2].toDouble(),  IncSegY4[2].toDouble(), Colors.teal),
        ChartDataIncSeguridad(IncSegX[3], IncSegY1[3].toDouble(),  IncSegY2[3].toDouble(),  IncSegY3[3].toDouble(),  IncSegY4[3].toDouble(), Colors.teal),
        ChartDataIncSeguridad(IncSegX[4], IncSegY1[4].toDouble(),  IncSegY2[4].toDouble(),  IncSegY3[4].toDouble(),  IncSegY4[4].toDouble(), Colors.teal),
        ChartDataIncSeguridad(IncSegX[5], IncSegY1[5].toDouble(),  IncSegY2[5].toDouble(),  IncSegY3[5].toDouble(),  IncSegY4[5].toDouble(), Colors.teal),
        ChartDataIncSeguridad(IncSegX[6], IncSegY1[6].toDouble(),  IncSegY2[6].toDouble(),  IncSegY3[6].toDouble(),  IncSegY4[6].toDouble(), Colors.teal),
        ChartDataIncSeguridad(IncSegX[7], IncSegY1[7].toDouble(),  IncSegY2[7].toDouble(),  IncSegY3[7].toDouble(),  IncSegY4[7].toDouble(), Colors.teal),
        ChartDataIncSeguridad(IncSegX[8], IncSegY1[8].toDouble(),  IncSegY2[8].toDouble(),  IncSegY3[8].toDouble(),  IncSegY4[8].toDouble(), Colors.teal),
        ChartDataIncSeguridad(IncSegX[9], IncSegY1[9].toDouble(),  IncSegY2[9].toDouble(),  IncSegY3[9].toDouble(),  IncSegY4[9].toDouble(), Colors.teal),
        ChartDataIncSeguridad(IncSegX[10], IncSegY1[10].toDouble(),  IncSegY2[10].toDouble(),  IncSegY3[10].toDouble(),  IncSegY4[10].toDouble(), Colors.teal),
        ChartDataIncSeguridad(IncSegX[11], IncSegY1[11].toDouble(),  IncSegY2[11].toDouble(),  IncSegY3[11].toDouble(),  IncSegY4[11].toDouble(), Colors.teal),
      ];

      //Horas trabajadas
      _chartDataHorasTrabajadas = [
        ChartDataHorasTrab(HorasTraX[0], HorasTrabY1[0].toDouble(), HorasTrabY2[0].toDouble(), Colors.teal),
        ChartDataHorasTrab(HorasTraX[1],  HorasTrabY1[1].toDouble(), HorasTrabY2[1].toDouble(), Colors.teal),
        ChartDataHorasTrab(HorasTraX[2], HorasTrabY1[2].toDouble(), HorasTrabY2[2].toDouble(), Colors.teal),
        ChartDataHorasTrab(HorasTraX[3],  HorasTrabY1[3].toDouble(), HorasTrabY2[3].toDouble(), Colors.teal),
        ChartDataHorasTrab(HorasTraX[4],  HorasTrabY1[4].toDouble(), HorasTrabY2[4].toDouble(), Colors.teal),
        ChartDataHorasTrab(HorasTraX[5],  HorasTrabY1[5].toDouble(), HorasTrabY2[5].toDouble(), Colors.teal),
        ChartDataHorasTrab(HorasTraX[6],  HorasTrabY1[6].toDouble(), HorasTrabY2[6].toDouble(), Colors.teal),
        ChartDataHorasTrab(HorasTraX[7],  HorasTrabY1[7].toDouble(), HorasTrabY2[7].toDouble(), Colors.teal),
        ChartDataHorasTrab(HorasTraX[8],  HorasTrabY1[8].toDouble(), HorasTrabY2[8].toDouble(), Colors.teal),
        ChartDataHorasTrab(HorasTraX[9],  HorasTrabY1[9].toDouble(), HorasTrabY2[9].toDouble(), Colors.teal),
        ChartDataHorasTrab(HorasTraX[10],  HorasTrabY1[10].toDouble(), HorasTrabY2[10].toDouble(), Colors.teal),
        ChartDataHorasTrab(HorasTraX[11],  HorasTrabY1[11].toDouble(), HorasTrabY2[11].toDouble(), Colors.teal),
      ];

       //Severidad
      _chartDataSeveridad = [
        ChartDataSeveridad(SeveridadX[0], SeveridadY1[0], Colors.teal),
        ChartDataSeveridad(SeveridadX[1], SeveridadY1[1],  Colors.teal),
        ChartDataSeveridad(SeveridadX[2], SeveridadY1[2], Colors.teal),
        ChartDataSeveridad(SeveridadX[3], SeveridadY1[3], Colors.teal),
        ChartDataSeveridad(SeveridadX[4], SeveridadY1[4], Colors.teal),
        ChartDataSeveridad(SeveridadX[5], SeveridadY1[5], Colors.teal),
        ChartDataSeveridad(SeveridadX[6], SeveridadY1[6], Colors.teal),
        ChartDataSeveridad(SeveridadX[7], SeveridadY1[7], Colors.teal),
        ChartDataSeveridad(SeveridadX[8], SeveridadY1[8], Colors.teal),
        ChartDataSeveridad(SeveridadX[9], SeveridadY1[9], Colors.teal),
        ChartDataSeveridad(SeveridadX[10], SeveridadY1[10], Colors.teal),
        ChartDataSeveridad(SeveridadX[11], SeveridadY1[11],Colors.teal),
      ];

     _chartDataFrecuenciaMTI = [
        ChartDataFrecuenciaMTI(SeveridadX[0], FrecuenciaMTIY1[0]),
        ChartDataFrecuenciaMTI(SeveridadX[1], FrecuenciaMTIY1[1]),
        ChartDataFrecuenciaMTI(SeveridadX[2], FrecuenciaMTIY1[2]),
        ChartDataFrecuenciaMTI(SeveridadX[3], FrecuenciaMTIY1[3]),
        ChartDataFrecuenciaMTI(SeveridadX[4], FrecuenciaMTIY1[4]),
        ChartDataFrecuenciaMTI(SeveridadX[5], FrecuenciaMTIY1[5]),
        ChartDataFrecuenciaMTI(SeveridadX[6], FrecuenciaMTIY1[6]),
        ChartDataFrecuenciaMTI(SeveridadX[7], FrecuenciaMTIY1[7]),
        ChartDataFrecuenciaMTI(SeveridadX[8], FrecuenciaMTIY1[8]),
        ChartDataFrecuenciaMTI(SeveridadX[9], FrecuenciaMTIY1[9]),
        ChartDataFrecuenciaMTI(SeveridadX[10], FrecuenciaMTIY1[10]),
        ChartDataFrecuenciaMTI(SeveridadX[11], FrecuenciaMTIY1[11]),
      ];

      _chartDataFrecuenciaLTI = [
        ChartDataFrecuenciaLTI(SeveridadX[0], FrecuenciaLTIY1[0]),
        ChartDataFrecuenciaLTI(SeveridadX[1], FrecuenciaLTIY1[1]),
        ChartDataFrecuenciaLTI(SeveridadX[2], FrecuenciaLTIY1[2]),
        ChartDataFrecuenciaLTI(SeveridadX[3], FrecuenciaLTIY1[3]),
        ChartDataFrecuenciaLTI(SeveridadX[4], FrecuenciaLTIY1[4]),
        ChartDataFrecuenciaLTI(SeveridadX[5], FrecuenciaLTIY1[5]),
        ChartDataFrecuenciaLTI(SeveridadX[6], FrecuenciaLTIY1[6]),
        ChartDataFrecuenciaLTI(SeveridadX[7], FrecuenciaLTIY1[7]),
        ChartDataFrecuenciaLTI(SeveridadX[8], FrecuenciaLTIY1[8]),
        ChartDataFrecuenciaLTI(SeveridadX[9], FrecuenciaLTIY1[9]),
        ChartDataFrecuenciaLTI(SeveridadX[10], FrecuenciaLTIY1[10]),
        ChartDataFrecuenciaLTI(SeveridadX[11], FrecuenciaLTIY1[11]),
      ];

      _chartDataFrecuenciaFAI = [
        ChartDataFrecuenciaFAI(SeveridadX[0], FrecuenciaFAIY1[0]),
        ChartDataFrecuenciaFAI(SeveridadX[1], FrecuenciaFAIY1[1]),
        ChartDataFrecuenciaFAI(SeveridadX[2], FrecuenciaFAIY1[2]),
        ChartDataFrecuenciaFAI(SeveridadX[3], FrecuenciaFAIY1[3]),
        ChartDataFrecuenciaFAI(SeveridadX[4], FrecuenciaFAIY1[4]),
        ChartDataFrecuenciaFAI(SeveridadX[5], FrecuenciaFAIY1[5]),
        ChartDataFrecuenciaFAI(SeveridadX[6], FrecuenciaFAIY1[6]),
        ChartDataFrecuenciaFAI(SeveridadX[7], FrecuenciaFAIY1[7]),
        ChartDataFrecuenciaFAI(SeveridadX[8], FrecuenciaFAIY1[8]),
        ChartDataFrecuenciaFAI(SeveridadX[9], FrecuenciaFAIY1[9]),
        ChartDataFrecuenciaFAI(SeveridadX[10], FrecuenciaFAIY1[10]),
        ChartDataFrecuenciaFAI(SeveridadX[11], FrecuenciaFAIY1[11]),
      ];

    });
  }

  //Key Charts
  late GlobalKey<SfCartesianChartState> _cartesianChartSeg;
  late GlobalKey<SfCartesianChartState> _cartesianChartHor;

  // EstadisticaEntregaState();
  late GlobalKey<SfCartesianChartState> _cartesianChartOne;
  late GlobalKey<SfCartesianChartState> _cartesianChartTwo;
  late GlobalKey<SfCartesianChartState> _cartesianChartThree;
  late GlobalKey<SfCartesianChartState> _cartesianChartFour;


  // late List<ChartData> _chartData;  //Bar Chart
  late TooltipBehavior _tooltipBehavior; //Pie Cahrt

  void initState(){
    super.initState();


      _asyncMethod(dropdownValue);
     // _refreshChart();

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y%',
    );

    _cartesianChartSeg =GlobalKey();
    _cartesianChartHor =GlobalKey();
    _cartesianChartOne = GlobalKey();
    _cartesianChartTwo = GlobalKey();
    _cartesianChartThree = GlobalKey();
    _cartesianChartFour = GlobalKey();
    print("Sede est_seg === ${widget.sede}");
  }

  _asyncMethod(String anho) async {
    //Indice de severidad
    await RequestDataIndSeveridad(dropdownValue);
    //Incidentes seguridad
    await RequestDataIncSeguridad(dropdownValue);
    //Horas Trabajadas
    await RequestDataHorasTrabajadas(dropdownValue);
    //await RequestDataIndFrecuencia(dropdownValue);

    //Frecuencia MTI
    await RequestDataIndFrecuenciaMTI(dropdownValue);
    //Frecuencia LTI
    await RequestDataIndFrecuenciaLTI(dropdownValue);
    //FrecuenciaFAI
    await RequestDataIndFrecuenciaFAI(dropdownValue);
  }

  @override
  Widget build(BuildContext context) {

    _refreshChart();

    return Scaffold(
      appBar: AppBar(title: Text("Indicadores de Seguridad", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),), backgroundColor: S2BColors.primaryColor,elevation: 0, ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
                width: MediaQuery.of(context).size.width*1,
              height: 60,
              color: Color(0XFF0A3987),
              child: Row(
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          incVisibility = false;
                          indVisibility = true;
                          borderInd =  Border(bottom: BorderSide(width: 4, color: Color(0XFFFF9F40)), );
                          borderInc = Border(bottom: BorderSide(width: 0), );
                        });
                      },
                      child: Container(
                        decoration:  BoxDecoration(
                            border: borderInd,
                        ),

                          width: MediaQuery.of(context).size.width*0.5,
                          height: 60,
                          child: Align(
                            alignment: Alignment.center,

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.line_axis, color: Colors.white ,),
                                  SizedBox(height: 2,),
                                  Text("Indicadores", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                                ],
                              )),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        setState(() {
                          incVisibility = true;
                          indVisibility = false;

                          borderInc =  Border(bottom: BorderSide(width: 4, color: Color(0XFFFF9F40)), );
                          borderInd = Border(bottom: BorderSide(width: 0), );
                        });
                      },
                      child: Container(
                        decoration:  BoxDecoration(
                          border: borderInc,
                        ),

                        width: MediaQuery.of(context).size.width*0.5,
                        height: 60,
                        child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bar_chart, color: Colors.white,),
                                SizedBox(height: 2,),
                                Text("Incidentes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                              ],
                            )),
                      ),
                    ),

                  ],
              ),
            ),

            SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width*0.93,
              decoration:
              BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0) ),


//              height: 45,

              child: ExpandableNotifier(

                child: Column(
                  children: [

                    Expandable(

                      collapsed: ExpandableButton(
                        child: Container(
                          width: MediaQuery.of(context).size.width*1,
                          height: 35,
                          decoration: BoxDecoration(
                            color:Color(0XFF0A3987),
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Row(
                                  children: [
                                    Icon(Icons.filter_list_alt, size: 16, color: Colors.white,),
                                    SizedBox(width: 10,),
                                    Text("Filtros", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                                  ],
                                ),

                                Icon(Icons.arrow_drop_down, color: Colors.white, size: 18,)

                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      
                      expanded:  Column(

                children: [

                ExpandableButton(
                child: Container(
                width: MediaQuery.of(context).size.width*1,
                height: 30,
                decoration: BoxDecoration(
                  color:Color(0XFF0A3987),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0)),),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [
                          Icon(Icons.filter_list_alt, size: 16, color: Colors.white,),
                          SizedBox(width: 10,),
                          Text("Filtros", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                        ],
                      ),

                      Icon(Icons.arrow_drop_up_outlined, color: Colors.white, size: 18,)

                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child:

              //Filtros
              Column(
                children: [

                  SizedBox(height: 5,),

                  //Filtro Ámbito
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.black,
                              size: 18,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "Ámbito  :",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),



                        Container(
                          width: MediaQuery.of(context).size.width*0.3,
                          height: 33,
                          decoration: BoxDecoration(     borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey, style: BorderStyle.solid, width: 0.80),),

                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: StatefulBuilder(builder: (context, setState) {
                              return DropdownButton<String>(
                                isExpanded: true,
                                iconEnabledColor: Colors.black,
                                value: dropdownValueAmb,
                                underline: SizedBox(),
                                borderRadius: BorderRadius.circular(10.0),
                                dropdownColor: Colors.white,
                                items: <String>[
                                  'Todos',
                                  'Titular',
                                  'Contratista',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
                                    ),
                                  );
                                }).toList(),
                                // Step 5.
                                onChanged: (String? newValue) async {
                                  //          valorAnho = newValue!;

                                  setState((){
                                    //_asyncMethod(dropdownValue);
                                    dropdownValueAmb = newValue!;
                                   // print("valorAnho--> ${newValue}");
                                  });


                                },
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10,),
                  //Filtro Año
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [

                                        Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          color: Colors.black,
                                            size: 18,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),


                            Text(
                              "Año  :",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),





                        Container(
                          width: MediaQuery.of(context).size.width*0.3,
                          height: 33,
                          decoration: BoxDecoration(     borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey, style: BorderStyle.solid, width: 0.80),),

                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: StatefulBuilder(builder: (context, setState) {
                              return DropdownButton<String>(
                                isExpanded: true,
                                iconEnabledColor: Colors.black,
                                value: dropdownValue,
                                underline: SizedBox(),
                                borderRadius: BorderRadius.circular(10.0),
                                dropdownColor: Colors.white,
                                items: <String>[

                                  '2023',
                                  '2022',
                                  '2021',
                                  '2020',
                                  '2019',

                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                                    ),
                                  );
                                }).toList(),
                                // Step 5.
                                onChanged: (String? newValue) async {
                                  //          valorAnho = newValue!;

                                  setState((){
                                   // _asyncMethod(dropdownValue);
                                    dropdownValue = newValue!;
                                  //  print("valorAnho--> ${newValue}");
                                  });


                                },
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Filtro Mes
                  Visibility(
                    visible: indVisibility,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.93,
                        height: 42,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0) ),


                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text("Mes  :", style: TextStyle(fontWeight: FontWeight.w500),),
                                ],
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width*0.3,
                                height: 33,
                                decoration: BoxDecoration(     borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Colors.grey, style: BorderStyle.solid, width: 0.80),),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: StatefulBuilder(builder: (context, setState) {
                                    return DropdownButton<String>(

                                      isExpanded: true,
                                      iconEnabledColor: Colors.black,
                                      value: dropdownValueMes,
                                      underline: SizedBox(),
                                      borderRadius: BorderRadius.circular(10.0),
                                      dropdownColor: Colors.white,
                                      items: <String>[
                                        'Enero',
                                        'Febrero',
                                        'Marzo',
                                        'Abril',
                                        'Mayo',
                                        'Junio',
                                        'Julio',
                                        'Agosto',
                                        'Setiembre',
                                        'Octubre',
                                        'Noviembre',
                                        'Diciembre'
                                      ].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(

                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
                                          ),
                                        );
                                      }).toList(),
                                      // Step 5.
                                      onChanged: (String? newValue) async {
                                        //          valorAnho = newValue!;

                                        setState((){
                                       //   _asyncMethod(dropdownValue);
                                          dropdownValueMes = newValue!;
                                       //   print("valorAnho--> ${newValue}");
                                        });

                                      },
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),


                  //Filter Button
                

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width*1,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFFEF8E3B),
                        ),
                        onPressed: (){


                          _asyncMethod(dropdownValue);
                         // RequestDataIndFrecuenciaFAI

                          //   Future.delayed(Duration(milliseconds: 1200))
                         //     .then((value) => _refreshChart());

                        },
                        child: Text("Filtrar", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ],
        ),

                    ),



                  ],
                ),
              ),
            ),

            //Incidentes de Seguridad

            Visibility(
              visible: incVisibility,
              child: Container(
                color: Color(0xffEBEFFB),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                  color: Color(0xff008A8A),
                                ),
                                width: MediaQuery.of(context).size.width * 0.95,
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.label_important,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Incidentes Mensuales de Seguridad",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Row(
                                      children: [
                                        /*
                                                   IconButton(onPressed: () async{
                                                     await _renderChartAsImage();
                                                   }, icon: Icon(Icons.add_chart, size: 20, color: Colors.white,)),
                                                 */
                                        IconButton(
                                            onPressed: () async {
                                              await _renderPDF(_cartesianChartSeg, 'IncSeguridad', '$dropdownValue', 'Incidentes Mensuales de Seguridad');
                                            },
                                            icon: Icon(
                                              Icons.picture_as_pdf,
                                              size: 20,
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              color: Colors.white12,
                              border: Border.all(
                                width: 0.1, //
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Visibility(
                                  visible: true,
                                  child: Container(
                                    height: 400,
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    child: StatefulBuilder(
                                        builder: (context, setState) {
                                          return SfCartesianChart(
                                              primaryYAxis: NumericAxis(
                                                // axis interval is set to 10
                                                  interval: 1),
                                                primaryXAxis: CategoryAxis(
                                                labelIntersectAction:
                                                AxisLabelIntersectAction.rotate45,
                                                isVisible: true,
                                                interval: 1,

                                                labelStyle: TextStyle(fontSize: 9),),
                                              enableAxisAnimation: true,
                                              legend: Legend(isVisible: true),
                                              title: ChartTitle(
                                                  text:
                                                  'Incidentes de Seguridad',
                                                  textStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500)),
                                              key: _cartesianChartSeg,
                                              series: <CartesianSeries<ChartDataIncSeguridad, String>>[
                                                StackedColumnSeries<ChartDataIncSeguridad, String>(
                                                  color: const Color(0xFF4BC0C0),
                                                  name: 'Lesión con primeros auxilios (FAI)',
                                                  animationDelay: 500,
                                                  animationDuration: 2000,
                                                  dataSource: _chartDataIncSeguridad, // List<ChartDataIncSeguridad>
                                                  xValueMapper: (d, _) => d.x,
                                                  yValueMapper: (d, _) => d.y1,
                                                  dataLabelSettings: const DataLabelSettings(
                                                    showZeroValue: false, isVisible: true,
                                                    textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                                  ),
                                                ),
                                                StackedColumnSeries<ChartDataIncSeguridad, String>(
                                                  color: const Color(0xFFFF9F40),
                                                  name: 'Lesión con Tiempo Perdido (LTI)',
                                                  animationDelay: 500,
                                                  animationDuration: 2000,
                                                  dataSource: _chartDataIncSeguridad,
                                                  xValueMapper: (d, _) => d.x,
                                                  yValueMapper: (d, _) => d.y2,
                                                  dataLabelSettings: const DataLabelSettings(
                                                    showZeroValue: false, isVisible: true,
                                                    textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                                  ),
                                                ),
                                                StackedColumnSeries<ChartDataIncSeguridad, String>(
                                                  color: const Color(0xFFFFCD56),
                                                  name: 'Lesión con Tratamiento Médico (MTI)',
                                                  animationDelay: 500,
                                                  animationDuration: 2000,
                                                  dataSource: _chartDataIncSeguridad,
                                                  xValueMapper: (d, _) => d.x,
                                                  yValueMapper: (d, _) => d.y3,
                                                  dataLabelSettings: const DataLabelSettings(
                                                    showZeroValue: false, isVisible: true,
                                                    textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                                  ),
                                                ),
                                                StackedColumnSeries<ChartDataIncSeguridad, String>(
                                                  color: const Color(0xFFFF6384),
                                                  name: 'Near Miss (NM)',
                                                  animationDelay: 500,
                                                  animationDuration: 2000,
                                                  dataSource: _chartDataIncSeguridad,
                                                  xValueMapper: (d, _) => d.x,
                                                  yValueMapper: (d, _) => d.y4,
                                                  dataLabelSettings: const DataLabelSettings(
                                                    showZeroValue: false, isVisible: true,
                                                    textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                                  ),
                                                ),
                                              ]
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Horas Trabajadas
            Visibility(
              visible: incVisibility,
              child: Container(
                color: Color(0xffEBEFFB),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                  color: Color(0xff008A8A),
                                ),
                                width: MediaQuery.of(context).size.width * 0.95,
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.label_important,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Horas Trabajadas por Mes según Rol",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Row(
                                      children: [
                                        /*
                                                   IconButton(onPressed: () async{
                                                     await _renderChartAsImage();
                                                   }, icon: Icon(Icons.add_chart, size: 20, color: Colors.white,)),
                                                 */
                                        IconButton(
                                            onPressed: () async {
                                              await _renderPDF(_cartesianChartHor, 'HorasTrab', '$dropdownValue', 'Horas Trabajadas por Mes según Rol');
                                            },
                                            icon: Icon(
                                              Icons.picture_as_pdf,
                                              size: 20,
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              color: Colors.white12,
                              border: Border.all(
                                width: 0.1, //
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Visibility(
                                  visible: true,
                                  child: Container(
                                    height: 400,
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    child: StatefulBuilder(
                                        builder: (context, setState) {
                                          return SfCartesianChart(
                                              primaryYAxis: NumericAxis(
                                                labelStyle: TextStyle(fontSize: 9),
                                                // axis interval is set to 10
                                                  interval: 10000),
                                              primaryXAxis: CategoryAxis(
                                                labelIntersectAction:
                                                AxisLabelIntersectAction.rotate45,
                                                isVisible: true,
                                                interval: 1,

                                                labelStyle: TextStyle(fontSize: 9),),
                                              enableAxisAnimation: true,
                                              legend: Legend(isVisible: true),
                                              title: ChartTitle(
                                                  text:
                                                  'Horas Trabajadas',
                                                  textStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500)),
                                              key: _cartesianChartHor,
                                              series: <CartesianSeries<ChartDataHorasTrab, String>>[
                                                StackedColumnSeries<ChartDataHorasTrab, String>(
                                                  color: const Color(0xFF4BC0C0),
                                                  name: 'Contratista',
                                                  animationDelay: 500,
                                                  animationDuration: 2000,
                                                  dataSource: _chartDataHorasTrabajadas, // List<ChartDataHorasTrab>
                                                  xValueMapper: (d, _) => d.x,
                                                  yValueMapper: (d, _) => d.y1,
                                                  dataLabelSettings: const DataLabelSettings(
                                                    showZeroValue: false, isVisible: true,
                                                    textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.w500, color: Color(0xFF505154)),
                                                  ),
                                                ),
                                                StackedColumnSeries<ChartDataHorasTrab, String>(
                                                  color: const Color(0xFFFF9F40),
                                                  name: 'Titular',
                                                  animationDelay: 500,
                                                  animationDuration: 2000,
                                                  dataSource: _chartDataHorasTrabajadas,
                                                  xValueMapper: (d, _) => d.x,
                                                  yValueMapper: (d, _) => d.y2,
                                                  dataLabelSettings: const DataLabelSettings(
                                                    showZeroValue: false, isVisible: true,
                                                    textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.w500, color: Color(0xFF505154)),
                                                  ),
                                                ),
                                              ]
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),






            //=========================INDICADOR DE SEVERIDAD
            Visibility(
              visible: indVisibility,
              child: Container(
                color: Color(0xffEBEFFB),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                  color: Color(0xff008A8A),
                                ),
                                width: MediaQuery.of(context).size.width * 0.95,
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.label_important,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Indicadores de Severidad",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                                /*
                                                   IconButton(onPressed: () async{
                                                     await _renderChartAsImage();
                                                   }, icon: Icon(Icons.add_chart, size: 20, color: Colors.white,)),
                                                 */

                                        IconButton(
                                            padding: EdgeInsets.all(6.0),
                                            constraints: BoxConstraints(),
                                            onPressed: () async {

                                              if(isSevMes == false){
                                                setState(() {
                                                  isSevMes = true;
                                                });
                                              }else{
                                                setState(() {
                                                  isSevMes = false;
                                                });
                                              }


                                            },

                                            icon: Icon(
                                              Icons.filter_list_alt,
                                              size: 0,
                                              color: Colors.white,
                                            )
                                        ),


                                          IconButton(
                                              padding: EdgeInsets.all(6.0),
                                              constraints: BoxConstraints(),
                                                onPressed: () async {
                                                  await _renderPDF(_cartesianChartOne, 'IndiceSev', '$dropdownValue', 'Indicadores de Severidad');
                                                },
                                                icon: Icon(
                                                  Icons.picture_as_pdf,
                                                  size: 20,
                                                  color: Colors.white,
                                                )
                                            ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              color: Colors.white12,
                              border: Border.all(
                                width: 0.1, //
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [




                                Visibility(
                                  visible: true,
                                  child: Container(
                                    height: 400,
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    child: StatefulBuilder(

                                        builder: (context, setState) {
                                          return SfCartesianChart(
                                              primaryYAxis: NumericAxis(
                                                  numberFormat: format,

                                                // axis interval is set to 10
                                                  interval: 10),
                                              primaryXAxis: CategoryAxis(
                                                labelIntersectAction:
                                                AxisLabelIntersectAction.rotate45,
                                                isVisible: true,
                                                interval: 1,
                                                labelStyle: TextStyle(fontSize: 9),),
                                              enableAxisAnimation: true,
                                              legend: Legend(isVisible: true),
                                              title: ChartTitle(
                                                  text:
                                                  'Índice de Severidad',
                                                  textStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500)),
                                              key: _cartesianChartOne,
                                              series: <CartesianSeries<ChartDataSeveridad, String>>[
                                                LineSeries<ChartDataSeveridad, String>(
                                                  name: 'SR',
                                                  animationDelay: 500,
                                                  animationDuration: 1500,
                                                  dataSource: _chartDataSeveridad, // List<ChartDataSeveridad>
                                                  xValueMapper: (d, _) => d.x,
                                                  yValueMapper: (d, _) => d.y1,
                                                  dataLabelSettings: const DataLabelSettings(
                                                    isVisible: true,
                                                    textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF505154)),
                                                  ),
                                                  markerSettings: const MarkerSettings(isVisible: true),
                                                ),
                                              ]

                                          );

                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),

            //Frecuencia MTI
            Visibility(
              visible: indVisibility,
              child: Container(
                color: Color(0xffEBEFFB),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                  color: Color(0xff008A8A),
                                ),
                                width: MediaQuery.of(context).size.width * 0.98,
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.label_important,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Índice de Frecuencias",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        IconButton(
                                            padding: EdgeInsets.all(6.0),
                                            constraints: BoxConstraints(),
                                            onPressed: () async {

                                              if(isFrecMes == false){
                                                setState(() {
                                                  isFrecMes = true;
                                                });
                                              }else{
                                                setState(() {
                                                  isFrecMes = false;
                                                });
                                              }


                                            },
                                            icon: Icon(
                                              Icons.filter_list_alt,
                                              size: 0,
                                              color: Colors.white,
                                            )
                                        ),


                                        IconButton(
                                            padding: EdgeInsets.all(6.0),
                                            constraints: BoxConstraints(),
                                            onPressed: () async {

                                              if(trat_medico == true){
                                                await _renderPDF(_cartesianChartTwo, 'Ind_TratMedico', '$dropdownValue', 'Índice de Frecuencia de Lesiones con Tratamiento Médico');
                                              }else if (tiempo_perd == true){
                                                await _renderPDF(_cartesianChartThree, 'Ind_Tiempo', '$dropdownValue', 'Indice de Frecuencia de Lesiones con Tiempo Perdido');
                                              } else if (primeros_aux == true){
                                                await _renderPDF(_cartesianChartFour, 'Ind_PrimAux', '$dropdownValue', 'Indice de Frecuencia de Lesiones con Primeros Auxilios');
                                              }


                                            },
                                            icon: Icon(
                                              Icons.picture_as_pdf,
                                              size: 20,
                                              color: Colors.white,
                                            )
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width*0.98,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              color: Colors.white12,
                              border: Border.all(
                                width: 0.1, //
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [



                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),

                                      child: InkWell(
                                        onTap: (){

                                          setState((){
                                            trat_medico = true;
                                            tiempo_perd = false;
                                            primeros_aux = false;
                                            pushButtonMed = Colors.teal;
                                            pushButtonAux = Color(0xFF5283B0);
                                            pushButtonTiempo = Color(0xFF5283B0);
                                          });
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*0.30,
                                          decoration: BoxDecoration(                color: pushButtonMed,     borderRadius: BorderRadius.circular(10.0) ),

                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.show_chart, color: Colors.white, size: 16,),
                                                SizedBox(width: 5,),
                                                Text("Trat. Médico.", style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: Colors.white),)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                    ),



                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),

                                      child: InkWell(
                                        onTap: (){

                                          setState((){
                                            trat_medico = false;
                                            tiempo_perd = true;
                                            primeros_aux = false;
                                            pushButtonMed = Color(0xFF5283B0);
                                            pushButtonAux = Color(0xFF5283B0);
                                            pushButtonTiempo = Colors.teal;


                                          });

                                        },
                                        child: Container(
                                  width: MediaQuery.of(context).size.width*0.30,
                                          decoration: BoxDecoration(                color: pushButtonTiempo,     borderRadius: BorderRadius.circular(10.0) ),

                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                               Icon(Icons.show_chart, color: Colors.white, size: 16),
                                                SizedBox(width: 5,),
                                                Text("Tiempo Perd.", style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: Colors.white),)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                  ),

                                    Padding(
                                      padding: const EdgeInsets.all(4.0),

                                      child: InkWell(
                                        onTap: (){

                                          setState((){
                                            trat_medico = false;
                                            tiempo_perd = false;
                                            primeros_aux = true;

                                            pushButtonMed = Color(0xFF5283B0);
                                            pushButtonAux = Colors.teal;
                                            pushButtonTiempo =Color(0xFF5283B0);

                                          });

                                        },
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*0.30,
                                          decoration: BoxDecoration(                color: pushButtonAux,     borderRadius: BorderRadius.circular(10.0) ),

                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.show_chart, color: Colors.white, size: 16,),
                                                SizedBox(width: 5,),
                                                Text("Primeros Aux.", style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: Colors.white),)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                    ),
                                ],
                                ),




                                //MTI --- tratamiento_medico
                                Visibility(
                                  visible: trat_medico,
                                  child: Container(
                                    height: 400,
                                    width: MediaQuery.of(context).size.width *
                                        0.98,
                                    child: StatefulBuilder(

                                        builder: (context, setState) {
                                          return SfCartesianChart(
                                              primaryYAxis: NumericAxis(
                                                  numberFormat: format,
                                                // axis interval is set to 10
                                                  interval: 1),
                                              primaryXAxis: CategoryAxis(
                                                labelIntersectAction:
                                                AxisLabelIntersectAction.rotate45,
                                                isVisible: true,
                                                interval: 1,
                                                labelStyle: TextStyle(fontSize: 9),),
                                              enableAxisAnimation: true,
                                              legend: Legend(isVisible: true),
                                              title: ChartTitle(
                                                  text:
                                                  'Índice de Frecuencia de Lesiones con Tratamiento Médico',
                                                  textStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500)),



                                              key: _cartesianChartTwo,
                                              series: <CartesianSeries<ChartDataFrecuenciaMTI, String>>[
                                                LineSeries<ChartDataFrecuenciaMTI, String>(
                                                  name: 'MTIFR',
                                                  animationDelay: 500,
                                                  animationDuration: 1500,
                                                  dataSource: _chartDataFrecuenciaMTI, // List<ChartDataFrecuenciaMTI>
                                                  xValueMapper: (d, _) => d.x,
                                                  yValueMapper: (d, _) => d.y1,
                                                  dataLabelSettings: const DataLabelSettings(
                                                    isVisible: true,
                                                    textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF505154)),
                                                  ),
                                                  markerSettings: const MarkerSettings(isVisible: true),
                                                ),
                                              ]

                                          );

                                        }),
                                  ),
                                ),

                                //FAI -- primeros auz
                                Visibility(
                                  visible: primeros_aux,
                                  child: Container(
                                    height: 400,
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    child: StatefulBuilder(

                                        builder: (context, setState) {
                                          return SfCartesianChart(
                                              primaryYAxis: NumericAxis(
                                                  numberFormat: format,
                                                  // axis interval is set to 10
                                                  interval: 1),
                                              primaryXAxis: CategoryAxis(
                                                labelIntersectAction:
                                                AxisLabelIntersectAction.rotate45,
                                                isVisible: true,
                                                interval: 1,
                                                labelStyle: TextStyle(fontSize: 9),),
                                              enableAxisAnimation: true,
                                              legend: Legend(isVisible: true),
                                              title: ChartTitle(
                                                  text:
                                                  'Indice de Frecuencia de Lesiones con Primeros Auxilios',
                                                  textStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500)),
                                              key: _cartesianChartFour,
                                              series: <CartesianSeries<ChartDataFrecuenciaFAI, String>>[
                                                LineSeries<ChartDataFrecuenciaFAI, String>(
                                                  name: 'FAIFR',
                                                  animationDelay: 500,
                                                  animationDuration: 2000,
                                                  dataSource: _chartDataFrecuenciaFAI, // List<ChartDataFrecuenciaFAI>
                                                  xValueMapper: (d, _) => d.x,
                                                  yValueMapper: (d, _) => d.y1,
                                                  dataLabelSettings: const DataLabelSettings(
                                                    isVisible: true,
                                                    textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF505154)),
                                                  ),
                                                  markerSettings: const MarkerSettings(isVisible: true),
                                                ),
                                              ]

                                          );

                                        }),
                                  ),
                                ),

                                //LTI -- tiempo perd
                                Visibility(
                                  visible: tiempo_perd,
                                  child: Container(
                                    height: 400,
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    child: StatefulBuilder(
                                        builder: (context, setState) {
                                          return SfCartesianChart(
                                              primaryYAxis: NumericAxis(
                                                  numberFormat: format,
                                                  // axis interval is set to 10
                                                  interval: 1),
                                              primaryXAxis: CategoryAxis(
                                                labelIntersectAction:
                                                AxisLabelIntersectAction.rotate45,
                                                isVisible: true,
                                                interval: 1,
                                                labelStyle: TextStyle(fontSize: 9),),
                                              enableAxisAnimation: true,
                                              legend: Legend(isVisible: true),
                                              title: ChartTitle(
                                                  text:
                                                  'Indice de Frecuencia de Lesiones con Tiempo Perdido',
                                                  textStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500)),
                                              key: _cartesianChartThree,
                                              series: <CartesianSeries<ChartDataFrecuenciaLTI, String>>[
                                                LineSeries<ChartDataFrecuenciaLTI, String>(
                                                  name: 'LTIFR',
                                                  animationDelay: 500,
                                                  animationDuration: 2000,
                                                  dataSource: _chartDataFrecuenciaLTI, // List<ChartDataFrecuenciaLTI>
                                                  xValueMapper: (d, _) => d.x,
                                                  yValueMapper: (d, _) => d.y1,
                                                  dataLabelSettings: const DataLabelSettings(
                                                    isVisible: true,
                                                    textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                                                  ),
                                                  markerSettings: const MarkerSettings(isVisible: true),
                                                ),
                                              ]

                                          );

                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Frecuencia LTI

            //Frecuencia FAI
          ],
        ),
      ),
    );
  }

  //Incidentes Mensuales de Seguridad
  Future <List<void>> RequestDataIncSeguridad (String anho) async {

    final user = await authController.getUserFromStorage();


    String? ambito;
    if(dropdownValueAmb == 'Todos'){
      ambito = '0';
    }else if(dropdownValueAmb == 'Titular'){
      ambito = '1';
    }else if(dropdownValueAmb == 'Contratista'){
    ambito = '3';
    }

    var url = '${user!.urlApp}/ws/null/pr_subtipo_incidente_mensual?Anno=$anho&fb_uea_pe_id=${widget.sede}&g_rol_empresa_id=$ambito';
    var datos = [];
    var response = await http.post(Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
      },
    );

    print("${response.statusCode}");
    datos = json.decode(response.body)['data'];
    final result =
    (datos.map((e) => incidentes_seguridad_model.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createIncidentesSeguridad(emp);
    }).toList();

    Future.delayed(const Duration(milliseconds: 800), () async {
      List<Map> responseReadSeg = await sqlDb.readData(""
          "SELECT * FROM IncidentesSeguridad");
      print("Tabla seguridad $responseReadSeg");


      if(responseReadSeg.length == 1 ){


        IncSegY1[0] =  responseReadSeg[0]['Enero'] ?? 0;
        IncSegY1[1] =  responseReadSeg[0]['Febrero'] ?? 0;
        IncSegY1[2] =  responseReadSeg[0]['Marzo'] ?? 0;
        IncSegY1[3] =  responseReadSeg[0]['Abril'] ?? 0;
        IncSegY1[4] =  responseReadSeg[0]['Mayo'] ?? 0;
        IncSegY1[5] =  responseReadSeg[0]['Junio'] ?? 0;
        IncSegY1[6] =  responseReadSeg[0]['Julio'] ?? 0;
        IncSegY1[7] =  responseReadSeg[0]['Agosto'] ?? 0;
        IncSegY1[8] =  responseReadSeg[0]['Septiembre'] ?? 0;
        IncSegY1[9] =  responseReadSeg[0]['Octubre'] ?? 0;
        IncSegY1[10] =  responseReadSeg[0]['Noviembre'] ?? 0;
        IncSegY1[11] =  responseReadSeg[0]['Diciembre'] ?? 0;

        //Colocar 0 a las demas columnas
      for(int i=0; i<12; i++){

        IncSegY2[i] = 0;
        IncSegY3[i] = 0;
        IncSegY4[i] = 0;
      }

      print("length response (resp only 1)--- ${responseReadSeg.length}");
      setState(() {});

      }else{

        IncSegY1[0] =  responseReadSeg[0]['Enero'] ?? 0;
        IncSegY1[1] =  responseReadSeg[0]['Febrero'] ?? 0;
        IncSegY1[2] =  responseReadSeg[0]['Marzo'] ?? 0;
        IncSegY1[3] =  responseReadSeg[0]['Abril'] ?? 0;
        IncSegY1[4] =  responseReadSeg[0]['Mayo'] ?? 0;
        IncSegY1[5] =  responseReadSeg[0]['Junio'] ?? 0;
        IncSegY1[6] =  responseReadSeg[0]['Julio'] ?? 0;
        IncSegY1[7] =  responseReadSeg[0]['Agosto'] ?? 0;
        IncSegY1[8] =  responseReadSeg[0]['Septiembre'] ?? 0;
        IncSegY1[9] =  responseReadSeg[0]['Octubre'] ?? 0;
        IncSegY1[10] =  responseReadSeg[0]['Noviembre'] ?? 0;
        IncSegY1[11] =  responseReadSeg[0]['Diciembre'] ?? 0;

        IncSegY2[0] =  responseReadSeg[1]['Enero']  ?? 0;
        IncSegY2[1] =  responseReadSeg[1]['Febrero'] ?? 0;
        IncSegY2[2] =  responseReadSeg[1]['Marzo'] ?? 0;
        IncSegY2[3] =  responseReadSeg[1]['Abril'] ?? 0;
        IncSegY2[4] =  responseReadSeg[1]['Mayo'] ?? 0;
        IncSegY2[5] =  responseReadSeg[1]['Junio'] ?? 0;
        IncSegY2[6] =  responseReadSeg[1]['Julio'] ?? 0;
        IncSegY2[7] =  responseReadSeg[1]['Agosto'] ?? 0;
        IncSegY2[8] =  responseReadSeg[1]['Septiembre'] ?? 0;
        IncSegY2[9] =  responseReadSeg[1]['Octubre'] ?? 0;
        IncSegY2[10] =  responseReadSeg[1]['Noviembre'] ?? 0;
        IncSegY2[11] =  responseReadSeg[1]['Diciembre'] ?? 0;
        //"Lesión con Tratamiento Médico (MTI)",
        IncSegY3[0] =  responseReadSeg[2]['Enero'] ?? 0;
        IncSegY3[1] =  responseReadSeg[2]['Febrero'] ?? 0;
        IncSegY3[2] =  responseReadSeg[2]['Marzo'] ?? 0;
        IncSegY3[3] =  responseReadSeg[2]['Abril'] ?? 0;
        IncSegY3[4] =  responseReadSeg[2]['Mayo'] ?? 0;
        IncSegY3[5] =  responseReadSeg[2]['Junio'] ?? 0;
        IncSegY3[6] =  responseReadSeg[2]['Julio'] ?? 0;
        IncSegY3[7] =  responseReadSeg[2]['Agosto'] ?? 0;
        IncSegY3[8] =  responseReadSeg[2]['Septiembre'] ?? 0;
        IncSegY3[9] =  responseReadSeg[2]['Octubre'] ?? 0;
        IncSegY3[10] =  responseReadSeg[2]['Noviembre'] ?? 0;
        IncSegY3[11] =  responseReadSeg[2]['Diciembre'] ?? 0;

        //"Near Miss (NM)",
        IncSegY4[0] =  responseReadSeg[3]['Enero'] ?? 0;
        IncSegY4[1] =  responseReadSeg[3]['Febrero'] ?? 0;
        IncSegY4[2] =  responseReadSeg[3]['Marzo'] ?? 0;
        IncSegY4[3] =  responseReadSeg[3]['Abril'] ?? 0;
        IncSegY4[4] =  responseReadSeg[3]['Mayo'] ?? 0;
        IncSegY4[5] =  responseReadSeg[3]['Junio'] ?? 0;
        IncSegY4[6] =  responseReadSeg[3]['Julio'] ?? 0;
        IncSegY4[7] =  responseReadSeg[3]['Agosto'] ?? 0;
        IncSegY4[8] =  responseReadSeg[3]['Septiembre'] ?? 0;
        IncSegY4[9] =  responseReadSeg[3]['Octubre'] ?? 0;
        IncSegY4[10] =  responseReadSeg[3]['Noviembre'] ?? 0;
        IncSegY4[11] =  responseReadSeg[3]['Diciembre'] ?? 0;

      setState(() {});

      }

    });

    return result;

  }

  //Horas trabajadas

  Future <List<void>> RequestDataHorasTrabajadas (String anho) async {

    final user = await authController.getUserFromStorage();


    var url = '${user!.urlApp}/ws/null/pr_gaf_inc_horas_mensual_por_rol?Anno=$anho&fb_uea=${widget.sede}';
    var mapIncGen = Map<String, dynamic>();
    var datos = [];
    var response = await http.post(Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
      },
    );

    print("${response.statusCode}");
    datos = json.decode(response.body)['data'];
    final result =
    (datos.map((e) => horas_trabajadas_mes_model.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createHorasTrabajadas(emp);
    }).toList();

    Future.delayed(const Duration(milliseconds: 500), () async {

      List<Map> responseReadSeg = await sqlDb.readData(""
          "SELECT * FROM IncidentesSeguridad");
      print("Tabla seguridad $responseReadSeg");


      List<Map> responseReadHor = await sqlDb.readData(""
          "SELECT * FROM HorasTrabajadas");
      print("Tabla horasTrabajadas $responseReadHor");


      if(responseReadHor.length == 1){
        HorasTrabY1[0] =  responseReadHor[0]['Enero'] ?? 0;
        HorasTrabY1[1] =  responseReadHor[0]['Febrero'] ?? 0;
        HorasTrabY1[2] =  responseReadHor[0]['Marzo'] ?? 0;
        HorasTrabY1[3] =  responseReadHor[0]['Abril'] ?? 0;
        HorasTrabY1[4] =  responseReadHor[0]['Mayo'] ?? 0;
        HorasTrabY1[5] =  responseReadHor[0]['Junio'] ?? 0;
        HorasTrabY1[6] =  responseReadHor[0]['Julio'] ?? 0;
        HorasTrabY1[7] =  responseReadHor[0]['Agosto'] ?? 0;
        HorasTrabY1[8] =  responseReadHor[0]['Setiembre'] ?? 0;
        HorasTrabY1[9] =  responseReadHor[0]['Octubre'] ?? 0;
        HorasTrabY1[10] =  responseReadHor[0]['Noviembre'] ?? 0;
        HorasTrabY1[11] =  responseReadHor[0]['Diciembre'] ?? 0;

        for(int i=0; i<12; i++){

          HorasTrabY2[i] = 0;

        }

        setState(() {});
      }else{
        HorasTrabY1[0] =  responseReadHor[0]['Enero'] ?? 0;
        HorasTrabY1[1] =  responseReadHor[0]['Febrero'] ?? 0;
        HorasTrabY1[2] =  responseReadHor[0]['Marzo'] ?? 0;
        HorasTrabY1[3] =  responseReadHor[0]['Abril'] ?? 0;
        HorasTrabY1[4] =  responseReadHor[0]['Mayo'] ?? 0;
        HorasTrabY1[5] =  responseReadHor[0]['Junio'] ?? 0;
        HorasTrabY1[6] =  responseReadHor[0]['Julio'] ?? 0;
        HorasTrabY1[7] =  responseReadHor[0]['Agosto'] ?? 0;
        HorasTrabY1[8] =  responseReadHor[0]['Setiembre'] ?? 0;
        HorasTrabY1[9] =  responseReadHor[0]['Octubre'] ?? 0;
        HorasTrabY1[10] =  responseReadHor[0]['Noviembre'] ?? 0;
        HorasTrabY1[11] =  responseReadHor[0]['Diciembre'] ?? 0;


        HorasTrabY2[0] =  responseReadHor[1]['Enero'] ?? 0;
        HorasTrabY2[1] =  responseReadHor[1]['Febrero'] ?? 0;
        HorasTrabY2[2] =  responseReadHor[1]['Marzo'] ?? 0;
        HorasTrabY2[3] =  responseReadHor[1]['Abril'] ?? 0;
        HorasTrabY2[4] =  responseReadHor[1]['Mayo'] ?? 0;
        HorasTrabY2[5] =  responseReadHor[1]['Junio'] ?? 0;
        HorasTrabY2[6] =  responseReadHor[1]['Julio'] ?? 0;
        HorasTrabY2[7] =  responseReadHor[1]['Agosto'] ?? 0;
        HorasTrabY2[8] =  responseReadHor[1]['Setiembre'] ?? 0;
        HorasTrabY2[9] =  responseReadHor[1]['Octubre'] ?? 0;
        HorasTrabY2[10] =  responseReadHor[1]['Noviembre'] ?? 0;
        HorasTrabY2[11] =  responseReadHor[1]['Diciembre'] ?? 0;


        setState(() {});
      }


    });







    return result;
  }



  //Frecuencia Lesiones tratamiento medico
  Future <List<void>> RequestDataIndFrecuenciaMTI(String anho) async {

    String? ambito;
    if(dropdownValueAmb == 'Todos'){
      ambito = '0';
    }else if(dropdownValueAmb == 'Titular'){
      ambito = '1';
    }else if(dropdownValueAmb == 'Contratista'){
      ambito = '3';
    }

    String? mes;
    if(dropdownValueMes == 'Enero'){mes = '1';}
    else if(dropdownValueMes == 'Febrero'){mes = '2';}
    else     if(dropdownValueMes == 'Marzo'){mes = '3';}
    else     if(dropdownValueMes == 'Abril'){mes = '4';}
    else     if(dropdownValueMes == 'Mayo'){mes = '5';}
    else     if(dropdownValueMes == 'Junio'){mes = '6';}
    else     if(dropdownValueMes == 'Julio'){mes = '7';}
    else     if(dropdownValueMes == 'Agosto'){mes = '8';}
    else     if(dropdownValueMes == 'Setiembre'){mes = '9';}
    else     if(dropdownValueMes == 'Octubre'){mes = '10';}
    else     if(dropdownValueMes == 'Noviembre'){mes = '11';}
    else     if(dropdownValueMes == 'Diciembre'){mes = '12';}

    final user = await authController.getUserFromStorage();



    var url = '${user!.urlApp}/ws/null/pr_subtipo_incidente_mensual_MTI_v2?uea=${widget.sede}&mes=$mes&anho=$anho&g_rol_empresa_id=$ambito';
    var mapIncGen = Map<String, dynamic>();
    var datos = [];
    var response = await http.post(Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
      },
    );
    print("${response.statusCode}");
    datos = json.decode(response.body)['data'];
    final result =
    (datos.map((e) => frecuencia_mti_model.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createIndiceFrecuenciaMTI(emp);
    }).toList();

    //MTI
    //Eje Y
    //FrecuenciaMTI
    Future.delayed(const Duration(milliseconds: 800), () async {

    List<Map> responseReadMTI = await sqlDb.readData(""
        "SELECT * FROM frecuenciaMTI");
    print("Tabla frecuencia MTI -- $responseReadMTI");
    //Eje X

    FrecuenciaMTIY1[0]  = responseReadMTI[0]['indicador'] ?? 0.0;
    FrecuenciaMTIY1[1]  = responseReadMTI[1]['indicador'] ?? 0.0;
    FrecuenciaMTIY1[2]  = responseReadMTI[2]['indicador'] ?? 0.0;
    FrecuenciaMTIY1[3]  = responseReadMTI[3]['indicador'] ?? 0.0;
    FrecuenciaMTIY1[4]  = responseReadMTI[4]['indicador'] ?? 0.0;
    FrecuenciaMTIY1[5]  = responseReadMTI[5]['indicador'] ?? 0.0;
    FrecuenciaMTIY1[6]  = responseReadMTI[6]['indicador'] ?? 0.0;
    FrecuenciaMTIY1[7]  = responseReadMTI[7]['indicador'] ?? 0.0;
    FrecuenciaMTIY1[8]  = responseReadMTI[8]['indicador'] ?? 0.0;
    FrecuenciaMTIY1[9]  = responseReadMTI[9]['indicador'] ?? 0.0;
    FrecuenciaMTIY1[10] = responseReadMTI[10]['indicador'] ?? 0.0;
    FrecuenciaMTIY1[11] = responseReadMTI[11]['indicador'] ?? 0.0;
    setState(() {});
    });

    return result;
  }




  //Frecuencia LTI
  Future <List<void>> RequestDataIndFrecuenciaLTI(String anho) async {


    String? ambito;
    if(dropdownValueAmb == 'Todos'){
      ambito = '0';
    }else if(dropdownValueAmb == 'Titular'){
      ambito = '1';
    }else if(dropdownValueAmb == 'Contratista'){
      ambito = '3';
    }


    String? mes;
    if(dropdownValueMes == 'Enero'){mes = '1';}
    else if(dropdownValueMes == 'Febrero'){mes = '2';}
    else     if(dropdownValueMes == 'Marzo'){mes = '3';}
    else     if(dropdownValueMes == 'Abril'){mes = '4';}
    else     if(dropdownValueMes == 'Mayo'){mes = '5';}
    else     if(dropdownValueMes == 'Junio'){mes = '6';}
    else     if(dropdownValueMes == 'Julio'){mes = '7';}
    else     if(dropdownValueMes == 'Agosto'){mes = '8';}
    else     if(dropdownValueMes == 'Setiembre'){mes = '9';}
    else     if(dropdownValueMes == 'Octubre'){mes = '10';}
    else     if(dropdownValueMes == 'Noviembre'){mes = '11';}
    else     if(dropdownValueMes == 'Diciembre'){mes = '12';}


    final user = await authController.getUserFromStorage();



    var url = '${user!.urlApp}/ws/null/pr_subtipo_incidente_mensual_LTI_v2?uea=${widget.sede}&mes=$mes&anho=$anho&g_rol_empresa_id=$ambito';
    var mapIncGen = Map<String, dynamic>();
    var datos = [];
    var response = await http.post(Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
      },
    );

    print("${response.statusCode}");
    datos = json.decode(response.body)['data'];
    final result =
    (datos.map((e) => frecuencia_lti_model.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createIndiceFrecuenciaLTI(emp);
    }).toList();
    Future.delayed(const Duration(milliseconds: 800), () async {
    //Frecuencia LTI
    List<Map> responseReadLTI = await sqlDb.readData(""
        "SELECT * FROM frecuenciaLTI");
    print("Tabla frecuencia LTI -- $responseReadLTI");

    FrecuenciaLTIY1[0]  = responseReadLTI[0]['indicador'] ?? 0.0;
    FrecuenciaLTIY1[1]  = responseReadLTI[1]['indicador'] ?? 0.0;
    FrecuenciaLTIY1[2]  = responseReadLTI[2]['indicador'] ?? 0.0;
    FrecuenciaLTIY1[3]  = responseReadLTI[3]['indicador'] ?? 0.0;
    FrecuenciaLTIY1[4]  = responseReadLTI[4]['indicador'] ?? 0.0;
    FrecuenciaLTIY1[5]  = responseReadLTI[5]['indicador'] ?? 0.0;
    FrecuenciaLTIY1[6]  = responseReadLTI[6]['indicador'] ?? 0.0;
    FrecuenciaLTIY1[7]  = responseReadLTI[7]['indicador'] ?? 0.0;
    FrecuenciaLTIY1[8]  = responseReadLTI[8]['indicador'] ?? 0.0;
    FrecuenciaLTIY1[9]  = responseReadLTI[9]['indicador'] ?? 0.0;
    FrecuenciaLTIY1[10] = responseReadLTI[10]['indicador'] ?? 0.0;
    FrecuenciaLTIY1[11] = responseReadLTI[11]['indicador'] ?? 0.0;
    setState(() {});
    });





    return result;
  }

  //Frecuencia FAI
  Future <List<void>> RequestDataIndFrecuenciaFAI(String anho) async {

    final user = await authController.getUserFromStorage();



    String? ambito;
    if(dropdownValueAmb == 'Todos'){
      ambito = '0';
    }else if(dropdownValueAmb == 'Titular'){
      ambito = '1';
    }else if(dropdownValueAmb == 'Contratista'){
      ambito = '3';
    }


    String? mes;
    if(dropdownValueMes == 'Enero'){mes = '1';}
    else if(dropdownValueMes == 'Febrero'){mes = '2';}
    else     if(dropdownValueMes == 'Marzo'){mes = '3';}
    else     if(dropdownValueMes == 'Abril'){mes = '4';}
    else     if(dropdownValueMes == 'Mayo'){mes = '5';}
    else     if(dropdownValueMes == 'Junio'){mes = '6';}
    else     if(dropdownValueMes == 'Julio'){mes = '7';}
    else     if(dropdownValueMes == 'Agosto'){mes = '8';}
    else     if(dropdownValueMes == 'Setiembre'){mes = '9';}
    else     if(dropdownValueMes == 'Octubre'){mes = '10';}
    else     if(dropdownValueMes == 'Noviembre'){mes = '11';}
    else     if(dropdownValueMes == 'Diciembre'){mes = '12';}

    var url = '${user!.urlApp}/ws/null/pr_subtipo_incidente_mensual_FAI_v2?uea=${widget.sede}&mes=$mes&anho=$anho&g_rol_empresa_id=$ambito';
    var mapIncGen = Map<String, dynamic>();
    var datos = [];
    var response = await http.post(Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
      },
    );
    print("${response.statusCode}");
    datos = json.decode(response.body)['data'];
    final result =
    (datos.map((e) => frecuencia_fai_model.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createIndiceFrecuenciaFAI(emp);
    }).toList();


 //Primeros Aux
    Future.delayed(const Duration(milliseconds: 800), () async {
    List<Map> responseReadFAI = await sqlDb.readData(""
        "SELECT * FROM frecuenciaFAI");
    print("Tabla frecuencia FAI -- $responseReadFAI");

    FrecuenciaFAIY1[0]  = responseReadFAI[0]['indicador'] ?? 0.0;
    FrecuenciaFAIY1[1]  = responseReadFAI[1]['indicador'] ?? 0.0;
    FrecuenciaFAIY1[2]  = responseReadFAI[2]['indicador'] ?? 0.0;
    FrecuenciaFAIY1[3]  = responseReadFAI[3]['indicador'] ?? 0.0;
    FrecuenciaFAIY1[4]  = responseReadFAI[4]['indicador'] ?? 0.0;
    FrecuenciaFAIY1[5]  = responseReadFAI[5]['indicador'] ?? 0.0;
    FrecuenciaFAIY1[6]  = responseReadFAI[6]['indicador'] ?? 0.0;
    FrecuenciaFAIY1[7]  = responseReadFAI[7]['indicador'] ?? 0.0;
    FrecuenciaFAIY1[8]  = responseReadFAI[8]['indicador'] ?? 0.0;
    FrecuenciaFAIY1[9]  = responseReadFAI[9]['indicador'] ?? 0.0;
    FrecuenciaFAIY1[10] = responseReadFAI[10]['indicador'] ?? 0.0;
    FrecuenciaFAIY1[11] = responseReadFAI[11]['indicador'] ?? 0.0;
    setState(() {});
    });
    return result;
  }


  //=====SEVERIDAD
  Future <List<void>> RequestDataIndSeveridad(String anho) async {

    final user = await authController.getUserFromStorage();


    String? ambito;
    if(dropdownValueAmb == 'Todos'){
      ambito = '0';
    }else if(dropdownValueAmb == 'Titular'){
      ambito = '1';
    }else if(dropdownValueAmb == 'Contratista'){
      ambito = '3';
    }


    String? mes;
    if(dropdownValueMes == 'Enero'){mes = '1';}
    else if(dropdownValueMes == 'Febrero'){mes = '2';}
    else     if(dropdownValueMes == 'Marzo'){mes = '3';}
    else     if(dropdownValueMes == 'Abril'){mes = '4';}
    else     if(dropdownValueMes == 'Mayo'){mes = '5';}
    else     if(dropdownValueMes == 'Junio'){mes = '6';}
    else     if(dropdownValueMes == 'Julio'){mes = '7';}
    else     if(dropdownValueMes == 'Agosto'){mes = '8';}
    else     if(dropdownValueMes == 'Setiembre'){mes = '9';}
    else     if(dropdownValueMes == 'Octubre'){mes = '10';}
    else     if(dropdownValueMes == 'Noviembre'){mes = '11';}
    else     if(dropdownValueMes == 'Diciembre'){mes = '12';}

    var url = '${user!.urlApp}/ws/null/pr_graf_indice_dias_perdidos_subtipo_v2?uea=${widget.sede}&mes=$mes&anho=$anho&g_rol_empresa_id=$ambito';
    var mapIncGen = Map<String, dynamic>();
    var datos = [];
    var response = await http.post(Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
      },
    );

    print("${response.statusCode}");
    datos = json.decode(response.body)['data'];
    final result =
    (datos.map((e) => severidad_model.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createIndiceSeveridad(emp);
    }).toList();

    Future.delayed(const Duration(milliseconds: 800), () async {

      List<Map> responseReadS = await sqlDb.readData(""
          "SELECT * FROM IndiceSeveridad");
      print("Tabla severidad $responseReadS");

      SeveridadX[0] =  responseReadS[0]['nombre'] ?? 0;
      SeveridadX[1] =  responseReadS[1]['nombre'] ?? 0;
      SeveridadX[2] =  responseReadS[2]['nombre'] ?? 0;
      SeveridadX[3] =  responseReadS[3]['nombre'] ?? 0;
      SeveridadX[4] =  responseReadS[4]['nombre'] ?? 0;
      SeveridadX[5] =  responseReadS[5]['nombre'] ?? 0;
      SeveridadX[6] =  responseReadS[6]['nombre'] ?? 0;
      SeveridadX[7] =  responseReadS[7]['nombre'] ?? 0;
      SeveridadX[8] =  responseReadS[8]['nombre'] ?? 0;
      SeveridadX[9] =  responseReadS[9]['nombre'] ?? 0;
      SeveridadX[10] =  responseReadS[10]['nombre'] ?? 0;
      SeveridadX[11] =  responseReadS[11]['nombre'] ?? 0;
      //Eje Y

      SeveridadY1[0]  =  responseReadS[0]['indicador'] ?? 0.0;
      SeveridadY1[1]  =  responseReadS[1]['indicador'] ?? 0.0;
      SeveridadY1[2]  =  responseReadS[2]['indicador'] ?? 0.0;
      SeveridadY1[3]  =  responseReadS[3]['indicador'] ?? 0.0;
      SeveridadY1[4]  =  responseReadS[4]['indicador'] ?? 0.0;
      SeveridadY1[5]  =  responseReadS[5]['indicador'] ?? 0.0;
      SeveridadY1[6]  =  responseReadS[6]['indicador'] ?? 0.0;
      SeveridadY1[7]  =  responseReadS[7]['indicador'] ?? 0.0;
      SeveridadY1[8]  =  responseReadS[8]['indicador'] ?? 0.0;
      SeveridadY1[9]  =  responseReadS[9]['indicador'] ?? 0.0;
      SeveridadY1[10] =  responseReadS[10]['indicador'] ?? 0.0;
      SeveridadY1[11] =  responseReadS[11]['indicador'] ?? 0.0;

      setState(() {});

    });
    return result;
  }




  //Exportamos a PDF
  Future<void> _renderPDF(GlobalKey<SfCartesianChartState> cartesianChart, String tipo, String anho, String nombre) async {
    //Get external storage directory
    final Directory directory = await getApplicationSupportDirectory();
    //Get directory path
    final String path = directory.path;

    final List<int> imageBytes = await _readImageData(cartesianChart);
    final PdfBitmap bitmap = PdfBitmap(imageBytes);
    final PdfDocument document = PdfDocument();


    //===Agregar texto al PDF
    // final Uint8List fontData = File('../assets/fonts/roboto/Roboto-Regular.ttf').readAsBytesSync();
    //   final PdfFont font = PdfTrueTypeFont(fontData, 12);
    //
    document.pageSettings.size =
        Size(bitmap.width.toDouble(), bitmap.height.toDouble());
    final PdfPage page = document.pages.add();

    //  document.pages.add().graphics.drawString('Hello World!!!',PdfStandardFont(PdfFontFamily.helvetica, 12) , bounds: const Rect.fromLTWH(0, 0, 200, 50));

    //===== HEADER
    final PdfPageTemplateElement headerTemplate =
    PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
    final ByteData imageData = await rootBundle.load('assets/images/logo-pdf.png');
    headerTemplate.graphics.drawImage(  PdfBitmap(imageData.buffer.asUint8List()) , const Rect.fromLTWH(0, 0, 130, 25));
    //==== FOOTER
    final PdfPageTemplateElement footerTemplate =
    PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
//Draw text in the footer.
    footerTemplate.graphics.drawString(
        '         $nombre  -  $anho', PdfStandardFont(PdfFontFamily.helvetica, 11),
        brush: PdfSolidBrush(PdfColor(80, 81, 84)),
        bounds: const Rect.fromLTWH(0, 15, 500, 20));
//Set footer in the document.
    document.template.bottom = footerTemplate;


//Draw text in the header.
    /*
 headerTemplate.graphics.drawString(
        'This is page header', PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: const Rect.fromLTWH(0, 15, 200, 20));
        */

//Add the header element to the document.
    document.template.top = headerTemplate;


    final Size pageSize = page.getClientSize();
    page.graphics.drawImage(
        bitmap, Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));
    final List<int> bytes = document.saveSync();
    document.dispose();

    //Create an empty file to write PDF data
    var now = new DateTime.now();
    var formatter =  intl.DateFormat('yyyy-MM-dd');
    String formattedDateAcc = formatter.format(now);

    File file = File('$path/$formattedDateAcc-$tipo.pdf');
    //Write PDF bytes data
    await file.writeAsBytes(bytes, flush: true);

    //Share.shareFiles(['$path/$formattedDateAcc-$tipo.pdf'], text: 'Reporte.pdf', mimeTypes: ['application/pdf'], );
  }

}


Future<List<int>> _readImageData(GlobalKey<SfCartesianChartState> cartesianChart) async {
  final ui.Image? data =
  await cartesianChart.currentState!.toImage(pixelRatio: 1.5);
  final ByteData? bytes =
  await data!.toByteData(format: ui.ImageByteFormat.png);
  return bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
}






//Incidentes Mensuales de Seguridad
class ChartDataIncSeguridad {
  ChartDataIncSeguridad(this.x, this.y1,  this.y2, this.y3, this.y4, this.color);
  final String x;
  final double? y1;
  final double? y2;
  final double? y3;
  final double? y4;
  final Color color;
}

//Horas Trabajadas por mes según Rol de Empresa

class ChartDataHorasTrab {
  ChartDataHorasTrab(this.x, this.y1, this.y2, this.color);
  final String x;
  final double? y1;
  final double? y2;
  final Color color;
}


class ChartDataSeveridad {
  ChartDataSeveridad(this.x, this.y1,   this.color);
  final String x;
  final double? y1;
  final Color color;
}

class ChartDataFrecuencia {
  ChartDataFrecuencia(this.x, this.y1,  this.y2, this.color);
  final String x;
  final double? y1;
  final double? y2;
  final Color color;
}

class ChartDataFrecuenciaMTI {
  ChartDataFrecuenciaMTI(this.x, this.y1 );
  final String x;
  final double? y1;
}


class ChartDataFrecuenciaLTI {
  ChartDataFrecuenciaLTI(this.x, this.y1 );
  final String x;
  final double? y1;
}

class ChartDataFrecuenciaFAI {
  ChartDataFrecuenciaFAI(this.x, this.y1 );
  final String x;
  final double? y1;
}


