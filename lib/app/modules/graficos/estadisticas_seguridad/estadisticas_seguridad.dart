import 'dart:convert';
import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:http/http.dart' as http;
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/inc_mensuales_tipo_model.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/ayc_nivel_riesgo_model.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/entities/plan_accion_model.dart';
import 'package:safe2biz/app/modules/sedes/features/company/presenter/page/company_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:ui' as ui;
import 'dart:typed_data';

String dropdownValue = '2020';


List<int> EntregaTipoy = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];  //Salud
List<int> EntregaTipoy1 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];    //Seguridad


//AYC
List<int> AYCY1 = [0, 0, 9, 0, 0, 5, 0, 0, 0, 0, 0, 0];    //Seguridad
List<int> AYCY2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];  //Salud
List<int> AYCY3 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];  //Sal
List<int> AYCY4 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];  //Sal

//Plan Accion
List<int> PY1 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];   //Ejecutado
List<int> PY2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];  //Pendiente

List <String> PlanX= ["Ene", "Feb", "Mar",    "Abr", "May", "Jun",      "Jul", "Ago", "Set",     "Oct", "Nov", "Dic"];
List <String> EntregaTipox = ["Ene", "Feb", "Mar",    "Abr", "May", "Jun",      "Jul", "Ago", "Set",     "Oct", "Nov", "Dic"];
List <String> AYCX= ["Ene", "Feb", "Mar",    "Abr", "May", "Jun",      "Jul", "Ago", "Set",     "Oct", "Nov", "Dic"];



SqlDb sqlDb = SqlDb();


final localSqliteInstance = LocalSqlite();
final authController = AuthController(sqlite: localSqliteInstance);


class EstadisticaSeguridad extends StatefulWidget {
  final String? sede;
  final List? EntregaTipoy;
  final List? EntregaTipoy1;

  final List? AYCY1;
  final List? AYCY2;
  final List? AYCY3;

  const EstadisticaSeguridad({Key? key, this.sede, this.EntregaTipoy, this.EntregaTipoy1, this.AYCY1, this.AYCY2, this.AYCY3}) : super(key: key);
  @override
  State<EstadisticaSeguridad> createState() => _EstadisticaSeguridadState();
}

class _EstadisticaSeguridadState extends State<EstadisticaSeguridad> {
  //if dropdown null equals 2020
  List<ChartData> _chartDataEntregaTipo = [
    ChartData(EntregaTipox[0], EntregaTipoy[0].toDouble(),
        EntregaTipoy1[0].toDouble(), Colors.teal),
    ChartData(EntregaTipox[1], EntregaTipoy[1].toDouble(),
        EntregaTipoy1[1].toDouble(), Colors.teal),
    ChartData(EntregaTipox[2], EntregaTipoy[2].toDouble(),
        EntregaTipoy1[2].toDouble(), Colors.teal),
    ChartData(EntregaTipox[3], EntregaTipoy[3].toDouble(),
        EntregaTipoy1[3].toDouble(), Colors.teal),
    ChartData(EntregaTipox[4], EntregaTipoy[4].toDouble(),
        EntregaTipoy1[4].toDouble(), Colors.teal),
    ChartData(EntregaTipox[5], EntregaTipoy[5].toDouble(),
        EntregaTipoy1[5].toDouble(), Colors.teal),
    ChartData(EntregaTipox[6], EntregaTipoy[6].toDouble(),
        EntregaTipoy1[6].toDouble(), Colors.teal),
    ChartData(EntregaTipox[7], EntregaTipoy[7].toDouble(),
        EntregaTipoy1[7].toDouble(), Colors.teal),
    ChartData(EntregaTipox[8], EntregaTipoy[8].toDouble(),
        EntregaTipoy1[8].toDouble(), Colors.teal),
    ChartData(EntregaTipox[9], EntregaTipoy[9].toDouble(),
        EntregaTipoy1[9].toDouble(), Colors.teal),
    ChartData(EntregaTipox[10], EntregaTipoy[10].toDouble(),
        EntregaTipoy1[10].toDouble(), Colors.teal),
    ChartData(EntregaTipox[11], EntregaTipoy[11].toDouble(),
        EntregaTipoy1[11].toDouble(), Colors.teal),
  ];


