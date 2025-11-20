import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/core/shared_widgets/navigation/nav.dart';
import 'package:safe2biz/app/global/core/styles/colors.dart';
import 'package:expandable/expandable.dart';
import 'package:http/http.dart' as http;
import 'package:safe2biz/app/modules/actos_condiciones_bot/presenter/page/actos_condiciones_page.dart';

class AyCBotDetalle extends StatefulWidget {

  final int? idAyC;
  final String? fb_id;
  AyCBotDetalle({Key? key, this.idAyC, this.fb_id}) : super(key: key);

  @override
  State<AyCBotDetalle> createState() => _AyCBotAyCBotDetalleState();
}



final localSqliteInstance = LocalSqlite();
final authController = AuthController(sqlite: localSqliteInstance);




class _AyCBotAyCBotDetalleState extends State<AyCBotDetalle> {

  List<Map<String, dynamic>> listaDesviaciones = [];
  TextEditingController desviacionesField = TextEditingController();



  TextEditingController accionInm = TextEditingController();
  TextEditingController gerenciaField = TextEditingController();
  TextEditingController areaField = TextEditingController();
  TextEditingController riesgoField = TextEditingController();


  String gerenciaId = '';

  String? corrigioAyC;

  String? accionInmediata;
  //Colores estado
  Color? colorEstado;
  //Iconos
  Icon? flag_backlog;
  Icon? contiene_pase;
  String? fechaProg;
  String? tipoRelacion;
  String? incRelacion;
  String? descCausa;
  String? solCausa;
  String? respCliTI;
  String? infInc;
  String? paqArchivos;
  String? procInstalacion;
  String? casosPruebas;
  String? procUsuario;


  String? gerencia_id;
  String? area_id;
  String? nivel_riesgo_id;
  String? origen_ayc;



  String desviaciones = 'Seleccionar';
  String nivelRiesgo = 'Seleccionar';
  String gerencia = 'Seleccionar';
  String area = 'Seleccionar';


  List<String>? listaItems;
  List<String> listaNivel = ['Bajo', 'Medio', 'Alto', 'Extremo'];



  List<String> ADMINFIN = ['ADMINISTRACIÓN Y FINANZAS', 'LEGAL', 'CONTABILIDAD Y TESORERÍA', 'SUBGERENCIA DE ADMINSITRACIÓN Y SOPORTE', 'COSTOS Y PRESUPUESTOS'];
  List<String> DESORG = ['ADMINISTRACION', 'DESARROLLO HUMANO Y ORGANIZACIONAL'];
  List<String> OPER = ['GEOLOGIA', 'LABORATORIO METALURGICO', 'MINA', 'PLANTA CONCENTRADORA', 'MANTENIMIENTO', 'LABORATORIO QUÍMICO', 'PROYECTOS', 'SEGURIDAD INTEGRAL', 'OPERACIONES'];
  List<String> RELACOM = ['RELACIONES COMUNITARIAS'];
  List<String> SSOMA = ['SSOMA'];
  List<String> BROWN = ['EXPLORACIONES/BROWNFIELD'];




  @override
  void initState(){
    super.initState();

    print("IDD ---  ${widget.idAyC}");



    gerenciaField = TextEditingController();
    areaField = TextEditingController();
    desviacionesField = TextEditingController();
    riesgoField = TextEditingController();

  }


  void asyncMethod() async {
    await RequestIncidenciasGeneralesDetalle();
  }


