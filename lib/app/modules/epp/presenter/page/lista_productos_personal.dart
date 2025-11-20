import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe2biz/app/global/core/shared_widgets/toast/toast.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/scan_info_prod.dart';
//import 'package:safe2biz/app/modules/epp/presenter/page/scan_info_user.dart';

//variable idProd edit
int? id_Prod;

class ListaProdPersonal extends StatefulWidget {

  final int? idEmp;
                //prod     //emp       emp     emp        emp-->                               |   prod        prod_emo     prod
  final String? codigo, organizacion, nombre, dni, cargo, area, f_entrega, h_entrega, foto_emp, id_prod, foto_evidencia, foto_prod, estado_subido;

  const ListaProdPersonal({Key? key, this.nombre, this.dni, this.area, this.cargo, this.codigo, this.organizacion, this.idEmp, this.f_entrega, this.h_entrega, this.id_prod, this.foto_evidencia, this.foto_prod, this.foto_emp, this.estado_subido}) : super(key: key);
  @override
  State<ListaProdPersonal> createState() => _ListaProdPersonalState();

}

String? pathFoto;  //path from temp files
String? fotoEmpleado;
String? evidenciaRegistro;
String? fotoProd;
String? fotoEvidencia;

bool evidenciaFlag = false;
bool noEvidence = true;

Color? colorEstado;

class _ListaProdPersonalState extends State<ListaProdPersonal> {

  bool isSwitched = false;
  String scanBarcode = 'Desconocido';
  SqlDb sqlDb = SqlDb();

    Future<List<Map>> readData() async {
    List<Map> responseRead = await sqlDb.readData("SELECT * FROM productoMina");
    return responseRead;
  }

  Future<List<Map>> readDataProd(int? id_emp) async {

    List<Map> responseFoto = await sqlDb.readData(
        "SELECT producto_empleado_mina.foto_evidencia "
            " FROM producto_empleado_mina ");
    pathFoto = responseFoto[0]['foto_evidencia'];
    print("pathFoto----> ${pathFoto}");


    List<Map> responseRead = await sqlDb.readData(""
        "SELECT empleadoMina.id, empleadoMina.nombreCompleto, empleadoMina.empresa, empleadoMina.foto, productoMina.codigo, productoMina.equipo_nombre, productoMina.foto_prod, productoMina.marca, productoMina.codigo, productoMina.nombre_proveedor, productoMina.modelo, productoMina.equipo_descripcion, producto_empleado_mina.cantidad, producto_empleado_mina.fecha_entrega, producto_empleado_mina.hora_entrega, producto_empleado_mina.foto_evidencia, productoMina.tipo_equipo_nombre  "
        "FROM producto_empleado_mina "
        " INNER JOIN productoMina ON productoMina.id = producto_empleado_mina.id_producto"
        " INNER JOIN empleadoMina ON empleadoMina.id = producto_empleado_mina.id_empleado "
        " WHERE empleadoMina.id = '${id_emp}'"
        " AND producto_empleado_mina.fecha_entrega = '${widget.f_entrega}' AND producto_empleado_mina.hora_entrega = '${widget.h_entrega}'");
    return responseRead;
  }


  //Leer datos del db en la pantalla





  @override
  Future<void>  scanBarcodeNormal() async {
    Toast.show(
      description: 'Escaner por agregar..',
      toastType: ToastType.error,
    );
  }

  @override
  void initState(){
      super.initState();




      evidenciaRegistro = widget.foto_evidencia;

      //FIXME: pasarlo a void init state??
      if(evidenciaRegistro == 'null' || evidenciaRegistro!.isEmpty || evidenciaRegistro == '') {

        print("evidencia --> ${evidenciaRegistro}");
        evidenciaFlag = false;
        noEvidence = true;
        //evidenciaRegistro = '';
      }else{
        evidenciaFlag = true;
        noEvidence = false;
      }


      print("foto evidencia ---> ${widget.foto_evidencia}");

      if(widget.estado_subido == 'En Registro'){
        evidenciaFlag = false;
        colorEstado = Color(0xffFF7777);
      }
      else if(widget.estado_subido == 'Por Enviar'){
        evidenciaFlag = true;
        colorEstado = Color(0xffFFBA55);
      }
      else if(widget.estado_subido == 'Enviado'){
        colorEstado = Color(0xff67A856);
      }
    }