  List<ChartDataAyC> _chartDataNor = [
    ChartDataAyC(
        AYCX[0], AYCY1[0].toDouble(), AYCY2[0].toDouble(), AYCY3[0].toDouble(),
        AYCY4[0].toDouble()),
    ChartDataAyC(
        AYCX[1], AYCY1[1].toDouble(), AYCY2[1].toDouble(), AYCY3[1].toDouble(),
        AYCY4[1].toDouble()),
    ChartDataAyC(
        AYCX[2], AYCY1[2].toDouble(), AYCY2[2].toDouble(), AYCY3[2].toDouble(),
        AYCY4[2].toDouble()),
    ChartDataAyC(
        AYCX[3], AYCY1[3].toDouble(), AYCY2[3].toDouble(), AYCY3[3].toDouble(),
        AYCY4[3].toDouble()),
    ChartDataAyC(
        AYCX[4], AYCY1[4].toDouble(), AYCY2[4].toDouble(), AYCY3[4].toDouble(),
        AYCY4[4].toDouble()),
    ChartDataAyC(
        AYCX[5], AYCY1[5].toDouble(), AYCY2[5].toDouble(), AYCY3[5].toDouble(),
        AYCY4[5].toDouble()),
    ChartDataAyC(
        AYCX[6], AYCY1[6].toDouble(), AYCY2[6].toDouble(), AYCY3[6].toDouble(),
        AYCY4[6].toDouble()),
    ChartDataAyC(
        AYCX[7], AYCY1[7].toDouble(), AYCY2[7].toDouble(), AYCY3[7].toDouble(),
        AYCY4[7].toDouble()),
    ChartDataAyC(
        AYCX[8], AYCY1[8].toDouble(), AYCY2[8].toDouble(), AYCY3[8].toDouble(),
        AYCY4[8].toDouble()),
    ChartDataAyC(
        AYCX[9], AYCY1[9].toDouble(), AYCY2[9].toDouble(), AYCY3[9].toDouble(),
        AYCY4[9].toDouble()),
    ChartDataAyC(AYCX[10], AYCY1[10].toDouble(), AYCY2[10].toDouble(),
        AYCY3[10].toDouble(), AYCY4[10].toDouble()),
    ChartDataAyC(AYCX[11], AYCY1[11].toDouble(), AYCY2[11].toDouble(),
        AYCY3[11].toDouble(), AYCY4[11].toDouble()),
  ];
  List<ChartDataPlan> _chartDataPlan = [
    ChartDataPlan(PlanX[0], PY1[0].toDouble(), PY2[0].toDouble(), Colors.teal),
    ChartDataPlan(PlanX[1], PY1[1].toDouble(), PY2[1].toDouble(), Colors.teal),
    ChartDataPlan(PlanX[2], PY1[2].toDouble(), PY2[2].toDouble(), Colors.teal),
    ChartDataPlan(PlanX[3], PY1[3].toDouble(), PY2[3].toDouble(), Colors.teal),
    ChartDataPlan(PlanX[4], PY1[4].toDouble(), PY2[4].toDouble(), Colors.teal),
    ChartDataPlan(PlanX[5], PY1[5].toDouble(), PY2[5].toDouble(), Colors.teal),
    ChartDataPlan(PlanX[6], PY1[6].toDouble(), PY2[6].toDouble(), Colors.teal),
    ChartDataPlan(PlanX[7], PY1[7].toDouble(), PY2[7].toDouble(), Colors.teal),
    ChartDataPlan(PlanX[8], PY1[8].toDouble(), PY2[8].toDouble(), Colors.teal),
    ChartDataPlan(PlanX[9], PY1[9].toDouble(), PY2[9].toDouble(), Colors.teal),
    ChartDataPlan(
        PlanX[10], PY1[10].toDouble(), PY2[10].toDouble(), Colors.teal),
    ChartDataPlan(
        PlanX[11], PY1[11].toDouble(), PY2[11].toDouble(), Colors.teal),
  ];

