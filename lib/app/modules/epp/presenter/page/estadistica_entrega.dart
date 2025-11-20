import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/epp/domain/entities/incidente_subtipo_model.dart';
import 'package:safe2biz/app/modules/epp/domain/entities/pendientes_aprobar_gerencia_model.dart';
import 'package:safe2biz/app/modules/epp/external/api/entrega_epp_api.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/lista_entrega.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

bool linealChart = false;
bool barChart = true;
String dropdownValue = '2023';

int? EnRegistro;
int? PorEnviar;
int? Enviado;

List<int> EntregaTipoy = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
List<String> EntregaTipox = ["", "", "", "", "", "", "", "", "", "", ""];

//String? valorAnho;
class EstadisticaEntrega extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables

  EstadisticaEntrega({Key? key}) : super(key: key);

  @override
  EstadisticaEntregaState createState() => EstadisticaEntregaState();
}

SqlDb sqlDb = SqlDb();

//final apiEntrega = ApiEntregaEpp();

class EstadisticaEntregaState extends State<EstadisticaEntrega> {
  //Gráfico Barras Entrega EPP (Por Tipo)
  List<ChartData> _chartDataEntregaTipo = [
    ChartData(EntregaTipox[0], EntregaTipoy[0].toDouble(), Colors.teal),
    ChartData(EntregaTipox[1], EntregaTipoy[1].toDouble(), Colors.teal),
    ChartData(EntregaTipox[2], EntregaTipoy[2].toDouble(), Colors.teal),
    ChartData(EntregaTipox[3], EntregaTipoy[3].toDouble(), Colors.teal),
    ChartData(EntregaTipox[4], EntregaTipoy[4].toDouble(), Colors.teal),
    ChartData(EntregaTipox[5], EntregaTipoy[5].toDouble(), Colors.teal),
    ChartData(EntregaTipox[6], EntregaTipoy[6].toDouble(), Colors.teal),
    ChartData(EntregaTipox[7], EntregaTipoy[7].toDouble(), Colors.teal),
    ChartData(EntregaTipox[8], EntregaTipoy[8].toDouble(), Colors.teal),
    ChartData(EntregaTipox[9], EntregaTipoy[9].toDouble(), Colors.teal),
    ChartData(EntregaTipox[10], EntregaTipoy[10].toDouble(), Colors.teal),
  ];

  //Gráfico Circular Entrega EPP (Por Estado)
  List<ChartData> _chartDataEntregaEstado = [
    ChartData('En Registro', EnRegistro?.toDouble(), Color(0xffFF7777)),
    ChartData('Por Enviar', PorEnviar?.toDouble(), Color(0xffFFBA55)),
    ChartData('Enviado', Enviado?.toDouble(), Color(0xff67A856))
  ];

  void _refreshChart() async {
    setState(() {
      //Bar
      _chartDataEntregaTipo = [
        ChartData(EntregaTipox[0], EntregaTipoy[0].toDouble(), Colors.teal),
        ChartData(EntregaTipox[1], EntregaTipoy[1].toDouble(), Colors.teal),
        ChartData(EntregaTipox[2], EntregaTipoy[2].toDouble(), Colors.teal),
        ChartData(EntregaTipox[3], EntregaTipoy[3].toDouble(), Colors.teal),
        ChartData(EntregaTipox[4], EntregaTipoy[4].toDouble(), Colors.teal),
        ChartData(EntregaTipox[5], EntregaTipoy[5].toDouble(), Colors.teal),
        ChartData(EntregaTipox[6], EntregaTipoy[6].toDouble(), Colors.teal),
        ChartData(EntregaTipox[7], EntregaTipoy[7].toDouble(), Colors.teal),
        ChartData(EntregaTipox[8], EntregaTipoy[8].toDouble(), Colors.teal),
        ChartData(EntregaTipox[9], EntregaTipoy[9].toDouble(), Colors.teal),
        ChartData(EntregaTipox[10], EntregaTipoy[10].toDouble(), Colors.teal),
      ];
      //Pie
      _chartDataEntregaEstado = [
        ChartData('En Registro', EnRegistro?.toDouble(), Color(0xffFF7777)),
        ChartData('Por Enviar', PorEnviar?.toDouble(), Color(0xffFFBA55)),
        ChartData('Enviado', Enviado?.toDouble(), Color(0xff67A856))
      ];
    });
  }

  // EstadisticaEntregaState();
  late GlobalKey<SfCartesianChartState> _cartesianChartKey;