  @override
  Widget build(BuildContext context) {

    fotoEmpleado = widget.foto_emp;


    if(fotoEmpleado!.isEmpty || fotoEmpleado == null || fotoEmpleado == ""){

      fotoEmpleado = 'userDefault.png';

    }




    var dt = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: Text("Equipos Entregados", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),), backgroundColor: Color(0xff09357E),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
                Column(
                  children: [
                    SizedBox(height: 5,),
                    Card(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: <Widget>[

                          Flexible(

                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0,top: 8.0,),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      FittedBox(
                                        child: RichText(
                                            text: TextSpan(

                                                children: [

                                                  WidgetSpan(child: Icon(Icons.person, size: 20,)),

                                                  WidgetSpan(child: SizedBox(width: 10,)),

                                                  TextSpan( text:    '${widget.nombre}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ]
                                            )),
                                      ),


                                    ],
                                  ),

                                  SizedBox(height: 3,),
                                  Divider(height: 5,),
                                  SizedBox(height: 8,),

                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only (right:  12.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 0.5),
                                                color: Colors.black87,
                                              ),
                                              //Image.network("https://t3.ftcdn.net/jpg/03/39/45/96/360_F_339459697_XAFacNQmwnvJRqe1Fe9VOptPWMUxlZP8.jpg",
                                              child: Image.asset('assets/images/$fotoEmpleado',
                                                height: 75,
                                                width: 70,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Card(
                                                elevation: 0,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("DNI:  ",style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                                        Text("       ${widget.dni}" ,
                                                            style: TextStyle(fontSize: 11, height: 1.5)),

                                                      ],
                                                    ),


                                                    Divider(
                                                      height: 15,
                                                      color: Colors.grey ,
                                                      thickness: 0.3,
                                                    ),

                                                    FittedBox(
                                                      child:      Row(
                                                        children: [
                                                          Text("Cargo:  ",style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                                          Text("   ${widget.cargo}" ,
                                                              style: TextStyle(fontSize: 11, height: 1.5)),
                                                        ],
                                                      ),
                                                    ),

                                                    Divider(
                                                      height: 15,
                                                      color: Colors.grey,
                                                      thickness: 0.2,
                                                    ),

                                                    FittedBox(
                                                      child: Row(
                                                        children: [
                                                          Text("Área:  ",style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                                          Text("     ${widget.area}" ,
                                                              style: TextStyle(fontSize: 11, height: 1.5)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),


                                  SizedBox(height: 10,),
                                  Divider(height: 5,),
                                  SizedBox(height: 7,),



                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Container(
                                          width: MediaQuery.of(context).size.width*0.5,
                                          child: Row(
                                            children: [
                                              Icon(Icons.apartment_rounded, size: 18, ),
                                              SizedBox(width: 8,),
                                              Expanded(
                                                child: Text("${widget.organizacion}",   style: TextStyle(
                                                  color: Colors.black,
                                                  height: 1.5,
                                                  fontSize: 10,)),
                                              ),
                                            ],
                                          ),
                                        ),


                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Container(
                                              width: 110,
                                              height: 24,
                                              child:  ElevatedButton(onPressed: (){}, child: Text("${widget.estado_subido}"),
                                                  style: ElevatedButton.styleFrom(
                                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    backgroundColor: colorEstado,
                                                  )
                                                // minimumSize: Size(60, 24), ),
                                              )
                                          ),
                                        ),

                                      ],
                                    ),
                                  SizedBox(height:10,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),



    //Fecha Asignada
                    SizedBox(height: 4,),
    Divider(),
    Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Text("Fecha: ${widget.f_entrega}", style: TextStyle(fontWeight: FontWeight.w500),),
            Text("Hora: ${widget.h_entrega} ", style: TextStyle(fontWeight: FontWeight.w500),)
          ],
        ),

    ),
Divider(),





    FutureBuilder(
          future: readDataProd(widget.idEmp),
          builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot ){
            if(snapshot.hasData){



              return
                ListView.builder(
                    itemCount: snapshot.data!.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, i){

                      fotoProd = snapshot.data![i]['foto_prod'];

                      if(fotoProd == null || fotoProd == ''){
                           fotoProd = 'productoDefault.png';
                           print("Foto Prod --> ${fotoProd}");
                      }


                      return  Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            //FOTO PRODUCTO AGREGADO
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/images/${fotoProd}",
                                height: 100,
                                width: 100,
                              ),
                            ),

                            Container(width: 10, height: 100, child: VerticalDivider( thickness: 0.3, color: Colors.grey)),

                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("${snapshot.data![i]['equipo_nombre']}",
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                    SizedBox(height: 2,),
                                    Text("Código: ${snapshot.data![i]['codigo']}",
                                      style: TextStyle(fontSize: 12, color: Colors.grey), ),
                                    SizedBox(height: 4,),
                                    Text("${snapshot.data![i]['marca']}",
                                      style: TextStyle(fontSize: 12, color: Colors.grey), ),
                                    SizedBox(height: 2,),
                                    Text("${snapshot.data![i]['nombre_proveedor']}",
                                      style: TextStyle(fontSize: 11, color: Colors.black, height: 1.5), ),

                                    //Verificar Cantidades ----- Relacionar con tabla usuario
                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Text("Cantidad:  ",
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                              Text("${snapshot.data![i]['cantidad']}", //tabla producto_empleado
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                            ],
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
            return Center(child: CircularProgressIndicator(),);
          }),
                    SizedBox(height: 30,),
            Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width/2,
                                  ),

                                    Container(

                                      width: MediaQuery.of(context).size.width/2,
                                      child: Column(
                                        children: [
                                          Visibility(
                                           visible: evidenciaFlag,
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
                                                  ..arcToPoint(Offset(
                                                      size.width - 10,
                                                      size.height),
                                                      radius: Radius.circular(10))
                                                  ..lineTo(10, size.height)
                                                  ..arcToPoint(
                                                      Offset(0, size.height - 10),
                                                      radius: Radius.circular(10))
                                                  ..lineTo(0, 10)
                                                  ..arcToPoint(Offset(10, 0),
                                                      radius: Radius.circular(10));
                                              },

                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.file(
                                                  File("${evidenciaRegistro}"),
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                ),
                                              ),
                                            ),
                                          ),

                                 Visibility(
                                   visible: noEvidence,
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
                                         ..arcToPoint(Offset(
                                             size.width - 10,
                                             size.height),
                                             radius: Radius.circular(10))
                                         ..lineTo(10, size.height)
                                         ..arcToPoint(
                                             Offset(0, size.height - 10),
                                             radius: Radius.circular(10))
                                         ..lineTo(0, 10)
                                         ..arcToPoint(Offset(10, 0),
                                             radius: Radius.circular(10));
                                     },



                                     child: ClipRect(
                                       child: Padding(
                                         padding: const EdgeInsets.all(12.0),
                                         child: Column(
                                           children: [
                                             Container(
                                               height: 120,
                                               child: Image.asset("assets/gif/no_evidence.png"),
                                             ),
                                       //      Text("No hay evidencia", style: TextStyle(color:Colors.grey),)
                                           ],
                                         ),
                                       ),
                                     ),
                                   )
                                    )
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 10,),
                           Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Evidencia", style: TextStyle(fontSize: 14, color: Colors.indigo, fontWeight: FontWeight.w500),)
                              ],
                            ),
                        ],
                      ),