  void _refreshChart() async {
    setState(() {
      //Bar
      _chartDataEntregaTipo = [
        ChartData(EntregaTipox[0], EntregaTipoy[0].toDouble(),
            EntregaTipoy1[0].toDouble(), Colors.teal),
        ChartData(EntregaTipox[1], EntregaTipoy[1].toDouble(),
            EntregaTipoy1[1].toDouble(), Colors.teal),
        ChartData(EntregaTipox[2], EntregaTipoy[2].toDouble(),
            EntregaTipoy1[2].toDouble(), Colors.teal),
        ChartData(EntregaTipox[3], EntregaTipoy[3].toDouble(),
            EntregaTipoy1[3].toDouble(), Colors.teal),
        ChartData(EntregaTipox[4], EntregaTipoy[4].toDouble(),
            EntregaTipoy1[4].toDouble(), Colors.teal),
        ChartData(EntregaTipox[5], EntregaTipoy[5].toDouble(),
            EntregaTipoy1[5].toDouble(), Colors.teal),
        ChartData(EntregaTipox[6], EntregaTipoy[6].toDouble(),
            EntregaTipoy1[6].toDouble(), Colors.teal),
        ChartData(EntregaTipox[7], EntregaTipoy[7].toDouble(),
            EntregaTipoy1[7].toDouble(), Colors.teal),
        ChartData(EntregaTipox[8], EntregaTipoy[8].toDouble(),
            EntregaTipoy1[8].toDouble(), Colors.teal),
        ChartData(EntregaTipox[9], EntregaTipoy[9].toDouble(),
            EntregaTipoy1[9].toDouble(), Colors.teal),
        ChartData(EntregaTipox[10], EntregaTipoy[10].toDouble(),
            EntregaTipoy1[10].toDouble(), Colors.teal),
        ChartData(EntregaTipox[11], EntregaTipoy[11].toDouble(),
            EntregaTipoy1[11].toDouble(), Colors.teal),
      ];


      _chartDataNor = [
        ChartDataAyC(AYCX[0], AYCY1[0].toDouble(), AYCY2[0].toDouble(), AYCY3[0].toDouble(), AYCY4[0].toDouble()),
        ChartDataAyC(AYCX[1], AYCY1[1].toDouble(), AYCY2[1].toDouble(),
            AYCY3[1].toDouble(), AYCY4[1].toDouble()),
        ChartDataAyC(AYCX[2], AYCY1[2].toDouble(), AYCY2[2].toDouble(),
            AYCY3[2].toDouble(), AYCY4[2].toDouble()),
        ChartDataAyC(AYCX[3], AYCY1[3].toDouble(), AYCY2[3].toDouble(),
            AYCY3[3].toDouble(), AYCY4[3].toDouble()),
        ChartDataAyC(AYCX[4], AYCY1[4].toDouble(), AYCY2[4].toDouble(),
            AYCY3[4].toDouble(), AYCY4[4].toDouble()),
        ChartDataAyC(AYCX[5], AYCY1[5].toDouble(), AYCY2[5].toDouble(),
            AYCY3[5].toDouble(), AYCY4[5].toDouble()),
        ChartDataAyC(AYCX[6], AYCY1[6].toDouble(), AYCY2[6].toDouble(),
            AYCY3[6].toDouble(), AYCY4[6].toDouble()),
        ChartDataAyC(AYCX[7], AYCY1[7].toDouble(), AYCY2[7].toDouble(),
            AYCY3[7].toDouble(), AYCY4[7].toDouble()),
        ChartDataAyC(AYCX[8], AYCY1[8].toDouble(), AYCY2[8].toDouble(),
            AYCY3[8].toDouble(), AYCY4[8].toDouble()),
        ChartDataAyC(AYCX[9], AYCY1[9].toDouble(), AYCY2[9].toDouble(),
            AYCY3[9].toDouble(), AYCY4[9].toDouble()),
        ChartDataAyC(AYCX[10], AYCY1[10].toDouble(), AYCY2[10].toDouble(),
            AYCY3[10].toDouble(), AYCY4[10].toDouble()),
        ChartDataAyC(AYCX[11], AYCY1[11].toDouble(), AYCY2[11].toDouble(),
            AYCY3[11].toDouble(), AYCY4[11].toDouble()),
      ];


      //Chart Data Plan
      _chartDataPlan = [
        ChartDataPlan(
            PlanX[0], PY1[0].toDouble(), PY2[0].toDouble(), Colors.teal),
        ChartDataPlan(
            PlanX[1], PY1[1].toDouble(), PY2[1].toDouble(), Colors.teal),
        ChartDataPlan(
            PlanX[2], PY1[2].toDouble(), PY2[2].toDouble(), Colors.teal),
        ChartDataPlan(
            PlanX[3], PY1[3].toDouble(), PY2[3].toDouble(), Colors.teal),
        ChartDataPlan(
            PlanX[4], PY1[4].toDouble(), PY2[4].toDouble(), Colors.teal),
        ChartDataPlan(
            PlanX[5], PY1[5].toDouble(), PY2[5].toDouble(), Colors.teal),
        ChartDataPlan(
            PlanX[6], PY1[6].toDouble(), PY2[6].toDouble(), Colors.teal),
        ChartDataPlan(
            PlanX[7], PY1[7].toDouble(), PY2[7].toDouble(), Colors.teal),
        ChartDataPlan(
            PlanX[8], PY1[8].toDouble(), PY2[8].toDouble(), Colors.teal),
        ChartDataPlan(
            PlanX[9], PY1[9].toDouble(), PY2[9].toDouble(), Colors.teal),
        ChartDataPlan(
            PlanX[10], PY1[10].toDouble(), PY2[10].toDouble(), Colors.teal),
        ChartDataPlan(
            PlanX[11], PY1[11].toDouble(), PY2[11].toDouble(), Colors.teal),
      ];
    });
  }