  @override
  Widget build(BuildContext context) {

    RequestIncidenciasGeneralesDetalle();
    return Scaffold(

        appBar: AppBar(
          title: Text("Actos y Condiciones - BOT", style: TextStyle(fontSize: 17, color: Colors.white),),
          backgroundColor: S2BColors.primaryColor,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: RequestIncidenciasGeneralesDetalle(),

            builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>

            snapshot.hasData ? ListView.builder(

                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, index) {

                  String base64_uno = "${snapshot.data![index]['imagen_uno']}";

                  String encoded_uno = base64.encode(utf8.encode(base64_uno));

                  print("imagen_uno --- > $encoded_uno");

                  String origen = "${snapshot.data![index]['origen_ayc']}";
                  origen_ayc = "${snapshot.data![index]['origen_ayc']}";

                  if(origen == 'C'){
                    origen = 'CONDICION';
                  }else if (origen == 'A'){
                    origen = 'ACTO';
                  }

                  String? area_base = snapshot.data![index]['nombre_area_base'];
                  if(area_base == 'null' || area_base == null){
                    area_base = 'No Especifíca';
                  }



              /*    String desviacion ="${snapshot.data![index]['desviacion']}";
                  if(desviacion.isEmpty){
                    desviacion='-';
                  }

               */

                  return Container(

                    width: MediaQuery.of(context).size.width*1,
                    color: Color(0XFFEBEFFB),
                    // render list item
                    child: ListTile(
                      onTap: (){

                      },

                      title:  Column(
                        children: [

                          SizedBox(height: 10,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.insert_drive_file_outlined, color: Colors.black, size: 20,),
                                  SizedBox(width: 5,),
                                  Text(" ${snapshot.data![index]['codigo']} ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Text("${snapshot.data![index]['fecha'].substring(0,10)} -" " ${snapshot.data![index]['hora'].substring(0,5)}",style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: S2BColors.primaryColor),),
                            ],
                          ),

                          Divider(height: 20,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Container(
                                width: MediaQuery.of(context).size.width*0.55,
                                child: Row(
                                  children: [


                                    FittedBox(child: Text("${snapshot.data![index]['nombre_sede']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),))
                                  ],
                                ),
                              ),



                              Container(
                                width: MediaQuery.of(context).size.width*0.35,
                                height: 30,

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 100,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: StadiumBorder(), backgroundColor: S2BColors.orange
                                        ),
                                        onPressed: () {
                                          listArea();
                                          print('boton presionado');

                                        },
                                        child: FittedBox(child: Text("${origen}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),)),
                                      ),
                                    )

                                  ],
                                ),
                              ),


                            ],
                          ),


                          Divider(height: 20,),

                          Container(
                            decoration: BoxDecoration(        color: Colors.white,  borderRadius: BorderRadius.circular(10.0) ),
                            child:   Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text("Área Base:  ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                                      Text("${area_base}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
                                    ],
                                  ),
                                  /*
                                  Row(
                                    children: [
                                      Text("Severidad:  ", style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                                      Text("${snapshot.data![index]['Nivel_Incidencia_Nombre']}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
                                    ],
                                  ),
*/
                                ],
                              ),
                            ),

                          ),
                          Divider(height: 20,),

                          Container(
                            decoration: BoxDecoration(        color: Colors.white,  borderRadius: BorderRadius.circular(10.0) ),

                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Descripción:", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),

                                    ],
                                  ),
                                  Divider(height: 8,),
                                  Row(
                                    children: [
                                      Expanded(child: Text("${snapshot.data![index]['descripcion']}", style: TextStyle(height: 1.6, fontSize: 13),))
                                    ],
                                  ),

                                  SizedBox(height: 15,),