/*
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No hay Evidencia", style: TextStyle(fontSize: 14, color: Colors.indigo, fontWeight: FontWeight.w500),)
                      ],
                    ),

 */



                    SizedBox(height: 30,),

                    /*
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: TextButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(60, 30), backgroundColor: Colors.deepOrange,
                            ),
                            icon: Icon(Icons.delete, color: Colors.white,),
                            label: Text("Eliminar registro", style: TextStyle(color: Colors.white),),
                            onPressed: () async{
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                headerAnimationLoop: false,
                                showCloseIcon: true,
                                closeIcon: const Icon(Icons.close),
                                title: 'Eliminar',
                                desc:
                                '¿Estás seguro que quieres eliminar el registro de ${widget.nombre} con fecha ${widget.f_entrega}',
                                btnCancelOnPress: () {},
                                onDismissCallback: (type) {
                                  debugPrint('Dialog Dismiss from callback $type');
                                },
                                btnOkOnPress: () async{

                                  int response = await sqlDb.deleteData("DELETE FROM 'producto_empleado_mina' "
                                      " WHERE producto_empleado_mina.id_empleado = '${widget.idEmp}' "
                                      " AND producto_empleado_mina.fecha_entrega = '${widget.f_entrega}' ");

                                  print(response);

                                  Navigator.pop(context);

                                },
                              ).show().then((value) =>  setState(() {}));
                            },

                          ),
                        ),

                      ],
                    ),
  */

                    /*
    Column(
                        children: [
                        IconButton(
                          icon: Image.network("https://static.thenounproject.com/png/74445-200.png"),
                          iconSize: 100,
                          onPressed: () {
                            //Camara de Escaner
                            scanBarcodeNormal();
                            },
                        ),
                        Text("Escanear Producto",
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                    */
                    SizedBox(height: 15,),

                  ],
                 ),
          ],),
        ),
      ),


      );


    }


  void sendProdInfo(BuildContext context) async{



    List<Map> datoEscaneadoProd = await sqlDb.getProduct(scanBarcode.toString());
    print(datoEscaneadoProd);



    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductInfo(

          idProd:  datoEscaneadoProd.first["id"],
          codigo:  datoEscaneadoProd.first["codigo"],
          nombre:  datoEscaneadoProd.first["equipo_nombre"],
          marca: datoEscaneadoProd.first["marca"],
          descripcion: datoEscaneadoProd.first["equipo_descripcion"],
         // caracteristicas: datoEscaneadoProd.first["caracteristicas"],
          //foto: datoEscaneadoProd.first["foto"],
        ),),);
  }

//Enviar info de productos



}

  //Enviar info de productos


String getCurrentDate() {
  var date = DateTime.now().toString();
  var dateParse = DateTime.parse(date);
  var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
  return formattedDate.toString();
}



final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
void filterSearchResults(String query) {
  List<String> dummySearchList = <String>[];
  dummySearchList.addAll(duplicateItems);
  if (query.isNotEmpty) {
    List<String> dummyListData = <String>[];
    dummySearchList.forEach((item) {
      if (item.contains(query)) {
        dummyListData.add(item);
      }
    });
  }
}

