  // EstadisticaEntregaState();
  late GlobalKey<SfCartesianChartState> _cartesianChartOne;
  late GlobalKey<SfCartesianChartState> _cartesianChartTwo;
  late GlobalKey<SfCartesianChartState> _cartesianChartThree;
  late GlobalKey<SfCartesianChartState> _cartesianChartFour;


  // late List<ChartData> _chartData;  //Bar Chart
  late TooltipBehavior _tooltipBehavior; //Pie Cahrt

  @override
  void initState() {
    super.initState();




    _asyncMethod(dropdownValue);
    //_refreshChart();

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y%',
    );

    _cartesianChartOne = GlobalKey();
    _cartesianChartTwo = GlobalKey();
    _cartesianChartThree = GlobalKey();
    _cartesianChartFour = GlobalKey();

    print("Sede est_seg === ${widget.sede}");
    //asyncInitState();
  }

  _asyncMethod(String anho) async {

    await RequestDataIncMensualData(dropdownValue); //si falla cambiarlo a Prueba
    await RequestAYCnivel(dropdownValue);
    await RequestPlanAccion(dropdownValue);

}

  @override
  Widget build(BuildContext context) {
    _refreshChart();
    return Scaffold(
      appBar: AppBar(title: Text("Estadisticas de Seguridad", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),), backgroundColor: Color(0xff09357E), elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_sharp, color: Colors.white), onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CompanyPage()));
        },), ),
      //CompanyPage

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width*0.93,
              decoration:
              BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0) ),



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

                                SizedBox(height: 10,),

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
            //=========================INCIDENTES MENSUALES
            Container(
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
                                              "Incidentes Mensuales (Por Tipo)",
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
                                      IconButton(
                                          onPressed: () async {
                                             await _renderPDF(_cartesianChartOne, 'IncMensual', '$dropdownValue', 'Incidentes Mensuales (Por Tipo)');
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
                                                'Incidentes por Tipo',
                                                textStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500)),
                                            key: _cartesianChartOne,
                                            series: <CartesianSeries<ChartData, String>>[
                                          StackedColumnSeries<ChartData, String>(
                                            color: const Color(0xFFFF9F40),
                                            name: 'Seguridad',
                                            animationDelay: 500,
                                            animationDuration: 1500,
                                            dataSource: _chartDataEntregaTipo,          // List<ChartData>
                                            xValueMapper: (d, _) => d.x,
                                            yValueMapper: (d, _) => d.y,
                                            // pointColorMapper: (d, _) => d.color,
                                            // emptyPointSettings: const EmptyPointSettings(mode: EmptyPointMode.gap),
                                          ),
                                          StackedColumnSeries<ChartData, String>(
                                            color: const Color(0xFF4BC0C0),
                                            name: 'Salud',
                                            animationDelay: 500,
                                            animationDuration: 1500,
                                            dataSource: _chartDataEntregaTipo,
                                            xValueMapper: (d, _) => d.x,
                                            yValueMapper: (d, _) => d.y1,
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

            //=========================ACTOS Y CONDICIONES
         Container(
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
                                              "Actos y Condiciones (Por Registro)",

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
                                      IconButton(
                                          onPressed: () async {
                                            await _renderPDF(_cartesianChartThree, 'AyCRiesgo', '$dropdownValue', 'Actos y Condiciones (Por Registro)');
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
                                                'Nivel de Riesgo',
                                                textStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500)),
                                            key: _cartesianChartThree,
                                            series: <CartesianSeries<ChartDataAyC, String>>[
                                          StackedColumnSeries<ChartDataAyC, String>(
                                            color: const Color(0xFF67A856),
                                            name: 'Bajo',
                                            animationDelay: 500,
                                            animationDuration: 1500,
                                            dataSource: _chartDataNor,                   // List<ChartDataAyC>
                                            xValueMapper: (d, _) => d.x,
                                            yValueMapper: (d, _) => d.y1,
                                          ),
                                          StackedColumnSeries<ChartDataAyC, String>(
                                            color: const Color(0xFFFF9F40),
                                            name: 'Medio',
                                            animationDelay: 500,
                                            animationDuration: 1500,
                                            dataSource: _chartDataNor,
                                            xValueMapper: (d, _) => d.x,
                                            yValueMapper: (d, _) => d.y2,
                                          ),
                                          StackedColumnSeries<ChartDataAyC, String>(
                                            color: const Color(0xFFCE5757),
                                            name: 'Alto',
                                            animationDelay: 500,
                                            animationDuration: 1500,
                                            dataSource: _chartDataNor,
                                            xValueMapper: (d, _) => d.x,
                                            yValueMapper: (d, _) => d.y3,
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
                        //====>Histogram CHART
                      ],
                    ),
                  ),
                ],
              ),
            ),



            //=========================PLANES DE ACCION
            Container(
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
                                              "Plan de Accion (Por Estado)",

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
                                      IconButton(
                                          onPressed: () async {
                                            await _renderPDF(_cartesianChartFour, 'AccEstado', '$dropdownValue', 'Plan de Accion (Por Estado)');
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
                                                'Planes de Acción',
                                                textStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500)),
                                            key: _cartesianChartFour,
                                            series: <CartesianSeries<ChartDataPlan, String>>[
                                              StackedColumnSeries<ChartDataPlan, String>(
                                                color: const Color(0xFF67A856),
                                                name: 'Ejecutado',
                                                animationDelay: 500,
                                                animationDuration: 1500,
                                                dataSource: _chartDataPlan,                  // List<ChartDataPlan>
                                                xValueMapper: (d, _) => d.x,
                                                yValueMapper: (d, _) => d.y1,
                                              ),
                                              StackedColumnSeries<ChartDataPlan, String>(
                                                color: const Color(0xFFFF9F40),
                                                name: 'Pendiente',
                                                animationDelay: 500,
                                                animationDuration: 1500,
                                                dataSource: _chartDataPlan,
                                                xValueMapper: (d, _) => d.x,
                                                yValueMapper: (d, _) => d.y2,
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
                        //====>Histogram CHART
                      ],
                    ),
                  ),
                ],
              ),
            ),




          ],
        ),
      ),
    );
  }




  Future <List<void>> RequestDataIncMensualData(String anho) async {
    final user = await authController.getUserFromStorage();


  var url = '${user!.urlApp}/ws/null/pr_grp_Estad_Incidente_Mensual?fb_uea_pe_id=${widget.sede}&anho=$anho';
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
  (datos.map((e) => inc_mensuales_tipo_model.fromJson(e)).toList() as List).map((emp) {
    print('Insertando.. $emp');
    sqlDb.createIncidentesMesTipo(emp);
  }).toList();

  print("result --- $result");

  Future.delayed(const Duration(milliseconds: 800), () async {
    List<Map> responseRead = await sqlDb.readData(""
        "SELECT * FROM IncidentesMensualesTipo");
    print("tabla niveles incidentesMensuales --- $responseRead");
    print("inc_mensuales length --- ${responseRead.length}");

    if(result.length == 0){
      for(int i=0; i<12; i++){
        EntregaTipoy[i] = 0;
        EntregaTipoy1[i] = 0;
        setState(() {});
      }


    }
    else if(result.length == 1){
      EntregaTipoy[0] = responseRead[1]["ene"] ?? 0;
      EntregaTipoy[1] = responseRead[1]["feb"] ?? 0;
      EntregaTipoy[2] =  responseRead[1]["mar"] ?? 0;
      EntregaTipoy[3] =  responseRead[1]["abr"] ?? 0;
      EntregaTipoy[4] =  responseRead[1]["may"] ?? 0;
      EntregaTipoy[5] =  responseRead[1]["jun"] ?? 0;
      EntregaTipoy[6] =  responseRead[1]["jul"] ?? 0;
      EntregaTipoy[7] =  responseRead[1]["ago"] ?? 0;
      EntregaTipoy[8] = responseRead[1]["set"] ?? 0;
      EntregaTipoy[9] =  responseRead[1]["oct"] ?? 0;
      EntregaTipoy[10] =  responseRead[1]["nov"] ?? 0;
      EntregaTipoy[11] =  responseRead[1]["dic"] ?? 0;
      for(int i=0; i<12; i++){

        EntregaTipoy1[i] = 0;

      }

      setState(() {});
    }else {
      EntregaTipoy[0] = responseRead[1]["ene"] ?? 0;
      EntregaTipoy[1] = responseRead[1]["feb"] ?? 0;
      EntregaTipoy[2] =  responseRead[1]["mar"] ?? 0;
      EntregaTipoy[3] =  responseRead[1]["abr"] ?? 0;
      EntregaTipoy[4] =  responseRead[1]["may"] ?? 0;
      EntregaTipoy[5] =  responseRead[1]["jun"] ?? 0;
      EntregaTipoy[6] =  responseRead[1]["jul"] ?? 0;
      EntregaTipoy[7] =  responseRead[1]["ago"] ?? 0;
      EntregaTipoy[8] = responseRead[1]["set"] ?? 0;
      EntregaTipoy[9] =  responseRead[1]["oct"] ?? 0;
      EntregaTipoy[10] =  responseRead[1]["nov"] ?? 0;
      EntregaTipoy[11] =  responseRead[1]["dic"] ?? 0;

      EntregaTipoy1[0] = responseRead[0]["ene"] ?? 0;
      EntregaTipoy1[1] =  responseRead[0]["feb"] ?? 0;
      EntregaTipoy1[2] =  responseRead[0]["mar"] ?? 0;
      EntregaTipoy1[3] =  responseRead[0]["abr"] ?? 0;
      EntregaTipoy1[4] =  responseRead[0]["may"] ?? 0;
      EntregaTipoy1[5]=  responseRead[0]["jun"] ?? 0;
      EntregaTipoy1[6] = responseRead[0]["jul"] ?? 0;
      EntregaTipoy1[7] =  responseRead[0]["ago"] ?? 0;
      EntregaTipoy1[8] =  responseRead[0]["set"] ?? 0;
      EntregaTipoy1[9]=  responseRead[0]["oct"] ?? 0;
      EntregaTipoy1[10] =  responseRead[0]["nov"] ?? 0;
      EntregaTipoy1[11]=  responseRead[0]["dic"] ?? 0;

      setState(() {});
    }
  });

  return result;
}


  Future <List<void>> RequestAYCnivel(String anho) async {
    final user = await authController.getUserFromStorage();

    var url = '${user!.urlApp}/ws/null/pr_grp_ayc_nivel_riesgo?fb_uea_pe_id=${widget.sede}&Anno=$anho';
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
    (datos.map((e) => ayc_nivel_riesgo_model.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createAycNivelRiesgo(emp);
    }).toList();
    print("resultAYC nivelRiesgo --- $result");
    print("resultAYC nivelRiesgo length --- ${result.length}");


    Future.delayed(const Duration(milliseconds: 800), () async {
      List<Map> responseReadAyc = await sqlDb.readData(""
          "SELECT * FROM NivelesRiesgoAyC");
      print("tabla niveles riesgo --- $responseReadAyc");

      //AYC Y
      if(result.length == 0){
        for(int i=0; i<12; i++){
          AYCY1[i] = 0;
          AYCY2[i] = 0;
          AYCY3[i] = 0;

        }
        setState(() {});

      }
      else if(result.length == 1){
        AYCY1[0] = responseReadAyc[0]["ene"] ?? 0;
        AYCY1[1] =  responseReadAyc[0]["feb"] ?? 0;
        AYCY1[2] =  responseReadAyc[0]["mar"] ?? 0;
        AYCY1[3] =  responseReadAyc[0]["abr"] ?? 0;
        AYCY1[4] =  responseReadAyc[0]["may"] ?? 0;
        AYCY1[5] =  responseReadAyc[0]["jun"] ?? 0;
        AYCY1[6] =  responseReadAyc[0]["jul"] ?? 0;
        AYCY1[7] =  responseReadAyc[0]["ago"] ?? 0;
        AYCY1[8] =  responseReadAyc[0]["sep"] ?? 0;
        AYCY1[9] = responseReadAyc[0]["oct"] ?? 0;
        AYCY1[10] =  responseReadAyc[0]["nov"] ?? 0;
        AYCY1[11] =  responseReadAyc[0]["dic"] ?? 0;

        for(int i=0; i<12; i++){

          AYCY2[i] = 0;
          AYCY3[i] = 0;

        }

        setState(() {});
      }else{
        //AYC Y2
        AYCY1[0] = responseReadAyc[0]["ene"] ?? 0;
        AYCY1[1] =  responseReadAyc[0]["feb"] ?? 0;
        AYCY1[2] =  responseReadAyc[0]["mar"] ?? 0;
        AYCY1[3] =  responseReadAyc[0]["abr"] ?? 0;
        AYCY1[4] =  responseReadAyc[0]["may"] ?? 0;
        AYCY1[5] =  responseReadAyc[0]["jun"] ?? 0;
        AYCY1[6] =  responseReadAyc[0]["jul"] ?? 0;
        AYCY1[7] =  responseReadAyc[0]["ago"] ?? 0;
        AYCY1[8] =  responseReadAyc[0]["sep"] ?? 0;
        AYCY1[9] = responseReadAyc[0]["oct"] ?? 0;
        AYCY1[10] =  responseReadAyc[0]["nov"] ?? 0;
        AYCY1[11] =  responseReadAyc[0]["dic"] ?? 0;


        AYCY2[0] = responseReadAyc[1]["ene"] ?? 0;
        AYCY2[1] = responseReadAyc[1]["feb"] ?? 0;
        AYCY2[2] = responseReadAyc[1]["mar"] ?? 0;
        AYCY2[3] = responseReadAyc[1]["abr"] ?? 0;
        AYCY2[4] = responseReadAyc[1]["may"] ?? 0;
        AYCY2[5] = responseReadAyc[1]["jun"] ?? 0;
        AYCY2[6] = responseReadAyc[1]["jul"] ?? 0;
        AYCY2[7] = responseReadAyc[1]["ago"] ?? 0;
        AYCY2[8] = responseReadAyc[1]["sep"] ?? 0;
        AYCY2[9] = responseReadAyc[1]["oct"] ?? 0;
        AYCY2[10] = responseReadAyc[1]["nov"] ?? 0;
        AYCY2[11] = responseReadAyc[1]["dic"] ?? 0;

        //AYC Y3

        AYCY3[0] = responseReadAyc[2]["ene"] ?? 0;
        AYCY3[1] = responseReadAyc[2]["feb"] ?? 0;
        AYCY3[2] = responseReadAyc[2]["mar"] ?? 0;
        AYCY3[3] = responseReadAyc[2]["abr"] ?? 0;
        AYCY3[4] = responseReadAyc[2]["may"] ?? 0;
        AYCY3[5] = responseReadAyc[2]["jun"] ?? 0;
        AYCY3[6] = responseReadAyc[2]["jul"] ?? 0;
        AYCY3[7] = responseReadAyc[2]["ago"] ?? 0;
        AYCY3[8] = responseReadAyc[2]["sep"] ?? 0;
        AYCY3[9] = responseReadAyc[2]["oct"] ?? 0;
        AYCY3[10] = responseReadAyc[2]["nov"] ?? 0;
        AYCY3[11] = responseReadAyc[2]["dic"] ?? 0;
        setState(() {});
      }
    });


    return result;
  }


  //Plan de Accion
  Future <List<void>> RequestPlanAccion(String anho) async {
    final user = await authController.getUserFromStorage();

    //${widget.sede}
    var url = '${user!.urlApp}/ws/null/pr_ws_estado_plan?sede=GOLDEN&anno=$anho';
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
    (datos.map((e) => plan_accion_model.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createPlanAccion(emp);
    }).toList();


    Future.delayed(const Duration(milliseconds: 800), () async {
      List<Map> responseRequestPlanAccion = await sqlDb.readData(""
          "SELECT * FROM PlanAccion");
      print("tabla plan accion --- $responseRequestPlanAccion");

      if(result.length == 0){
        for(int i=0; i<12; i++){
          PY1[i] = 0;
          PY2[i] = 0;


        }

        setState(() {});
      }
      else if(result.length == 1){
        PY1[0] =  responseRequestPlanAccion[0]["ene"] ?? 0;
        PY1[1] =  responseRequestPlanAccion[0]["feb"] ?? 0;
        PY1[2] = responseRequestPlanAccion[0]["mar"] ?? 0;
        PY1[3] = responseRequestPlanAccion[0]["abr"] ?? 0;
        PY1[4] =  responseRequestPlanAccion[0]["may"] ?? 0;
        PY1[5] =  responseRequestPlanAccion[0]["jun"] ?? 0;
        PY1[6] =  responseRequestPlanAccion[0]["jul"] ?? 0;
        PY1[7] =  responseRequestPlanAccion[0]["ago"] ?? 0;
        PY1[8] =  responseRequestPlanAccion[0]["sep"] ?? 0;
        PY1[9] =  responseRequestPlanAccion[0]["oct"] ?? 0;
        PY1[10] =  responseRequestPlanAccion[0]["nov"] ?? 0;
        PY1[11] =  responseRequestPlanAccion[0]["dic"] ?? 0;
        for(int i=0; i<12; i++){

          PY2[i] = 0;

        }

        setState(() {});
      }else {
        PY1[0] =  responseRequestPlanAccion[0]["ene"] ?? 0;
        PY1[1] =  responseRequestPlanAccion[0]["feb"] ?? 0;
        PY1[2] = responseRequestPlanAccion[0]["mar"] ?? 0;
        PY1[3] = responseRequestPlanAccion[0]["abr"] ?? 0;
        PY1[4] =  responseRequestPlanAccion[0]["may"] ?? 0;
        PY1[5] =  responseRequestPlanAccion[0]["jun"] ?? 0;
        PY1[6] =  responseRequestPlanAccion[0]["jul"] ?? 0;
        PY1[7] =  responseRequestPlanAccion[0]["ago"] ?? 0;
        PY1[8] =  responseRequestPlanAccion[0]["sep"] ?? 0;
        PY1[9] =  responseRequestPlanAccion[0]["oct"] ?? 0;
        PY1[10] =  responseRequestPlanAccion[0]["nov"] ?? 0;
        PY1[11] =  responseRequestPlanAccion[0]["dic"] ?? 0;

        PY2[0] = responseRequestPlanAccion[1]["ene"] ?? 0;
        PY2[1] = responseRequestPlanAccion[1]["feb"] ?? 0;
        PY2[2] = responseRequestPlanAccion[1]["mar"] ?? 0;
        PY2[3] = responseRequestPlanAccion[1]["abr"] ?? 0;
        PY2[4] = responseRequestPlanAccion[1]["may"] ?? 0;
        PY2[5] = responseRequestPlanAccion[1]["jun"] ?? 0;
        PY2[6] = responseRequestPlanAccion[1]["jul"] ?? 0;
        PY2[7] = responseRequestPlanAccion[1]["ago"] ?? 0;
        PY2[8] = responseRequestPlanAccion[1]["sep"] ?? 0;
        PY2[9] = responseRequestPlanAccion[1]["oct"] ?? 0;
        PY2[10] = responseRequestPlanAccion[1]["nov"] ?? 0;
        PY2[11] = responseRequestPlanAccion[1]["dic"] ?? 0;
        setState(() {});
      }
    });


    return result;
  }

