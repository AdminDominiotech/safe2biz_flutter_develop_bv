import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bottom_nav_layout/bottom_nav_layout.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/global/core/shared_widgets/input/input_text_field.dart';
import 'dart:convert' as convert;
import 'package:safe2biz/app/global/core/shared_widgets/navigation/nav.dart';
import 'package:safe2biz/app/global/core/shared_widgets/text/text.dart';
import 'package:safe2biz/app/global/core/styles/colors.dart';
import 'package:safe2biz/app/global/core/styles/radius.dart';
import 'package:safe2biz/app/modules/epp/external/api/entrega_epp_api.dart';
import 'dart:convert';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/estadistica_entrega.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/lista_entrega.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/scan_info_prod.dart';
import 'package:safe2biz/app/modules/epp/presenter/widgets/FechaHora.dart';
import 'package:safe2biz/app/ui/module_ui.dart';


enum TypeSource { camera, gallery }

bool? flagEpp;
class AgregarEntrega extends StatefulWidget {
  final int? id,
      fb_uea_pe_id,
      fb_area_id,
      fb_cargo_id,
      fb_puesto_trabajo_id,
      epp_rol_epp_id,
      fb_empleado_id,
      id_emp;
  final String? codigo,
      organizacion,
      nombre,
      dni,
      cargo,
      area,
      email,
      cargoCod,
      areaCod,
      puesto_trabajo_codigo,
      puesto_trabajo_nombre,
      rol_epp_codigo,
      rol_epp_nombre,
      foto;

  final int? cantidad;
  AgregarEntrega(
      {Key? key,
      this.nombre,
      this.dni,
      this.area,
      this.cargo,
      this.codigo,
      this.organizacion,
      this.email,
      this.id,
      this.cantidad,
      this.fb_area_id,
      this.fb_cargo_id,
      this.cargoCod,
      this.areaCod,
      this.puesto_trabajo_codigo,
      this.puesto_trabajo_nombre,
      this.fb_puesto_trabajo_id,
      this.fb_uea_pe_id,
      this.epp_rol_epp_id,
      this.rol_epp_codigo,
      this.rol_epp_nombre,
      this.foto,
      this.fb_empleado_id,
      this.id_emp})
      : super(key: key);

  State<AgregarEntrega> createState() => _AgregarEntregaState();
}

int? eppEmpFlag;

int idEmpleado = 0;
String? base64Path;
String base64Image = '';
String? base64File;
String? path;
int identify = 0;
String? imgUser;
String? imgProduct;
String base64Img = '';
bool? hasData;
bool fotoEvidencia = true;
bool noEvidencia = false;
bool flagEvidencia = false;
bool imgEvidenciaVisible = false;
bool subirOtraFoto = false;
bool finalizarVisible = false;
bool buscarEmpleado = true;
int flag = 0;
String? fotoUser;
File? foto_evidencia_path;
File? foto_evidencia_compress;
int sync = 0;
bool viewRefresh = true;
int? count;

DateTime dateSelected = DateTime.now();
final fechaTxt = TextEditingController(text: DateTime.now().formatLocalFech2);
final horaTxt = TextEditingController(text: DateTime.now().formatHour);

class _AgregarEntregaState extends State<AgregarEntrega> {

  final apiEntrega = ApiEntregaEpp();

  final List<String> items = [
    'TRABAJO EN CALIENTE',
    'TRABAJO EN ALTURA',
    'TRABAJO CON ALTA TENSION',
    'TRABAJO CON ESMERIL',
    'TRABAJO ADMINISTRATIVO',
    'PERSONAL DE ALMACEN',
    'PERSONAL MINERO',
    'PERSONAL PERFORACION'
  ].toList();

  String? selection = null;
  XFile? image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img =
        await picker.pickImage(source: media, maxHeight: 180, maxWidth: 180);
    setState(() {
      image = img;
    });

    Uint8List bytes = File(image!.path).readAsBytesSync();
    base64Image = convert.base64Encode(bytes); //data:image/png;base64,
    base64Path = base64Image;
    print("img base64---> : $base64Path");
    print("img display ---> ${fechaTxt.text}${horaTxt.text}.jpg;${base64Path}");

    base64Img = "${fechaTxt.text}${horaTxt.text}.jpg;${base64Path}";

    Future<File?> stringBase64ToFile() async {
      try {
        final decodedBytes = base64Decode(base64Image);

        final directory = await getTemporaryDirectory();
        final basePath = directory.path;
        await Directory('$basePath/evidence').create(recursive: true);

        path = '$basePath/evidence/${widget.dni}-${intl.DateFormat('yyyyMMddHms.SSS').format(DateTime.now())}.jpg';
        print("Path---> ${path}");

        File file = await File(path!).writeAsBytes(decodedBytes);
        // await File(path).delete();

        noEvidencia = false;
        fotoEvidencia = true;

        return file;
      } catch (e) {
        debugPrint('ERROR EN CONVERSION DE String A FILE:  $e');
        return null;
      }
    }

//eLIMINAR ENTRGSA DETALLE
    await stringBase64ToFile();
    print(' URL ARCHIVO---> ${path}');
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    print(" TempDir----> ${tempPath}");

    int entregaepp = await sqlDb.insertData("UPDATE 'EntregaEpp' "
        " SET 'foto_evidencia' = '${fechaTxt.text}${horaTxt.text}.jpg;${base64Path}' "
        " WHERE EntregaEpp.fb_empleado_id = ${widget.id} AND EntregaEpp.fecha_entrega = '${fechaTxt.text}' AND EntregaEpp.hora_entrega = '${horaTxt.text}'  ");
    print(entregaepp); /*Agregar foto_evidencia*/

    subirOtraFoto = true;
    imgEvidenciaVisible = false;
    if (path != null) {
      setState(() {});
      imgEvidenciaVisible = false;
      subirOtraFoto = true;
    }
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Subir imagen por:'),
            content: InkWell(
              onTap: () => getImage(ImageSource.gallery),
              child: Container(
                height: MediaQuery.of(context).size.height / 6,
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff0A3987)),

