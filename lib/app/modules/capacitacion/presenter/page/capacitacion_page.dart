import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/capacitacion/presenter/page/agregar_capacitaci%C3%B3n.dart';
import 'package:http/http.dart' as http;
import 'package:safe2biz/app/modules/capacitacion/presenter/page/capacitacion_detalle.dart';
import 'package:safe2biz/app/modules/capacitacion/presenter/page/pdfAsistencia.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/sedes/features/company/presenter/page/company_page.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/presenter/page/sincronizar_body.dart';
import 'package:safe2biz/app/ui/module_ui.dart';


class CapacitacionHome extends StatefulWidget {
  final String? sede;
  const CapacitacionHome({Key? key, this.sede}) : super(key: key);
  @override
  State<CapacitacionHome> createState() => _CapacitacionHomeState();
}
String sede = LocalPreferences.prefs?.getString('current_sede') ?? '';
SqlDb sqlDb = SqlDb();
final localSqliteInstance = LocalSqlite();
final authController = AuthController(sqlite: localSqliteInstance);


class _CapacitacionHomeState extends State<CapacitacionHome> {

  @override
  void initState(){
    super.initState();



  }


  void asyncMethod() async{


  }
  bool visibleUpload = false;



  Future<List<Map>> readData(String id) async {

    List<Map> responseReadAll = await sqlDb.readData(
        "SELECT asistencia_check.id_curso FROM asistencia_check WHERE asistencia_check.id_curso = '$id' "
    );

    if(responseReadAll.isNotEmpty){
      print('Ya hay asistentes guardados');
      
      visibleUpload = true;
    }else{
      print('No hay asistentes guardados');
      visibleUpload = false;
    }

    print(responseReadAll);
    print('response first --> $responseReadAll');
    return responseReadAll;

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
      title: Text('$sede', style: TextStyle(fontSize: 16, color: Colors.white),),
    backgroundColor: S2BColors.primaryColor,
    elevation: 0,
    leading: IconButton(
    onPressed: (){

    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>   CompanyPage()));

    },
    icon: Icon(Icons.arrow_back_sharp, color: Colors.white)
    )),
      body:  Column(
          children: [
            //Lista por tarjetas?
                   Stack(alignment: Alignment.bottomRight , children: [
              Container(
                margin: const EdgeInsets.only(bottom:12.0),
                color: Color(0xff09357E),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 12, top: 10),
                          child: Container(child: Text("Capacitación", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ]),

                Expanded(
                  child: FutureBuilder(
                      future: RequestCantidadCapacitaciones(),
                      builder: (BuildContext context, AsyncSnapshot<List> snapshot ){



                        if(snapshot.hasData){


                          return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, index) {




                                  String? idCurso = '${snapshot.data![index]['cap_curso_id']}';
                                  String inst =  '${snapshot.data![index]['institucion']}';

                                  if(inst == null || inst == 'null'){
                                    inst = 'No especifíca';
                                  }

                                  return    Column(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CapacitacionDetalle(idCurso: idCurso, idSede: widget.sede)));
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*1,
                                          child: Row(
                                              children: [
                                                Expanded(
                                                  child:
                                                  Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(10.0),
                                                      ),
                                                    ),
                                                    elevation: 5,
                                                    child:
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 10.0, top: 0.0, bottom: 0.0),
                                                      child: IntrinsicHeight(
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width*1,
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                  width: 12,
                                                                  height: double.infinity,
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.orange,
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(10),
                                                                          bottomLeft: Radius.circular(10)
                                                                      ), ),
                                                                  )
                                                              ),

                                                              SizedBox(width: 10,),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            width: MediaQuery.of(context).size.width*0.35,
                                                                            child: Text("${snapshot.data![index]['codigo']}", style: TextStyle(fontSize: 11, height: 1.4, fontWeight: FontWeight.bold, color: Color(0XFF505154)),),
                                                                          ),

                                                                          Container(

                                                                            padding: EdgeInsets.only(left: 8.0),
                                                                            decoration: const BoxDecoration(
                                                                                border: Border(left: BorderSide(width: 0.5, color: Color(0XFFB6B6B6)))),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children:[
                                                                                    Row(
                                                                                      children: [
                                                                                        Text("Ini:  ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: S2BColors.primaryColor),),
                                                                                        Text("${snapshot.data![index]['fecha_inicio'].substring(0,10)}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: S2BColors.primaryColor),),
                                                                                      ],
                                                                                    ),
                                                                                    Text(' / '),
                                                                                    Row(
                                                                                      children: [
                                                                                        Text("Fin:  ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: S2BColors.primaryColor),),
                                                                                        Text("${snapshot.data![index]['fecha_final'].substring(0,10)}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: S2BColors.primaryColor),),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),

                                                                              ],
                                                                            ),
                                                                          ),
                                                                          //${snapshot.data![index]['hora'].substring(0,5)}
                                                                        ],
                                                                      ),
                                                                      Divider(height: 16,),

                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            width: MediaQuery.of(context).size.width*0.65,
                                                                            child: Column(
                                                                              children: [

                                                                                Row(
                                                                                    children: [
                                                                                      Flexible(child: Text("${snapshot.data![index]['nombre']}", style: TextStyle(fontWeight: FontWeight.bold, height: 1.3, fontSize: 14),)), //Presencial
                                                                                    ]
                                                                                ),

                                                                                SizedBox(height: 8,),
                                                                                Row(
                                                                                  children: [
                                                                                    Text("Institución:  ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0XFF505154)),), //Presencial
                                                                                    Text("$inst", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: Color(0XFF505154)),),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width: 80,
                                                                            height: 45,
                                                                            child: Column(
                                                                              children: [
                                                                                Container(child: Text("Horas:", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),),
                                                                                SizedBox(height: 4,),
                                                                                Container(child: Text("${snapshot.data![index]['horas']}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0XFF505154))),),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),

                                                                      Divider(height: 16,),

                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [

                                                                              Container(
                                                                                  width: 95,
                                                                                  height: 25,
                                                                                  child: ElevatedButton(onPressed: (){},
                                                                                      style: ElevatedButton.styleFrom(
                                                                                          shape: StadiumBorder(),
                                                                                          backgroundColor: S2BColors.orange
                                                                                      ),
                                                                                      //Estado
                                                                                      child: FittedBox(child: Text("En Ejecución", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11) )  ))),


                                                                                          //SizedBox(height: 4,),


                                                                                  Row(
                                                                                    children: [
                                                                                      Text("Por: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11,)),
                                                                                      Text(" ${snapshot.data![index]['expositor']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0XFFB6B6B6)),),
                                                                                    ],
                                                                                  ),





                                                                          /*
                                                                          Visibility(
                                                                         visible: false,
                                                                            child: Container(
                                                                              height: 28,
                                                                              child:
                                                                              IconButton(icon: FaIcon(FontAwesomeIcons.upload,size: 16, color: Color(0xff09357E),) ,onPressed: () async{


                                                                                List<Map> responseReadAll = await sqlDb.readData(
                                                                                    "SELECT asistencia_check.fb_empleado_id FROM asistencia_check WHERE asistencia_check.id_curso = '${snapshot.data![index]['cap_curso_id']}' "
                                                                                );
                                                                                print('response asistencia check -- $responseReadAll');


                                                                              }),
                                                                            ),
                                                                          )
                                                                          */
                                                                        ],
                                                                      )
                                                                      //Suma de registros
                                                                      //Lista de nro de total de factura y monto
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                    ],
                                  );
                                }
                            );
                        }
                        return Center(child: CircularProgressIndicator(),);
                      }),
                ),
              ],
            ),
         );
      }


  Future <List< dynamic>> RequestCantidadCapacitaciones() async {
    final user = await authController.getUserFromStorage();



    var url = '${user!.urlApp}/ws/null/pr_ws_lista_curso_estado?estado_curso=2';
    var mapIncGen = Map<String, dynamic>();
    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "userLogin": "${user.userLogin}@${user.arroba}",
          "userPassword": "${user.password}",
          "systemRoot": "${user.enterprise}"
        },
        body: jsonEncode(mapIncGen)
    );

    print("${response.statusCode}");
    // print("${response.body}");
    // OBJECT JSON
    // var data =[];
    // data = json.decode(response.body)['data'] ;
    var data = jsonDecode(response.body)['data'];
    List  results = [];
    //   results = data.map((e) => EmpleadoIncGen_model.fromJson(e)).toList();
    print("data ----> ${data}]");
    return data;
  }
}