//Leer Datos de SQLite


  Future<List<Map>> readDataPrueba() async {
    SqlDb sqlDb = SqlDb();
    List<Map> responseRead = await sqlDb.readData(""
        "SELECT * FROM IncidentesMensualesTipo" );
    print("resp sqlite ----- ${responseRead}");

    return responseRead;
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
    //  Share.shareFiles(['$path/$formattedDateAcc-$tipo.pdf'], text: 'Reporte.pdf', mimeTypes: ['application/pdf'], );
      
    }
  }


  Future<List<int>> _readImageData(GlobalKey<SfCartesianChartState> cartesianChart) async {
    final ui.Image? data =
    await cartesianChart.currentState!.toImage(pixelRatio: 1.5);
    final ByteData? bytes =
    await data!.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }






class ChartData {
  ChartData(this.x, this.y,  this.y1, this.color);

  final String x;
  final double? y;
  final double? y1;
 // final String? y2;
  final Color color;
}

class ChartDataAyC {
  ChartDataAyC(this.x, this.y1, this.y2, this.y3, this.y4);

  final String x;
  final double? y1;
  final double? y2;
  final double? y3;
  final double? y4;

}

class ChartDataPlan {
  ChartDataPlan(this.x, this.y1,  this.y2, this.color);

  final String x;
  final double? y1;
  final double? y2;
  // final String? y2;
  final Color color;
}