                      //if user click this button, user can upload image from gallery
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.gallery);
                        setState(() {
                          print(image);
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.image),
                          Text(' Galería'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff0A3987)),
                      //if user click this button. user can upload image from camera
                      onPressed: () {
                        getImage(ImageSource.camera);
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Icon(Icons.camera),
                          Text(' Camara'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  String scanBarcode = 'Desconocido';
  SqlDb sqlDb = SqlDb(); //SQLite Conexion

  late String selectedValue;
  final String noEmpleado = 'assets/images/noData.svg';
  final String noProducto = 'assets/images/noProducts.svg';

  List categoryItemList = [];

  TextEditingController codigoProd = TextEditingController();

  @override
  void initState() {
    super.initState();
    final apiEntrega = ApiEntregaEpp();
    apiEntrega.getAllProd();
    hasData = false;
    //print("Bool hasData =====> $hasData");
    if (widget.id == null) {
      buscarEmpleado = false;
     // print("EL VALOR DEL ID ------> ${widget.id}");
    } else if(widget.id != null) {
      buscarEmpleado = true;
      //print("EL VALOR DEL ID ------> ${widget.id}");
    }
    refreshAfter(2000);
    selection = items.first; //Rol epp
    //print("foto--->${widget.foto}");
    fotoUser = widget.foto;

    if (fotoUser == null ||
        fotoUser == '' ||
        fotoUser!.isEmpty ||
        fotoUser == '.') {
        fotoUser = 'userDefault.png';
    }
    print("El valor de la foto es ----> $fotoUser");

    imgEvidenciaVisible = false;
    subirOtraFoto = false;
    finalizarVisible = false;
    fotoEvidencia = false;
    base64Image = '';
   // print("Base64--> ${base64Image}");

    if (apiEntrega.readDataProd(idEmpleado) == null) {
     // print("Es NULO");
      //print(apiEntrega.readDataProd(idEmpleado));
    } else {
      //print("NO Es NULO");
      //print(apiEntrega.readDataProd(idEmpleado));
    }

    if (sync == 0) {
      viewRefresh = false;
    } else {
      viewRefresh = true;
    }


  }
//Liberar memoria
  @override
  void dispose() {
    //  timer.cancel();
    super.dispose();
  }

  //Proceso de Escaneo
  @override
  Future<void> scanBarcodeNormal() async {

    Toast.show(
      description: 'Escaner por agregar..',
      toastType: ToastType.error,
    );

   /* String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Error';
    }

    if (!mounted) return;
    setState(() {
      scanBarcode = barcodeScanRes;

      if (barcodeScanRes != "-1") {
        scanBarcode = barcodeScanRes;
        sendProdInfo(context, scanBarcode.toString());
      } else {
        scanBarcode = "Escaneo canceledo";
      }
      ;
    });

    */
  }

  @override
  Widget build(BuildContext context) {

    double vw = MediaQuery.of(context).size.width;
    double vh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xffEBEFFB),
      appBar: AppBar(
        title: Text("Entrega EPP", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xff09357E),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (buscarEmpleado) {
              Nav.go(
                  context,
                  BottomNavLayout(
                    lazyLoadPages: true,
                    pages: [
                      (_) => ListaPersonal(
                            sede: sedeEmp,
                          ),
                      (_) => EstadisticaEntrega(),
                    ],
                    bottomNavigationBar: (currentIndex, onTap) =>
                        BottomNavigationBar(
                      //backgroundColor: Color(0xFF0A3987),
                      currentIndex: currentIndex,
                      onTap: (index) => onTap(index),
                      selectedItemColor: Colors.orange,
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.list_alt), label: 'Lista'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.bar_chart_outlined),
                            label: 'Estadisticas'),
                      ],
                    ),
                  ));
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Visibility(
                  visible: !buscarEmpleado,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 3.0),
                    color: Color(0xff09357E),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, bottom: 20, top: 10),
                              child: Container(
                                  child: Text(
                                "Buscar Empleado",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff09357E),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      //Tarjeta Empleado

                      Visibility(
                        visible: true,
                        child: Column(
                          children: [
                            //CARD============
                            Card(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20.0,
                                        top: 8.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Visibility(
                                            visible: !buscarEmpleado,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                FittedBox(
                                                  child: RichText(
                                                      text: TextSpan(children: [
                                                    WidgetSpan(
                                                        child: Icon(
                                                      Icons.person,
                                                      size: 20,
                                                    )),
                                                    WidgetSpan(
                                                        child: SizedBox(
                                                      width: 10,
                                                    )),
                                                    TextSpan(
                                                      text:
                                                          'SELECCIONAR EMPLEADO',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff09357E),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 2.0),
                                                    ),
                                                  ])),
                                                ),
                                                FittedBox(
                                                  child: IntrinsicHeight(
                                                    child: InkWell(
                                                      onTap: () {
                                                        showSearch(
                                                          context: context,
                                                          delegate:
                                                              MySearchDelegate(),
                                                        );
                                                      },
                                                      child: Row(
                                                        children: [
                                                          VerticalDivider(
                                                            color: Colors.grey,
                                                            thickness: 0.5,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Icon(
                                                            Icons.search,
                                                            size: 22,
                                                            color: Colors.black,
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Visibility(
                                            visible: buscarEmpleado,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                FittedBox(
                                                  child: RichText(
                                                      text: TextSpan(children: [
                                                    WidgetSpan(
                                                        child: Icon(
                                                      Icons.person,
                                                      size: 20,
                                                    )),
                                                    WidgetSpan(
                                                        child: SizedBox(
                                                      width: 10,
                                                    )),
                                                    TextSpan(
                                                      text: '${widget.nombre}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ])),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          showSearch(
                                                            context: context,
                                                            delegate:
                                                                MySearchDelegate(),
                                                          );
                                                        },
                                                        child: FittedBox(
                                                          child:
                                                              IntrinsicHeight(
                                                            child: InkWell(
                                                              onTap: () {
                                                                showSearch(
                                                                  context:
                                                                      context,
                                                                  delegate:
                                                                      MySearchDelegate(),
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  VerticalDivider(
                                                                    color: Colors
                                                                        .grey,
                                                                    thickness:
                                                                        0.5,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 12,
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .search,
                                                                    size: 22,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Divider(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 12.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 0.5),
                                                        color: Colors.black87,
                                                      ),

                                                      //Image.network("https://t3.ftcdn.net/jpg/03/39/45/96/360_F_339459697_XAFacNQmwnvJRqe1Fe9VOptPWMUxlZP8.jpg",

                                                      child: Image.asset(
                                                        'assets/images/$fotoUser',
                                                        height: 75,
                                                        width: 70,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              //Agregar Empleado - (DNI,Cargo,Area) - Vacio
                                              Visibility(
                                                visible: !buscarEmpleado,
                                                child: Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Card(
                                                        elevation: 0,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text("DNI:  ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ],
                                                            ),
                                                            Divider(
                                                              height: 12,
                                                              color:
                                                                  Colors.grey,
                                                              thickness: 0.3,
                                                            ),
                                                            FittedBox(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      "Cargo:  ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                ],
                                                              ),
                                                            ),
                                                            Divider(
                                                              height: 12,
                                                              color:
                                                                  Colors.grey,
                                                              thickness: 0.2,
                                                            ),
                                                            FittedBox(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      "Área:  ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              Visibility(
                                                visible: buscarEmpleado,
                                                child: Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Card(
                                                        elevation: 0,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text("DNI:  ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Text(
                                                                    "       ${widget.dni}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        height:
                                                                            1.5)),
                                                              ],
                                                            ),
                                                            Divider(
                                                              height: 15,
                                                              color:
                                                                  Colors.grey,
                                                              thickness: 0.3,
                                                            ),
                                                            FittedBox(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      "Cargo:  ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  Text(
                                                                      "   ${widget.cargo}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          height:
                                                                              1.5)),
                                                                ],
                                                              ),
                                                            ),
                                                            Divider(
                                                              height: 15,
                                                              color:
                                                                  Colors.grey,
                                                              thickness: 0.2,
                                                            ),
                                                            FittedBox(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      "Área:  ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  Text(
                                                                      "     ${widget.area}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          height:
                                                                              1.5)),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Divider(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Visibility(
                                              visible: !buscarEmpleado,
                                              child: Icon(
                                                Icons.apartment_rounded,
                                                size: 18,
                                              )),
                                          Visibility(
                                            visible: buscarEmpleado,
                                            child: RichText(
                                                text: TextSpan(children: [
                                              WidgetSpan(
                                                  child: Icon(
                                                Icons.apartment_rounded,
                                                size: 18,
                                              )),
                                              WidgetSpan(
                                                  child: SizedBox(
                                                width: 10,
                                              )),
                                              TextSpan(
                                                  text:
                                                      '${widget.organizacion}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 11,
                                                  )),
                                            ])),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Fila FECHA / HORA

    /*
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              child: fechaHora(),
                            ),

     */
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:4.0, vertical: 4.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: vw*0.42,
                                    child:   InputTextField(
                                      controller: fechaTxt,
                                      readOnly: true,
                                      onTap: () async {
                                        _selectDay(context);

                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Seleccione';
                                        }
                                        return null;
                                      },
                                      trailingIcon: const InputTrailingIcon(
                                        FontAwesomeIcons.calendar,
                                        color: S2BColors.primaryColor,
                                      ),
                                      placeholder: "Fecha Entrega",
                                    ),
                                  ),
                                  Container(
                                    width: vw*0.42,
                                    child: InputTextField(
                                      controller: horaTxt,
                                      readOnly: true,
                                      onTap: () async {
                                        final selectHour =
                                        await showCupertinoModalPopup<String>(
                                          context: context,
                                          builder: (_) => SelectHour(
                                            title: 'Hora',
                                            initial:
                                            horaTxt.text.isEmpty ? null : horaTxt.text,
                                            onTapOk: (value) {
                                              Navigator.pop(context, value);
                                            },
                                          ),
                                        );
                                        if (selectHour != null) {
                                          horaTxt.text = selectHour;
                                        }
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Seleccione';
                                        }
                                        return null;
                                      },
                                      trailingIcon: const InputTrailingIcon(
                                        FontAwesomeIcons.clock,
                                        color: S2BColors.primaryColor,
                                      ),
                                      placeholder: "Hora Entrega",
                                    ),
                                  )
                                ],
                              ),
                          ),

                            Divider(height: 10, color: Colors.grey),

                            Visibility(
                              visible: buscarEmpleado,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 150,
                                      child: TextButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xff09357E)),
                                          onPressed: () async {
                                            codigoProd.text = '';

                                            if (hasData == false) {
                                              identify = identify + 1;
                                              int responseEntregaEpp =
                                                  await sqlDb.insertData(
                                                      "INSERT INTO 'EntregaEpp' "
                                                      "('identify',   'id_emp', 'fb_empleado_id',     'hora_entrega',            'dni',        'nombreCompleto',       'fb_area_id',              'area_codigo',          'area_nombre',     'fb_cargo_id',             'cargo_codigo',         'cargo_nombre',      'fb_puesto_trabajo_id',              'puesto_trabajo_codigo',                      'puesto_trabajo_nombre',         'epp_rol_epp_id',         'codigo_rol',           'nombre_rol',                     'fb_uea_pe_id',         'fecha_entrega',    'epp_ficha_entrega_id',       'ficha_entrega_codigo',     'estado' ) VALUES "
                                                      "('${identify}',  '${widget.id}', '${widget.fb_empleado_id}',    '${horaTxt.text}',    '${widget.dni}',    '${widget.nombre}',    '${widget.fb_area_id}', '${widget.areaCod}',      '${widget.area}', '${widget.fb_cargo_id}',   '${widget.cargoCod}',    '${widget.cargo}',      '${widget.fb_puesto_trabajo_id}',  '${widget.puesto_trabajo_codigo}',    '${widget.puesto_trabajo_nombre}',      '${widget.epp_rol_epp_id}', '${widget.rol_epp_codigo}', '${widget.rol_epp_nombre}', '${widget.fb_uea_pe_id}', '${fechaTxt.text}',       '1',                            'EPP000',             '1')");
                                              print(
                                                  "Entrega EPP ============> ${responseEntregaEpp}");
                                              print(
                                                  "El indentify es===> ${identify} ");

                                              }
                                            //=============================
                                            _dialogBuilder(context).then(
                                                (_) => refreshAfter(1000));
                                          },
                                          icon: Icon(
                                            Icons.add_box_rounded,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            "Agregar EPP ",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                                    Visibility(
                                      visible: finalizarVisible,
                                      child: Container(
                                        width: 130,
                                        child: TextButton.icon(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(
                                                    0xffEF8E3B) //, 'foto_evidencia' = '${base64Image}'
                                                ),
                                            onPressed: () async {
                                              if (image?.path == null ||
                                                  image?.path == '') {
                                                AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.warning,
                                                  headerAnimationLoop: false,
                                                  showCloseIcon: true,
                                                  closeIcon:
                                                      const Icon(Icons.close),
                                                  title: 'Error',
                                                  desc:
                                                      'Registre una evidencia de los equipos a enviar',
                                                  btnCancelOnPress: () {},
                                                  onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dismiss from callback $type');
                                                  },
                                                  btnOkOnPress: () async {},
                                                ).show();
                                              } else if (hasData == false) {
                                                AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.warning,
                                                  headerAnimationLoop: false,
                                                  showCloseIcon: true,
                                                  closeIcon:
                                                      const Icon(Icons.close),
                                                  title: 'Error',
                                                  desc:
                                                      'Registre al menos un equipo a enviar',
                                                  btnCancelOnPress: () {},
                                                  onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dismiss from callback $type');
                                                  },
                                                  btnOkOnPress: () async {},
                                                ).show();
                                              } else {
                                                int response = await sqlDb.insertData(
                                                    "UPDATE 'producto_empleado_mina' "
                                                    " SET 'fecha_entrega' = '${fechaTxt.text}', 'hora_entrega' = '${horaTxt.text}', 'foto_evidencia' = '${path}', 'estado_subido' = 'Por Enviar', 'anho' = '${fechaTxt.text.substring(0, 4)}' "
                                                    " WHERE producto_empleado_mina.id_empleado = ${widget.id} AND producto_empleado_mina.estado_subido = 'En Registro' ");
                                                print(
                                                    response); /*Agregar foto_evidencia*/

                                                //FIXME: Guardar img localmente

                                                List<Map> selectall =
                                                    await sqlDb.readDataString(
                                                        "SELECT * FROM producto_empleado_mina");
                                                print(
                                                    "CONTENIDO PROD_EMP ---> ${selectall}");

                                                //Registro exitoso
                                                AwesomeDialog(
                                                  context: context,
                                                  animType: AnimType.leftSlide,
                                                  headerAnimationLoop: false,
                                                  dialogType:
                                                      DialogType.success,
                                                  showCloseIcon: true,
                                                  title: 'Registrado',
                                                  desc:
                                                      'El empleado ${widget.nombre} ha sido registrado para la entrega EEP',
                                                  btnOkOnPress: () {
                                                    Nav.go(
                                                        context,
                                                        BottomNavLayout(
                                                          lazyLoadPages: true,
                                                          pages: [
                                                            (_) =>
                                                                ListaPersonal(
                                                                  sede: sedeEmp,
                                                                ),
                                                            (_) =>
                                                                EstadisticaEntrega(),
                                                          ],
                                                          bottomNavigationBar:
                                                              (currentIndex,
                                                                      onTap) =>
                                                                  BottomNavigationBar(
                                                            currentIndex:
                                                                currentIndex,
                                                            onTap: (index) =>
                                                                onTap(index),
                                                            selectedItemColor:
                                                                Colors.orange,
                                                            items: [
                                                              BottomNavigationBarItem(
                                                                  icon: Icon(Icons
                                                                      .list_alt),
                                                                  label:
                                                                      'Lista'),
                                                              BottomNavigationBarItem(
                                                                  icon: Icon(Icons
                                                                      .bar_chart_outlined),
                                                                  label:
                                                                      'Estadisticas'),
                                                            ],
                                                          ),
                                                        )
                                                    );
                                                  },

                                                  btnOkIcon: Icons.check_circle,
                                                  onDismissCallback: (type) {
                                                    debugPrint(
                                                        'Dialog Dissmiss from callback $type');
                                                  },
                                                ).show();
                                              }
                                            },

                                            icon: Icon(
                                              Icons.check_box,
                                              color: Colors.white,
                                            ),

                                            label: Text(
                                              " Finalizar",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            Visibility(
                              visible: buscarEmpleado,
                              child: FutureBuilder(
                                  future: apiEntrega.readDataProd(idEmpleado),
                                  //Leer datos de la tabla
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<dynamic>> snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, i) {
                                            if (snapshot.data!.length == 0) {
                                              hasData = false;
                                              print("hasData ==> ${hasData}");
                                              print(
                                                  "snapshot---> ${snapshot.data!}");
                                            } else if (snapshot.data!.length !=
                                                0) {
                                              hasData = true;

                                              //Agregado 05/02 22:17

                                              //????????????????

                                              print("hasData ==> ${hasData}");

                                              print(
                                                  "snapshot---> ${snapshot.data!}");
                                            }

                                            if (snapshot.data![i]['foto_prod']
                                                .isEmpty) {
                                              imgProduct =
                                                  'productoDefault.png';
                                              //   hasData=false;
                                              //  print("hasData ==> ${hasData}");

                                            } else if (snapshot
                                                .data![i]['foto_prod']
                                                .isNotEmpty) {
                                              imgProduct =
                                                  '${snapshot.data![i]['foto_prod']}';

                                            }

                                            return Card(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  //FOTO PRODUCTO AGREGADO
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Image.asset(
                                                      "assets/images/$imgProduct",
                                                      height: 100,
                                                      width: 100,
                                                    ),
                                                  ),

                                                  Container(
                                                      width: 10,
                                                      height: 100,
                                                      child: VerticalDivider(
                                                          thickness: 0.3,
                                                          color: Colors.grey)),

                                                  Flexible(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 12.0,
                                                        top: 8.0,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            "${snapshot.data![i]['equipo_nombre']}",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            height: 2,
                                                          ),
                                                          Text(
                                                            "Código: ${snapshot.data![i]['codigo']}",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.grey),
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                            "${snapshot.data![i]['marca']}",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          SizedBox(
                                                            height: 2,
                                                          ),
                                                          Text(
                                                            "${snapshot.data![i]['nombre_proveedor']}",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .black,
                                                                height: 1.5),
                                                          ),

                                                          //Verificar Cantidades ----- Relacionar con tabla usuario
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                        "Cantidad:  ",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16)),
                                                                    Text(
                                                                      "${snapshot.data![i]['cantidad']}",
                                                                      //tabla producto_empleado
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 20,
                                                              ),
                                                              IconButton(

                                                                onPressed:
                                                                    () async {
                                                                  AwesomeDialog(
                                                                    context:
                                                                        context,
                                                                    dialogType:
                                                                        DialogType
                                                                            .warning,
                                                                    headerAnimationLoop:
                                                                        false,
                                                                    showCloseIcon:
                                                                        true,
                                                                    closeIcon:
                                                                        const Icon(
                                                                            Icons.close),
                                                                    title:
                                                                        'Eliminar',
                                                                    desc:
                                                                        '¿Estás seguro que quieres eliminar el producto: ${snapshot.data![i]['equipo_nombre']}',
                                                                    btnCancelOnPress:
                                                                        () {},
                                                                    onDismissCallback:
                                                                        (type) {
                                                                      debugPrint(
                                                                          'Dialog Dismiss from callback $type');
                                                                    },
                                                                    btnOkOnPress:
                                                                        () async {
//AND producto_empleado_mina.estado_subido = ${snapshot.data![i]['estado_subido']}
                                                                      int response = await sqlDb.deleteData(
                                                                          " DELETE FROM producto_empleado_mina"
                                                                          " WHERE producto_empleado_mina.id = ${snapshot.data![i]['id']} "
                                                                          " AND producto_empleado_mina.id_empleado = ${widget.id} "
                                                                          "  ");
                                                                      response;
                                                                      print(
                                                                          response);

                                                                      int responseEpp = await sqlDb.deleteData(
                                                                          " DELETE FROM EntregaDetalleEpp"
                                                                          " WHERE EntregaDetalleEpp.epp_entrega_detalle_id = ${snapshot.data![i]['id']} "
                                                                          " AND EntregaDetalleEpp.id_emp = ${widget.id} "
                                                                          "  ");
                                                                      responseEpp;

                                                                      flag =
                                                                          response;
                                                                    },
                                                                  ).show().then(
                                                                      (value) =>
                                                                          setState(
                                                                              () {
                                                                            print("setstate===================");
                                                                            print("flagg---->$flag");
                                                                            print("snap  length ---->${snapshot.data!.length}");

                                                                            if (snapshot.data!.length ==
                                                                                1) {
                                                                              finalizarVisible = false;
                                                                              imgEvidenciaVisible = false;
                                                                              flag = 0;
                                                                            }
                                                                          }));
                                                                },
                                                                icon: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .redAccent,
                                                                  size: 22,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    }

                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }),
                            ),

                            //======>IMG no hay productos asignados
                            SizedBox(
                              height: 10,
                            ),

                            Visibility(
                              visible: visible,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    image != null
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Visibility(
                                              visible: fotoEvidencia,
                                              child: Column(
                                                children: [
                                                  DottedBorder(
                                                    padding:
                                                        EdgeInsets.all(4.0),
                                                    color: Color(0xff00297B),
                                                    radius:
                                                        Radius.circular(10.0),
                                                    strokeWidth: 2,
                                                    dashPattern: [10, 5],
                                                    customPath: (size) {
                                                      return Path()
                                                        ..moveTo(10, 0)
                                                        ..lineTo(
                                                            size.width - 10, 0)
                                                        ..arcToPoint(
                                                            Offset(
                                                                size.width, 10),
                                                            radius:
                                                                Radius.circular(
                                                                    10))
                                                        ..lineTo(size.width,
                                                            size.height - 10)
                                                        ..arcToPoint(
                                                            Offset(
                                                                size.width - 10,
                                                                size.height),
                                                            radius:
                                                                Radius.circular(
                                                                    10))
                                                        ..lineTo(
                                                            10, size.height)
                                                        ..arcToPoint(
                                                            Offset(
                                                                0,
                                                                size.height -
                                                                    10),
                                                            radius:
                                                                Radius.circular(
                                                                    10))
                                                        ..lineTo(0, 10)
                                                        ..arcToPoint(
                                                            Offset(10, 0),
                                                            radius:
                                                                Radius.circular(
                                                                    10));
                                                    },
                                                    child: ClipRRect(
                                                      //
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Image.file(
                                                              File(image!.path),
                                                              fit: BoxFit.fill,
                                                              //   width: MediaQuery.of(context).size.width,
                                                              //  height: 170,
                                                            ),
                                                            Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  print(
                                                                      'Eliminar imagen');
                                                                  setState(() {
                                                                    print(
                                                                        'set new state of images');
                                                                  });
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xff0A3987),
                                                                      border: Border.all(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              Colors.white),
                                                                      borderRadius: BorderRadius.only(
                                                                          topRight: Radius.circular(
                                                                              40.0),
                                                                          bottomRight: Radius.circular(
                                                                              40.0),
                                                                          topLeft: Radius.circular(
                                                                              40.0),
                                                                          bottomLeft:
                                                                              Radius.circular(40.0)),
                                                                    ),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        fotoEvidencia = false;
                                                                        noEvidencia = true;
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(2.0),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .close_rounded,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              18,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 12),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.photo,
                                                          size: 15,
                                                          color: Color(
                                                              0xff0A3987)),
                                                      SizedBox(width: 10),
                                                      Text("Evidencia",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff0A3987),
                                                              fontWeight: FontWeight.w500))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : Text(""),
                                    Visibility(
                                      visible: !fotoEvidencia,
                                      child: Visibility(
                                        visible: noEvidencia,
                                        child: InkWell(
                                          onTap: () => myAlert(),
                                          child: DottedBorder(
                                            padding: EdgeInsets.all(4.0),
                                            color: Color(0xff00297B),
                                            radius: Radius.circular(10.0),
                                            strokeWidth: 2,
                                            dashPattern: [10, 5],
                                            customPath: (size) {
                                              return Path()
                                                ..moveTo(10, 0)
                                                ..lineTo(size.width - 10, 0)
                                                ..arcToPoint(
                                                    Offset(size.width, 10),
                                                    radius: Radius.circular(10))
                                                ..lineTo(size.width,
                                                    size.height - 10)
                                                ..arcToPoint(
                                                    Offset(size.width - 10,
                                                        size.height),
                                                    radius: Radius.circular(10))
                                                ..lineTo(10, size.height)
                                                ..arcToPoint(
                                                    Offset(0, size.height - 10),
                                                    radius: Radius.circular(10))
                                                ..lineTo(0, 10)
                                                ..arcToPoint(Offset(10, 0),
                                                    radius:
                                                        Radius.circular(10));
                                            },
                                            child: Visibility(
                                              visible: noEvidencia,
                                              child: Container(
                                                decoration: BoxDecoration(
/*
                                                      border: Border.all(
                                                        width: 2.0,

 */
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              5.0) //
                                                          ),
                                                ),
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      'assets/icons/subir_evidencia_2.png',
                                                      height: 50,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Registrar Evidencia",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //=====>  Escanear productos
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
      ),
    );
  }

  void sendProdInfo(BuildContext context, String codigo) async {
    //sendInfoProduct

    List<Map> datoEscaneadoProd =
        await sqlDb.readData("SELECT * FROM productoMina "
            " WHERE productoMina.codigo = '$codigo' ");
    print(datoEscaneadoProd);

    if (datoEscaneadoProd.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductInfo(
            //Mandar  Empleado
            idEmp: idEmpleado,
            //Identificador entrega
            identify: identify,

            //Mandar info Producto
            idProd: datoEscaneadoProd.first["id"],
            codigo: datoEscaneadoProd.first["codigo"],
            nombre: datoEscaneadoProd.first["equipo_nombre"],
            marca: datoEscaneadoProd.first["marca"],
            modelo: datoEscaneadoProd.first["modelo"],
            proveedor: datoEscaneadoProd.first["nombre_proveedor"],
            observacion: datoEscaneadoProd.first["observacion"],
            descripcion: datoEscaneadoProd.first["equipo_descripcion"],
            foto_prod: datoEscaneadoProd.first["foto_prod"],
            fechaEntrega: fechaTxt.text,
            horaEntrega: horaTxt.text,
            tipo_equipo: datoEscaneadoProd.first["tipo_equipo_nombre"],
            costo: datoEscaneadoProd.first["costo"],
            tiempo_recambio: datoEscaneadoProd.first["tiempo_recambio"],
            tipo_equipo_codigo: datoEscaneadoProd.first["tipo_equipo_codigo"],
            tipo_equipo_id: datoEscaneadoProd.first["tipo_equipo_id"],
            equipo_id: datoEscaneadoProd.first["epp_equipo_id"],
            producto_id: datoEscaneadoProd.first["epp_producto_id"],
            equipo_codigo: datoEscaneadoProd.first["equipo_codigo"],

          ),
        ),
      ).then((_) => setState(() {
                Navigator.pop(context);
              }) //===>Actualizar estado despues de escanear un item
          );
    } else if (datoEscaneadoProd.isEmpty) {
      print("No existe");

      codigoProd.text = '';

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            height: 125,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.warning_rounded,
                                color: Color(0xff00297B),
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Error',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff00297B),
                                    fontWeight: FontWeight.bold),
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 0.5,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            'No encontramos el código "${codigo}"\nen nuestros registros.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffFF9801),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Volver",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                )),
          ],
        ),
      );
    }
    print("FOTO PROD----> ${datoEscaneadoProd[0]['foto_prod']}");

  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          backgroundColor: Colors.white,
          content: Container(
            height: 180,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  padding: EdgeInsets.zero,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff00297B),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.close,
                          color: Color(0xff00297B),
                        ),
                        Text(
                          "Agregar EPP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Agregar por Código:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                              ],
                            ),
                            SizedBox(height: 5,),
                            TextFormField(
                              controller: codigoProd,
                              onFieldSubmitted: (value) {
                                print("El valor es: " +
                                    codigoProd.text.toString().toUpperCase());
                                sendProdInfo(context,
                                    codigoProd.text.toString().toUpperCase());
                              },
                              textInputAction: TextInputAction.search,
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[],
                              decoration: InputDecoration(
                                labelStyle: TextStyle(fontSize: 14),
                                labelText: "Código",
                                hintText: "P0001",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    print("El valor es: " +
                                        codigoProd.text.toString().toUpperCase());
                                    sendProdInfo(context,
                                        codigoProd.text.toString().toUpperCase());
                                    /*
                                    Navigator.pop(context);
                                    sendProdInfo(
                                        context, codigoProd.toString());
                                    setState(() {});
                                    */

                                    },
                                  icon: Icon(Icons.search_sharp),
                                ),
                              ),
                            ),
                            /*
                            SizedBox(
                              height: 15,
                            ),
                            Divider(),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Agregar por Escaneo:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            IconButton(
                              icon: Image.network(
                                  "https://static.thenounproject.com/png/74445-200.png"),
                              iconSize: 70,
                              onPressed: () {
                                //Camara de Escaner
                                scanBarcodeNormal();
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Escaneo de Código de Barras",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            )
                            */
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
          actions: <Widget>[],
        );
      },
    );
  }

  void refreshAfter(int milisec) {
    Future.delayed(Duration(milliseconds: milisec), () {
      setState(() {});
      if (hasData == true) {
        finalizarVisible = true;
        imgEvidenciaVisible = true;
        noEvidencia = true;

      } else {
        finalizarVisible = false;
        noEvidencia = false;
      }

      
      print("Actualizacion...");
    });
  }

  void refreshAfter2() {
    Future.delayed(Duration(milliseconds: 2300), () {
      setState(() {});
      print("Actualizacion...");
    });
  }


  Future<void> _selectDay(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.white,
          child: MaterialCalendarWithChild(
            initialDate: dateSelected,
            firstDate: DateTime.now().add(
              const Duration(days: -3650),
            ),
            lastDate: DateTime.now().add(
              const Duration(days: 0),
            ),
            onDateChanged: (d) {
              dateSelected = d;
              fechaTxt.text = d.formatLocalFech2;
              print('fecha format == ${fechaTxt.text}');
              print('fecha format2 == ${d.formatLocalFech2}');
              Navigator.pop(
                context,
              );
            },
          ),
        );
      },
    );
  }

}