                                  Row(
                                    children: [
                                      Text("Lugar: ", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  Divider(height: 8,),
                                  Row(
                                    children: [
                                      Expanded(child: Text("${snapshot.data![index]['lugar']}", style: TextStyle(height: 1.6, fontSize: 13),))
                                    ],
                                  ),

                                  Divider(height: 25,),


                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width:  MediaQuery.of(context).size.width*0.35,
                                          child: Row(
                                            children: [
                                              Text("Enviado desde:  ", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                            ],
                                          )),
                                      Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width*0.50,
                                          child: Row(
                                            children: [
                                              Icon(Icons.message, size: 17, color: Color(0xFF0DC042),),
                                              SizedBox(width: 5,),
                                              Text("+${snapshot.data![index]['wab_celular']}", style: TextStyle(fontSize: 13,)),
                                            ],
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Divider(height: 15,),

                          //Agregar Información
                          Container(

                            decoration: BoxDecoration(        color: Colors.white,  borderRadius: BorderRadius.circular(10.0) ),

                            child: ExpandableNotifier(


                              child: Column(
                                children: [
                                  Expandable(
                                    collapsed:  Column(
                                      children: [
                                        ExpandableButton(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0XFF0A3987),
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(5.0),
                                                  topLeft: Radius.circular(5.0)),),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(

                                                    children: [
                                                      Icon(Icons.list_alt , color: Colors.white, size: 18,),
                                                      SizedBox(width: 4,),
                                                      Text("  Agregar Información", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                                                    ],
                                                  ),
                                                  Icon(Icons.arrow_drop_down, color: Colors.white,)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [

                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  Text("Desviación: ", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                                ],
                                              ),
                                              Divider(height: 8,),

                                              SizedBox(
                                                  height: 80,
                                                  child: DesviacionesTextForm(origen: origen_ayc,)),

                                              SizedBox(height: 15,),

                                              Row(
                                                children: [
                                                  Text("Nivel de Riesgo: ", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                                ],
                                              ),
                                              Divider(height: 8,),

                                              TextFormField(
                                                readOnly: true,
                                                controller:  riesgoField,
                                                style: TextStyle(fontSize: 12),
                                                onTap: (){
                                                  showGeneralDialog(
                                                    barrierLabel: "Label",
                                                    barrierDismissible: true,
                                                    barrierColor: Colors.black.withOpacity(0.5),
                                                    transitionDuration: Duration(milliseconds: 300),
                                                    context: context,
                                                    pageBuilder: (context, anim1, anim2) {
                                                      return Container(

                                                        child: Align(
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(10.0),
                                                            ),

                                                            height: MediaQuery.of(context).size.height*0.5,
                                                            width: MediaQuery.of(context).size.width*0.9,

                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),

                                                              child: Align(
                                                                alignment: Alignment.center,
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                  ),
                                                                  height: MediaQuery.of(context).size.height*0.5,
                                                                  width: MediaQuery.of(context).size.width*1,

                                                                  child: Container(

                                                                      child: Column(
                                                                        children: [

                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [

                                                                              Container(
                                                                                height: MediaQuery.of(context).size.height*0.5,
                                                                                width: MediaQuery.of(context).size.width*0.9,
                                                                                child: ListView.builder(
                                                                                    scrollDirection: Axis.vertical,
                                                                                    shrinkWrap: true,
                                                                                    itemCount: listaNivel.length,
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      return  Column(
                                                                                        children: [
                                                                                          Container(
                                                                                            height:45,
                                                                                            child: ElevatedButton(
                                                                                                style: ElevatedButton.styleFrom(
                                                                                                  backgroundColor: Colors.white,
                                                                                                  elevation: 0,
                                                                                                ),
                                                                                                onPressed: (){

                                                                                                  riesgoField.text = '${listaNivel[index]}';
                                                                                                  if(listaNivel[index] == 'Bajo'){
                                                                                                    nivel_riesgo_id = '1';
                                                                                                  } else if (listaNivel[index] == 'Medio'){
                                                                                                    nivel_riesgo_id = '2';
                                                                                                  } else if (listaNivel[index] == 'Alto'){
                                                                                                    nivel_riesgo_id = '4';
                                                                                                  } else if (listaNivel[index] == 'Extremo'){
                                                                                                    nivel_riesgo_id = '7';
                                                                                                  }else{
                                                                                                    nivel_riesgo_id = '';
                                                                                                  }
                                                                                                  print("nivel riesgo id ---- $nivel_riesgo_id");
                                                                                                  Navigator.pop(context);}, child: Text("${listaNivel[index]}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),)),
                                                                                          ),

                                                                                          Divider(height: 1,)
                                                                                        ],
                                                                                      );
                                                                                    }),
                                                                              ),


                                                                            ],

                                                                          ),


                                                                        ],
                                                                      )),
                                                                  //    margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    transitionBuilder: (context, anim1, anim2, child) {
                                                      return SlideTransition(
                                                        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
                                                        child: child,
                                                      );
                                                    },
                                                  );
                                                },


                                                decoration: InputDecoration(

                                                  hintText: 'Ingrese el Nivel de Riesgo',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),

                                              SizedBox(height: 15,),

                                              Row(
                                                children: [
                                                  Text("Gerencia: ", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                                ],
                                              ),

                                              Divider(height: 8,),

                                              SizedBox(

                                                height: 80,
                                                child:  GerenciaTextForm(
                                                  sede: '1',
                                                  onGerenciaSelected: (selectedId) {
                                                    setState(() {
                                                      gerenciaId = selectedId;
                                                    });
                                                  },
                                                ),

                                              ),

                                              Row(
                                                children: [
                                                  Text("Área: ", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                                ],
                                              ),
                                              Divider(height: 8,),


                                              SizedBox(
                                                  height: 80,
                                                  child: AreaTextForm(fbGerenciaId: gerenciaId)
                                              ),

                                              //Widget Area - verificar funcionamiento correcto (fb_uea_pe_id)


                                              

                                              /*
                                        Row(
                                          children: [
                                            Expanded(child: Text("${snapshot.data![index]['lugar']}", style: TextStyle(height: 1.6, fontSize: 13),))
                                          ],
                                        ),
                                        */

                                              SizedBox(height: 15,),
                                              Row(
                                                children: [
                                                  Text("Acción Inmediata: ", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                                ],
                                              ),
                                              Divider(height: 8,),


                                                    Container(
                                                        width: MediaQuery.of(context).size.width*1,
                                                        child: TextField(
                                                          controller: accionInm,
                                                          minLines: 3, // Set this
                                                          maxLines: 6, // and this
                                                          keyboardType: TextInputType.multiline,
                                                          style: TextStyle(color: Color(0xFF4B82B9), fontWeight: FontWeight.w500, fontSize: 14),
                                                          decoration: InputDecoration(

                                                            hintText: "Ingrese la Acción correctiva a realizar...",
                                                            hintStyle: TextStyle(color: Colors.grey),
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Color(0XFF0A3987), width: 1 ),
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Color(0XFF0A3987), width: 2 ),
                                                            ),
                                                          ),
                                                        )
                                                    ),




                                              /*
                                        Row(
                                          children: [
                                            Expanded(child: Text("${snapshot.data![index]['lugar']}", style: TextStyle(height: 1.6, fontSize: 13),))
                                          ],
                                        ),
                                        */

                                              SizedBox(height: 25,),


                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                      width:  MediaQuery.of(context).size.width*0.35,
                                                      child: Text("Se corrigió:  ", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
                                                ],
                                              ),
                                              Divider(height: 8,),

                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ListTile(
                                                      contentPadding: EdgeInsets.all(0),
                                                      leading: Radio<String>(
                                                        value: 'Si',
                                                        groupValue: corrigioAyC,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            corrigioAyC = value!;
                                                          });
                                                        },
                                                      ),
                                                      title: const Text('Si'),
                                                    ),
                                                  ),

                                                  Expanded(child:

                                                  ListTile(
                                                    contentPadding: EdgeInsets.all(0),
                                                    leading: Radio<String>(
                                                      value: 'No',
                                                      groupValue: corrigioAyC,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          corrigioAyC = value!;
                                                        });
                                                      },
                                                    ),
                                                    title: const Text('No'),
                                                  ),
                                                  )
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    expanded: ExpandableButton(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0XFF0A3987),
                                          borderRadius: BorderRadius.circular(10.0),),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(

                                                children: [
                                                  Icon(Icons.list_alt , color: Colors.white, size: 18,),
                                                  SizedBox(width: 4,),
                                                  Text("  Agregar Información", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                                                ],
                                              ),
                                              Icon(Icons.arrow_drop_down, color: Colors.white,)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                  
                                  ),


                                ],
                              ),
                            ),
                          ),




                          Divider(height: 15,),

                          //Evidencias
                          Container(

                            decoration: BoxDecoration(        color: Colors.white,  borderRadius: BorderRadius.circular(10.0) ),

                            child: ExpandableNotifier(


                              child: Column(
                                children: [
                                  Expandable(
                                    collapsed:     Column(
                                      children: [
                                        ExpandableButton(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0XFF0A3987),
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(5.0),
                                                  topLeft: Radius.circular(5.0)),),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(

                                                    children: [
                                                      Icon(Icons.camera_alt , color: Colors.white, size: 18,),
                                                      SizedBox(width: 4,),
                                                      Text("  Evidencias", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                                                    ],
                                                  ),
                                                  Icon(Icons.arrow_drop_down, color: Colors.white,)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(children: [
                                              Container(
                                                color: Colors.white,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [

                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [



                                                          DottedBorder(
                                                            padding:
                                                            EdgeInsets.all(10.0),
                                                            color: Colors.white,
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

                                                            child: Container(
                                                                alignment: Alignment.center,
                                                                width: MediaQuery.of(context).size.width*0.80,
                                                                child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(5.0),
                                                                    child: Image.network("https://app.safe2biz.com:8080/safe2biz_ASP_DEMO/PATH_UPLOAD/${snapshot.data![index]['imagen_uno']}"))
                                                            ),
                                                          ),
                                                          SizedBox(height: 2,),
                                                          Container(
                                                              width:  MediaQuery.of(context).size.width*1,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Icon(Icons.camera_alt, color: Colors.grey, size: 16,),
                                                                  SizedBox(width: 4,),
                                                                  Text("Evidencia 1", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color: Colors.grey),),
                                                                ],
                                                              )),

                                                        ],
                                                      ),

                                                      Divider(height: 30, thickness: 2,),



                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [

                                                          SizedBox(height: 6,),
                                                          Container(
                                                            //path upload y url_fotos
                                                            //se va a ver en una carpeta asp

                                                              alignment: Alignment.center,
                                                              width: MediaQuery.of(context).size.width*0.80,


                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(5.0),
                                                                child: Image.network("https://app.safe2biz.com:8080/safe2biz_ASP_DEMO/PATH_UPLOAD/${snapshot.data![index]['imagen_dos']}",
                                                                  errorBuilder: (context, exception, stackTrack) => Column(
                                                                    children: [
                                                                      Image.asset('assets/gif/no_evidence.png', width: MediaQuery.of(context).size.width*0.4,),
                                                                      SizedBox(height: 5,),
                                                                    ],
                                                                  )
                                                                  ,),
                                                              ),
                                                          ),
                                                          SizedBox(height: 10,),
                                                          Container(
                                                              width:  MediaQuery.of(context).size.width*1,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Icon(Icons.camera_alt, color: Colors.grey , size: 16, ),
                                                                  SizedBox(width: 4,),
                                                                  Text("Evidencia 2", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color: Colors.grey),),
                                                                ],
                                                              )),

                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],)
                                        ),
                                      ],
                                    ),
                                    expanded:ExpandableButton(
                              child: Container(
                              decoration: BoxDecoration(
                              color: Color(0XFF0A3987),
                              borderRadius: BorderRadius.circular(10.0),),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.camera_alt , color: Colors.white, size: 18,),
                                      SizedBox(width: 4,),
                                      Text("  Evidencias", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                                    ],
                                  ),
                                  Icon(Icons.arrow_drop_down, color: Colors.white,)
                                ],
                              ),
                            ),
                          ),
                    ),


                                  ),


                                ],
                              ),
                            ),
                          ),


                          Divider(height: 20,),

                          Container(
                            decoration: BoxDecoration(        color: S2BColors.primaryColor,  borderRadius: BorderRadius.circular(10.0) ),



                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(

                                    children: [
                                      Icon(Icons.checklist_rtl_rounded , color: Colors.white, size: 16,),
                                      Text("  Aprobación", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),)
                                    ],
                                  ),
                                ),

                                Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 4,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context).size.width*0.40,
                                                child: ElevatedButton(onPressed: () async{

                                                  //APROBAR aycc============

                                                  print('ayc_registro_id --- ${widget.idAyC}');
                                                  print('area_id --- $area_id');
                                                  print('Se corrigio --- $corrigioAyC');
                                                  print('g_nivel_riesgo --- $nivel_riesgo_id');
                                                  print('origen --- $origen_ayc');




                                                  AwesomeDialog(
                                                    context: context,
                                                    animType: AnimType.leftSlide,
                                                    headerAnimationLoop: false,
                                                    dialogType:
                                                    DialogType.success,
                                                    showCloseIcon: true,
                                                    title: 'Registrado',
                                                    desc:
                                                    'Se ha aprobado el registro de Actos y Condiciones con éxito.',
                                                    btnOkOnPress: () async {

                                                      await requestUpdateAyCRegister(
                                                        aycEstadoId: 2,
                                                        accionInmediata: accionInm.text,
                                                        nivelRiesgoId: nivel_riesgo_id,
                                                        realizoAccion: corrigioAyC == 'Si' ? '1' : '2',
                                                      );

                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AYC_Bot(sede: widget.fb_id,))).then((value) => setState((){}));

                                                    },
                                                    btnOkIcon: Icons.check_circle,
                                                    onDismissCallback: (type) {
                                                      debugPrint(
                                                          'Dialog Dissmiss from callback $type');
                                                    },
                                                  ).show();


                                                }, child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.check_rounded, size: 24,),
                                                    SizedBox(width: 4,),
                                                    Text("Aprobar", style: TextStyle(fontWeight: FontWeight.bold),),
                                                  ],
                                                ), style: ElevatedButton.styleFrom(backgroundColor: Color(0xff51AE46)))),
                                            Container(
                                                width: MediaQuery.of(context).size.width*0.40,
                                                child: ElevatedButton(onPressed: ()async{


                                                  AwesomeDialog(
                                                    context: context,

                                                    dialogType: DialogType.error,
                                                    body: Center(child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        'Se ha rechazado  ${origen}: ${snapshot.data![index]['codigo']} de los registros ',
                                                        style: TextStyle(fontSize: 16, height: 1.5),
                                                      ),
                                                    ),),
                                                    title: 'This is also Ignored',
                                                    desc:   'This is also Ignored',
                                               //     dialogBackgroundColor: Colors.red,
                                                    btnOkColor: Colors.red,
                                                    btnOkOnPress: () async{


                                                      await requestUpdateAyCRegister(
                                                        aycEstadoId: 4,
                                                        accionInmediata: accionInm.text,
                                                        nivelRiesgoId: nivel_riesgo_id,
                                                        realizoAccion: corrigioAyC == 'Si' ? '1' : '2',
                                                      );
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AYC_Bot(sede: widget.fb_id,))).then((value) => setState((){}));},

                                                  )..show();
                                                }, child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.close_rounded, size: 24,),
                                                    SizedBox(width: 4,),
                                                    Text("Rechazar", style: TextStyle(fontWeight: FontWeight.bold),),
                                                  ],
                                                ), style: ElevatedButton.styleFrom(backgroundColor: Color(0xffDE3A3B)),)),


                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30,)
                        ],
                      ),
                    ),
                  );
                }
            )
                : const Center(
              // render the loading indicator
              child: CircularProgressIndicator(),
            ))
    );
  }

  //Request JSON directo
  Future <List< dynamic>> RequestIncidenciasGeneralesDetalle() async {
    final user = await authController.getUserFromStorage();
    int? idIncidente = widget.idAyC;
    var url = '${user!.urlApp}/ws/null/pr_ws_ayc_registros_bot_id?ayc_registro_id=$idIncidente';
    var response = await http.post(Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
        //    body: jsonEncode(mapIncGen)
      });

    print("${response.statusCode}");
    var data_base = jsonDecode(response.body);
    var data = jsonDecode(response.body)['data'];
    List  results = [];
    //results = data.map((e) => EmpleadoIncGen_model.fromJson(e)).toList();

    print("data_base ---> ${data_base}");
    print("data ----> ${data}]");
    return data;
  }

  Future <void> RequestUpadateAyCRegister() async {
      final user = await authController.getUserFromStorage();

    int? idIncidente = widget.idAyC;
    var url = '${user!.urlApp}/ws/null/pr_ws_ayc_registros_update?ayc_registro_id=$idIncidente&is_deleted=1';
    var response = await http.post(Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
        //    body: jsonEncode(mapIncGen)
      });

    print("${response.statusCode}");
    var data_base = jsonDecode(response.body);
    var data = jsonDecode(response.body)['data'];
    List  results = [];
    //results = data.map((e) => EmpleadoIncGen_model.fromJson(e)).toList();

    print("data_base ---> ${data_base}");
    print("data ----> ${data}]");
    return data;
  }

  Future<void> requestUpdateAyCRegister({
    required int aycEstadoId,
    String? accionInmediata,
    String? nivelRiesgoId,
    String? realizoAccion,
  }) async {
    int? idIncidente = widget.idAyC;

    // Establecer valores predeterminados para los parámetros opcionales

    area_id ??='';
    accionInmediata ??= '';  // Usar cadena vacía si es null
    nivelRiesgoId ??= '0';   // Usar '0' si es null
    realizoAccion ??= '0';   // Usar '0' si es null
    final user = await authController.getUserFromStorage();
    // Construir la URL con los valores asegurados
    var url = Uri.parse(
        '${user!.urlApp}/ws/null/pr_ws_ayc_registros_actualizar'
            '?ayc_registro_id=$idIncidente&fb_area_id=$area_id&accion_inmediata=$accionInmediata&nivel_riesgo=$nivelRiesgoId&realizo_accion=$realizoAccion'
            '&ayc_estado=$aycEstadoId'
    );

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",

        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
      },
    );

    print("HTTP status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("Data received: $data");
      print("Failed to update data. Error: ${response.body}");
// Esto mostrará el cuerpo completo de la respuesta, que podría tener más detalles sobre el error.

    } else {
      print("Failed to update data. Error: ${response.body}");


    }
  }
}