  // late List<ChartData> _chartData;  //Bar Chart
  late TooltipBehavior _tooltipBehavior; //Pie Cahrt

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {

// Here you can write your code

      setState(() {
        // Here you can write your code for open new view
      });

    });

    _asyncMethod(dropdownValue);

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y%',
    );
    _cartesianChartKey = GlobalKey();
  }


  _asyncMethod(String anho) async {
    EntregaTipoy[0] = await apiEntrega.readDataPrueba('Proteccion Auditiva', anho);
    EntregaTipoy[1] = await apiEntrega.readDataPrueba('Proteccion Visual', anho);
    EntregaTipoy[2] = await apiEntrega.readDataPrueba('Proteccion Manos', anho);
    EntregaTipoy[3] = await apiEntrega.readDataPrueba('Proteccion Cabeza', anho);
    EntregaTipoy[4] = await apiEntrega.readDataPrueba('Proteccion Para Pies', anho);
    EntregaTipoy[5] = await apiEntrega.readDataPrueba('Proteccion en Cuerpo', anho);
    EntregaTipoy[6] = await apiEntrega.readDataPrueba('Proteccion en Alturas', anho);
    EntregaTipoy[7] = await apiEntrega.readDataPrueba('Proteccion Para Validad y Construcción', anho);
    EntregaTipoy[8] = await apiEntrega.readDataPrueba('Proteccion Respiratoria', anho);
    EntregaTipoy[9] = await apiEntrega.readDataPrueba('Protección para Alta y Baja Tensión', anho);
    EntregaTipoy[10] = await apiEntrega.readDataPrueba('Protección en Caliente', anho);

    EntregaTipox = [
      "P.Auditiva",
      "P.Visual",
      "P.Manos",
      "P.Cabeza",
      "P.Pies",
      "P.Cuerpo",
      "P.Alturas",
      "P.Construccion",
      "P.Respiratoria",
      "P.Tension",
      "P.Caliente"
    ];

    EnRegistro = await apiEntrega.readDataEstado('En Registro', dropdownValue);
    PorEnviar = await apiEntrega.readDataEstado('Por Enviar', dropdownValue);
    Enviado = await apiEntrega.readDataEstado('Enviado', dropdownValue);
  }

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(milliseconds: 600), () {

      _refreshChart();
    });


    return Scaffold(
        appBar: AppBar(
            title: Text('Gráficos Estadísticos', style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
            backgroundColor: Color(0xff09357E),

            elevation: 0),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 45,
                color: Color(0xff09357E),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Seleccione el año",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Container(
                        child: StatefulBuilder(builder: (context, setState) {
                          return DropdownButton<String>(
                            iconEnabledColor: Colors.white,
                            value: dropdownValue,
                            underline: SizedBox(),
                            dropdownColor: Color(0xff09357E),
                            items: <String>[
                              '2023',
                              '2022',
                              '2021',
                              '2020',
                              '2019',
                              '2018'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              );
                            }).toList(),
                            // Step 5.
                            onChanged: (String? newValue) async {
                              //          valorAnho = newValue!;

                              dropdownValue = newValue!;
                              print("valorAnho--> ${newValue}");

                              _asyncMethod(dropdownValue);

                              Future.delayed(Duration(milliseconds: 200))
                                  .then((value) => _refreshChart());
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Color(0xffEBEFFB),
                child: Row(
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
                                                "Productos EPP (Por Tipo)",
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
                                           //   await _renderPDF();
                                            },
                                            icon: Icon(
                                              Icons.picture_as_pdf,
                                              size: 0,
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
                                  visible: barChart,
                                  child: TextButton.icon(
                                    onPressed: () {
                                      linealChart = true;
                                      barChart = false;
                                      setState(() {});
                                    },
                                    label: Text(
                                      "Ver Gráfico Lineal",
                                      style:
                                          TextStyle(color: Color(0xff09357E)),
                                    ),
                                    icon: Icon(
                                      Icons.show_chart_sharp,
                                      color: Color(0xff09357E),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: linealChart,
                                  child: TextButton.icon(
                                    onPressed: () {
                                      barChart = true;
                                      linealChart = false;
                                      setState(() {});
                                    },
                                    label: Text("Ver Gráfico de Barras"),
                                    icon: Icon(Icons.bar_chart),
                                  ),
                                ),
                                Visibility(
                                  visible: barChart,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.50,
                                    width: MediaQuery.of(context).size.width *
                                        0.98,
                                    child: StatefulBuilder(
                                        builder: (context, setState) {
                                      return SfCartesianChart(
                                          primaryYAxis: NumericAxis(
                                              // axis interval is set to 10
                                              interval: 1),
                                          primaryXAxis: CategoryAxis(
                                            // arrangeByIndex: false,

                                            labelIntersectAction:
                                                AxisLabelIntersectAction
                                                    .rotate45,
                                            labelStyle: TextStyle(fontSize: 10),
                                          ),
                                          enableAxisAnimation: true,
                                          // Enables the legend
                                          legend: Legend(isVisible: true),
                                          title: ChartTitle(
                                              text:
                                                  'Equipos por Tipo de Producto',
                                              textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                          //primaryXAxis: CategoryAxis(),
                                          key: _cartesianChartKey,
                                          series: <
                                              ColumnSeries<ChartData, String>>[
                                            ColumnSeries<ChartData, String>(
                                              animationDelay: 0,
                                              animationDuration: 2000,
                                              color: Colors.teal,
                                              name: 'N° de Equipos',
                                              dataSource: _chartDataEntregaTipo,
                                              xValueMapper:
                                                  (ChartData data, _) => data.x,
                                              yValueMapper:
                                                  (ChartData data, _) => data.y,
                                            )
                                          ]);
                                    }),
                                  ),
                                ),
                                Visibility(
                                  visible: linealChart,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.40,
                                    width: MediaQuery.of(context).size.width * 0.98,
                                    child: SfCartesianChart(
                                      enableAxisAnimation: true,
                                      primaryXAxis: CategoryAxis(
                                        labelIntersectAction: AxisLabelIntersectAction.rotate45,
                                        labelStyle: const TextStyle(fontSize: 10),
                                        labelPlacement: LabelPlacement.onTicks,
                                      ),
                                      primaryYAxis: NumericAxis(
                                        interval: 2,
                                        // opcional: numberFormat: NumberFormat.compact(), // si usas intl
                                      ),
                                        series: <CartesianSeries<ChartData, String>>[
                                          LineSeries<ChartData, String>(
                                            color: const Color(0xff09357E),
                                            animationDuration: 2000,
                                            dataSource: _chartDataEntregaTipo, // List<ChartData>
                                            xValueMapper: (d, _) => d.x,
                                            yValueMapper: (d, _) => d.y,
                                            pointColorMapper: (d, _) => d.color,
                                            emptyPointSettings: const EmptyPointSettings(mode: EmptyPointMode.gap),
                                          ),
                                        ]

                                      // opcional: tooltip
                                      // tooltipBehavior: TooltipBehavior(enable: true),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          //====>Histogram CHART

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
                                                "Entregas EPP (Por Estado) ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        )),
                                    IconButton(
                                        onPressed: () async {
                                     //     await _renderPDF();
                                        },
                                        icon: Icon(
                                          Icons.picture_as_pdf,
                                          size: 0,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Column(
                            children: [
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  child: SfCircularChart(
                                      legend: Legend(
                                          isVisible: true,
                                          textStyle: TextStyle(fontSize: 12)),
                                      title: ChartTitle(
                                          text: '',
                                          textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                      // Enables the tooltip for all the series in chart
                                      tooltipBehavior: _tooltipBehavior,
                                      series: <PieSeries<ChartData, String>>[
                                        PieSeries<ChartData, String>(
                                          name: "Estado",
                                          explode: true,
                                          enableTooltip: true,
                                          dataLabelMapper:
                                              (ChartData data, _) => data.x,
                                          dataSource: _chartDataEntregaEstado,
                                          radius: '75%',
                                          dataLabelSettings: DataLabelSettings(
                                            connectorLineSettings:
                                                ConnectorLineSettings(
                                                    // Type of the connector line
                                                    type: ConnectorType.curve),
                                            showZeroValue: true,
                                            isVisible: true,
                                            labelPosition:
                                                ChartDataLabelPosition.outside,
                                            textStyle: TextStyle(fontSize: 10),
                                          ),
                                          pointColorMapper:
                                              (ChartData data, _) => data.color,
                                          xValueMapper: (ChartData data, _) =>
                                              data.x,
                                          yValueMapper: (ChartData data, _) =>
                                              data.y,
                                        )
                                      ]))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  /* Exportamos a PDF
  Future<void> _renderPDF() async {
    final List<int> imageBytes = await _readImageData();
    final PdfBitmap bitmap = PdfBitmap(imageBytes);
    final PdfDocument document = PdfDocument();
    document.pageSettings.size =
        Size(bitmap.width.toDouble(), bitmap.height.toDouble());
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    page.graphics.drawImage(
        bitmap, Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));
    final List<int> bytes = document.saveSync();
    document.dispose();
    //Get external storage directory
    final Directory directory = await getApplicationSupportDirectory();
    //Get directory path
    final String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/${DateTime.now()}-Reporte.pdf');
    //Write PDF bytes data
    await file.writeAsBytes(bytes, flush: true);
    //Open the PDF document in mobile
    OpenFile.open('$path/${DateTime.now()}-Reporte.pdf');
  }
*/
  Future<List<int>> _readImageData() async {
    final ui.Image? data =
        await _cartesianChartKey.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? bytes =
        await data!.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }
}
class ChartData {
  const ChartData(this.x, this.y, this.color);
  final String x;       // categoría
  final double? y;      // puede ser null
  final Color color;    // color por punto
}