class MySearchDelegate extends SearchDelegate {
  MySearchDelegate({
    String hintText = "Buscar Empleado",
  }) : super(
          searchFieldLabel: hintText,
          searchFieldStyle:
              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//    searchFieldDecorationTheme: ,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  SqlDb sqlDb = SqlDb();

  @override
  List<Widget>? buildActions(BuildContext context) {
    Future<void> _dialogBuilder(BuildContext context) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 6), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              side: BorderSide(color: Color(0xff09357E), width: 1.5),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 25,
                    ),
                    Wrap(
                      children: [
                        Text(
                          "Actualizando Lista...",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            backgroundColor: Colors.white,
            actions: <Widget>[],
          );
        },
      );
    }

    Future<void> _dialogBuilderUpdate(BuildContext context) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop(true);
          });

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              side: BorderSide(color: Color(0xff09357E), width: 1.5),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 25,
                    ),
                    Wrap(
                      children: [
                        Text(
                          "Actualizando Lista...",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            backgroundColor: Colors.white,
            actions: <Widget>[],
          );
        },
      );
    }

    return [
      Row(
        children: [
          Visibility(
            visible: viewRefresh,
            child: IconButton(
              onPressed: () async {
                _dialogBuilderUpdate(context);
                //  await updAllEmp();
                print("Actualizando Lista...");
              },
              icon: FaIcon(FontAwesomeIcons.refresh),
            ),
          ),
          IconButton(
              onPressed: () {
                close(context, result);
              },
              icon: Icon(Icons.close)),
        ],
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return SizedBox(width: 0);

  }

  //MUESTRA DATOS DE EMPLEADOS SEGÚN EL PARÁMETRO DE BÚSQUEDA

  @override
  Widget buildSearchField(BuildContext context) {
    return Row(
      children: <Widget>[
        Text("Search"),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Enter search term...",
            ),
            onChanged: (value) {
              query = value;
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Map>>(
          future: apiEntrega.postRequest(query),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            var data = snapshot.data;

            if (data == null) {
              print("NO HAY DATOS");
              return const Center(child: CircularProgressIndicator());
            } else {
              var datalength = data.length;
              if (count == 0) {
                return ListView(
                  padding: EdgeInsets.all(S2BRadius.md),
                  children: [
                    TextLabel.h6(
                      'Sincronización de Datos',
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      color: S2BColors.blue,
                    ),
                    Image.asset(
                      UiValues.couldSyncIconGif,
                      height: MediaQuery.of(context).size.height * .25,
                    ),
                    TextLabel.body(
                      'Ultima sincronización',
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      color: S2BColors.primaryColor,
                    ),
                  ],
                );
              } else {
                print("SI HAY DATOS ");
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: datalength,
                    itemBuilder: (context, index) {
                      if (data[index]['foto'].isEmpty) {
                        fotoUsuario = 'productoDefault.png';
                      } else if (data[index]['foto'].isNotEmpty) {
                        fotoUsuario = '${data[index]['foto']}';
                      }

                      if (!snapshot.hasData) {
                        return Column(
                          children: [
                            Container(
                                height: MediaQuery.of(context).size.height,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                  ],
                                )),
                          ],
                        );
                      }
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () async {
                              // query = query;
                              int idEmp = data[index]['id'];
                              int fb_uea_pe_id = data[index]['fb_uea_pe_id'];
                              String nom = data[index]['nombreCompleto'];
                              String cargo_emp = data[index]['cargo_nombre'];
                              String dni_emp = data[index]['numero_documento'];
                              String org_emp = data[index]['empresa'];
                              String area_emp = data[index]['area_nombre'];

                              String cargoCod_emp = data[index]['cargo_codigo'];
                              String areaCod_emp = data[index]['area_codigo'];
                              int fb_area_id = data[index]['fb_area_id'];
                              int fb_cargo_id = data[index]['fb_cargo_id'];
                              int fb_puesto_trabajo_id =
                                  data[index]['fb_puesto_trabajo_id'];
                              String puesto_trabajo_codigo =
                                  data[index]['puesto_trabajo_codigo'];
                              String puesto_trabajo_nombre =
                                  data[index]['puesto_trabajo_nombre'];

                              int epp_rol_epp_id =
                                  data[index]['epp_rol_epp_id'];
                              String rol_epp_codigo = data[index]['codigo_rol'];
                              String rol_epp_nombre = data[index]['nombre_rol'];
                              String foto_emp = data[index]['foto'];

                              //      String foto_prod = data[index]['foto_prod'];

                              print(
                                  "El datoUser es----> $idEmp, $nom, $cargo_emp, $dni_emp, $org_emp, $area_emp, $cargoCod_emp, $areaCod_emp, $fb_area_id, $fb_cargo_id, $fb_puesto_trabajo_id, $puesto_trabajo_codigo, $puesto_trabajo_nombre");

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AgregarEntrega(
                                    id: idEmp,
                                    fb_uea_pe_id: fb_uea_pe_id,
                                    nombre: nom,
                                    cargo: cargo_emp,
                                    dni: dni_emp,
                                    organizacion: org_emp,
                                    area: area_emp,

                                    cargoCod: cargoCod_emp,
                                    areaCod: areaCod_emp,
                                    fb_area_id: fb_area_id,
                                    fb_cargo_id: fb_cargo_id,
                                    fb_puesto_trabajo_id: fb_puesto_trabajo_id,
                                    puesto_trabajo_codigo:
                                        puesto_trabajo_codigo,
                                    puesto_trabajo_nombre:
                                        puesto_trabajo_nombre,
                                    epp_rol_epp_id: epp_rol_epp_id,
                                    rol_epp_codigo: rol_epp_codigo,
                                    rol_epp_nombre: rol_epp_nombre,
                                    foto: fotoUsuario,

                                  ),
                                ),
                              );

                              idEmpleado = snapshot.data![index]['id'];
                            },

                            title: Row(
                              children: [
                                SizedBox(width: 5),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${data[index]['nombreCompleto']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '${data[index]['numero_documento']}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Divider(
                                        height: 2,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Área:  ${data[index]['area_nombre']}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ])
                              ],
                            ),
                            // trailing: Text('More Info'),
                          ),
                        ),
                      );
                    });
               }
              //
             }
            }
          ),
        );
       }

  //MUESTRA LOS DATOS DE EMPLEADOS EN EL MÓDULO DE BÚSQUEDA

  @override
  Widget buildSuggestions(BuildContext context) {
    Future<void> _dialogBuilder(BuildContext context) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(Duration(milliseconds: 11500), () {
            Navigator.of(context).pop(true);
          });

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              side: BorderSide(color: Color(0xff09357E), width: 1.5),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 25,
                    ),
                    Wrap(
                      children: [
                        Text(
                          "Descargando Lista...",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            backgroundColor: Colors.white,
            actions: <Widget>[],
          );
        },
      );
    }

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        child: FutureBuilder<List<Map>>(
            future: apiEntrega.postRequest(query),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              var data = snapshot.data;
              if (data == null) {
                print("NO HAY DATOS");
                return const Center(child: CircularProgressIndicator());
              } else {
                var datalength = data.length;
                if (datalength == 0) {
                  return Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height * 1,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text("Sincronización de Datos",
                              style: TextStyle(
                                  color: S2BColors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Image.asset(
                          UiValues.couldSyncIconGif,
                          height: MediaQuery.of(context).size.height * .35,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Módulo de Entrega EPP",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 40,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  backgroundColor: S2BColors.primaryColor),
                              onPressed: () {
                                _dialogBuilder(context);

                                apiEntrega.getAllEmp();
                                apiEntrega.getAllProd();

                                sync = 1;
                                setState(() {});

                                Future.delayed(
                                    const Duration(milliseconds: 4000), () {
                                  query = " ";
                                });
                              },
                              child: Text("Descargar")),
                        )
                      ],
                    ),
                  );
                } else {
                  print("SI HAY DATOS ");
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: datalength,
                      itemBuilder: (context, index) {
                        if (!snapshot.hasData) {
                          return Column(
                            children: [
                              Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                    ],
                                  )),
                            ],
                          );
                        }
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () async {
                                // query = query;
                                int idEmp = data[index]['id'];
                                int fb_uea_pe_id = data[index]['fb_uea_pe_id'];
                                String nom = data[index]['nombreCompleto'];
                                String cargo_emp = data[index]['cargo_nombre'];
                                String dni_emp =
                                    data[index]['numero_documento'];
                                String org_emp = data[index]['empresa'];
                                String area_emp = data[index]['area_nombre'];
                                String cargoCod_emp =
                                    data[index]['cargo_codigo'];
                                String areaCod_emp = data[index]['area_codigo'];
                                int fb_area_id = data[index]['fb_area_id'];
                                int fb_cargo_id = data[index]['fb_cargo_id'];
                                int fb_puesto_trabajo_id =
                                    data[index]['fb_puesto_trabajo_id'];
                                String puesto_trabajo_codigo =
                                    data[index]['puesto_trabajo_codigo'];
                                String puesto_trabajo_nombre =
                                    data[index]['puesto_trabajo_nombre'];
                                int epp_rol_epp_id =
                                    data[index]['epp_rol_epp_id'];
                                String rol_epp_codigo =
                                    data[index]['codigo_rol'];
                                String rol_epp_nombre =
                                    data[index]['nombre_rol'];
                                String foto_emp = data[index]['foto'];

                                print(
                                    "El datoUser es----> $idEmp, $nom, $cargo_emp, $dni_emp, $org_emp, $area_emp, $cargoCod_emp, $areaCod_emp, $fb_area_id, $fb_cargo_id, $fb_puesto_trabajo_id, $puesto_trabajo_codigo, $puesto_trabajo_nombre");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AgregarEntrega(
                                      id: idEmp,
                                      fb_uea_pe_id: fb_uea_pe_id,
                                      nombre: nom,
                                      cargo: cargo_emp,
                                      dni: dni_emp,
                                      organizacion: org_emp,
                                      area: area_emp,

                                      cargoCod: cargoCod_emp,
                                      areaCod: areaCod_emp,
                                      fb_area_id: fb_area_id,
                                      fb_cargo_id: fb_cargo_id,
                                      fb_puesto_trabajo_id:
                                          fb_puesto_trabajo_id,
                                      puesto_trabajo_codigo:
                                          puesto_trabajo_codigo,
                                      puesto_trabajo_nombre:
                                          puesto_trabajo_nombre,
                                      epp_rol_epp_id: epp_rol_epp_id,
                                      rol_epp_codigo: rol_epp_codigo,
                                      rol_epp_nombre: rol_epp_nombre,
                                      foto: foto_emp,

                                      //   foto: "https://pps.whatsapp.net/v/t61.24694-24/257005143_817856682799244_3975692651582535116_n.jpg?ccb=11-4&oh=01_AdTrg_vv-ousX8fiiBdzjzGqaUwh-GhHR4EEJc6m3HLmCw&oe=63B8291E",

                                      // cantidad: datoUser.first["cantidad"],
                                    ),
                                  ),
                                );

                                idEmpleado = snapshot.data![index]['id'];
                              },
                              title: Row(
                                children: [
                                  SizedBox(width: 5),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${data[index]['nombreCompleto']}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '${data[index]['numero_documento']}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Divider(
                                          height: 2,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Área:  ${data[index]['area_nombre']}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ])
                                ],
                              ),
                              // trailing: Text('More Info'),
                            ),
                          ),
                        );
                      });
                  }
              }
            }),
      );
    });
  }



}