//ListArea ---
Future<void> listArea() async {

  try {
    LocalSqlite sqlite = LocalSqlite();
    List<Map<String, dynamic>> aycArea = await sqlite.getArea();
    print("registros ==> $aycArea");

    for (var registro in aycArea) {
      print("registros ==> $aycArea");
    }
  } catch (e) {
    print("Error: $e");
  }

}


class DesviacionesTextForm extends StatefulWidget {


  final String? origen;

  DesviacionesTextForm({Key? key, this.origen}) : super(key: key);

  @override
  _DesviacionesTextFormState createState() => _DesviacionesTextFormState();

}

class _DesviacionesTextFormState extends State<DesviacionesTextForm> {
  List<Map<String, dynamic>> listaDesviaciones = [];
  TextEditingController desviacionesField = TextEditingController();

  String desviacionId = '';

  @override
  void initState() {
    super.initState();
    listDesviaciones().then((data) {
      setState(() {
        listaDesviaciones = data;
      });
    });
  }

  Future<List<Map<String, dynamic>>> listDesviaciones() async {
    try {
      LocalSqlite sqlite = LocalSqlite();
      List<Map<String, dynamic>> aycRegistros = await sqlite.getTipoCausa();
      print("registros ==> $aycRegistros");

      // Filtrar los registros según el valor de 'origen'
      if (widget.origen != null) {
        aycRegistros = aycRegistros.where((registro) {
          return registro['ayc'] == widget.origen;
        }).toList();
      }

      return aycRegistros;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  @override
  void didUpdateWidget(DesviacionesTextForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.origen != oldWidget.origen) {
      listDesviaciones().then((data) {
        setState(() {
          listaDesviaciones = data;
        });
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    // Aquí construirás tu UI, incluyendo el TextFormField
    return  Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            TextFormField(
              readOnly: true,
              controller: desviacionesField,
              style: TextStyle(fontSize: 12),
              onTap: () => _mostrarDialogoDesviaciones(),
              decoration: InputDecoration(
                hintText: 'Ingrese la Desviación',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
    );
  }

  void _mostrarDialogoDesviaciones() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Container(

            decoration: BoxDecoration(
            color: Colors.white,
                borderRadius: BorderRadius.circular(10.0)),
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,

                      itemCount: listaDesviaciones.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                listaDesviaciones[index]['descripcion'],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                              onTap: () {
                                desviacionesField.text = listaDesviaciones[index]['descripcion'];
                                desviacionId = listaDesviaciones[index]['g_tipo_causa_id'];
                                print('desv id : $desviacionId');
                                Navigator.pop(context);
                              },
                            ),
                            // Agregar Divider aquí, excepto después del último elemento
                            if (index < listaDesviaciones.length - 1)
                              Divider(height: 1,),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
}



class GerenciaTextForm extends StatefulWidget {
  final String sede;
  final Function(String) onGerenciaSelected;


  GerenciaTextForm({Key? key, required this.sede, required this.onGerenciaSelected}) : super(key: key);

  @override
  _GerenciaTextFormState createState() => _GerenciaTextFormState();
}

class _GerenciaTextFormState extends State<GerenciaTextForm> {
  List<Map<String, dynamic>> listaGerencias = [];
  TextEditingController gerenciaField = TextEditingController();

  @override
  void initState() {
    super.initState();
    listGerencia().then((data) {
      setState(() {
        listaGerencias = data;
      });
    });
  }


  Future<List<Map<String, dynamic>>> listGerencia() async {
    try {
      LocalSqlite sqlite = LocalSqlite();
      List<Map<String, dynamic>> aycGerencia = await sqlite.getGerencia();
      // Filtra las gerencias según la sede
      return aycGerencia.where((gerencia) => gerencia['fb_uea_pe_id'].toString() == widget.sede).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(fontSize: 12),
            readOnly: true,
            controller: gerenciaField,
            onTap: () => _mostrarDialogoGerencias(),
            decoration: InputDecoration(
              hintText: 'Ingrese la Gerencia',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoGerencias() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaGerencias.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                listaGerencias[index]['nombre'],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                              onTap: () {
                                gerenciaField.text = listaGerencias[index]['nombre'];
                                String selectedGerenciaId = listaGerencias[index]['fb_gerencia_id'];
                                widget.onGerenciaSelected(selectedGerenciaId);
                                Navigator.pop(context);
                              },
                            ),
                            // Agregar Divider aquí, excepto después del último elemento
                            if (index < listaGerencias.length - 1)
                              Divider(height: 1,),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      // ... otras configuraciones ...
    );
  }
}




class AreaTextForm extends StatefulWidget {
  final String? fbGerenciaId;

  AreaTextForm({Key? key, this.fbGerenciaId}) : super(key: key);

  @override
  _AreaTextFormState createState() => _AreaTextFormState();
}

class _AreaTextFormState extends State<AreaTextForm> {
  List<Map<String, dynamic>> listaAreas = [];
  TextEditingController areaField = TextEditingController();
  String areaId = '';

  @override
  void initState() {
    super.initState();
    listArea().then((data) {
      setState(() {
        listaAreas = data;
      });
    });
  }

  Future<List<Map<String, dynamic>>> listArea() async {
    try {
      LocalSqlite sqlite = LocalSqlite();
      List<Map<String, dynamic>> aycArea = await sqlite.getArea();

      // Filtra las áreas según fbGerenciaId
      return aycArea.where((area) => area['fb_gerencia_id'].toString() == widget.fbGerenciaId).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }


  @override
  void didUpdateWidget(covariant AreaTextForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fbGerenciaId != widget.fbGerenciaId) {
      listArea().then((data) {
        setState(() {
          listaAreas = data;
        });
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(fontSize: 12),
            readOnly: true,
            controller: areaField,
            onTap: () => _mostrarDialogoAreas(),
            decoration: InputDecoration(
              hintText: 'Ingrese el Área',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }



  //mostrar areas para que


  //para que e pueda implementar los metodos, deben de teener en cuenta los void de loss metodos
 // para que los moudlos de lass areas tengaan una lissta de opcioness  para que el ussuario pueda escoge

  //para que tambien los modulos puedan vissualizarse de forma correcta, entonces debe estar especificado, los metodos listGerencia, listArea, listDesviacion
  // ya que sin ellos no retornan datos...

  // ademas se tiene que


  //mostrar dialogo areas
  void _mostrarDialogoAreas() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaAreas.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                listaAreas[index]['nombre'],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                              onTap: () {
                                areaField.text = listaAreas[index]['nombre'];
                                String selectedGerenciaId = listaAreas[index]['fb_area_id'];

                                Navigator.pop(context);
                              },
                            ),
                            // Agregar Divider aquí, excepto después del último elemento
                            if (index < listaAreas.length - 1)
                              Divider(height: 1,),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      // Más configuraciones del diálogo...
    );
  }
}
