import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:http/http.dart' as http;
import 'package:safe2biz/app/global/core/errors/exceptions.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:safe2biz/app/modules/capacitacion/domain/entities/asistencia_check_model.dart';
import 'package:safe2biz/app/modules/capacitacion/presenter/page/Agregar.dart';
import 'package:safe2biz/app/modules/capacitacion/presenter/page/FichaCapacitacion.dart';

import 'package:safe2biz/app/modules/capacitacion/presenter/page/SearchPage.dart';
import 'package:safe2biz/app/modules/capacitacion/presenter/page/capacitacion_page.dart';
import 'package:safe2biz/app/modules/capacitacion/presenter/page/pdfAsistencia.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/lista_entrega.dart';
import 'package:safe2biz/app/modules/sedes/features/company/presenter/page/company_page.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/empleado_model.dart';
import 'package:safe2biz/app/ui/module_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../epp/external/database/database.dart';

class CapacitacionDetalle extends StatefulWidget {
  const CapacitacionDetalle({Key? key, this.idCurso, this.idSede}) : super(key: key);
  final String? idCurso, idSede;

  @override
  State<CapacitacionDetalle> createState() => _CapacitacionDetalleState();
}
var  c = DioMicroServices();
SqlDb sqlDb = SqlDb();


final localSqliteInstance = LocalSqlite();
final authController = AuthController(sqlite: localSqliteInstance);

class _CapacitacionDetalleState extends State<CapacitacionDetalle> {

  bool hasCheckedAsisstant = false;

  List<bool?> itemCheckedState = [];
  List<Map<String, dynamic>>? itemCheck;

  List<bool?> itemTrue = [];
  List<bool?> itemFalse = [];

  List<dynamic> parametros_metales = [];
  List<dynamic>? listOfItems = [];

  bool tomoFoto = false;

  List<dynamic>? listNuevosAsistentes;
  String? idCurso;

  List<String> ids = [];

  final userEditTextController = TextEditingController(text: '');
  List<String>? longData;
  //Opc-
  bool incVisibility = true;
  bool asistentesPage = false;
  bool indVisibility = false;


  bool isAssistant = false;

  bool imgEmpty = false;
  int? totalTemas;
  Border? borderBottomOpc;
  Border borderInc = Border(bottom: BorderSide(width: 3, color: Color(0XFFFF9F40)), );
  Border borderAsis = Border(bottom: BorderSide(width: 0));
  Border borderInd = Border(bottom: BorderSide(width: 0));
  Dio dio = Dio();

  //Agregar participantes

  final _openDropDownProgKey = GlobalKey<DropdownSearchState<EmpleadoModel>>();

  List<dynamic>? listNuevoParticipante;
  Color? colorDropDown = Color(0XFF0A3987);

  @override
  void initState() {
    super.initState();

    RequestCapacitacionDetalle();
    asyncMethod();
    loadFavorite();
    itemCheckedState = [];

  }
  bool needToUpdate = false;

  void refreshParticipants() {
    setState(() {
      needToUpdate = !needToUpdate; // Cambia el estado para forzar la reconstrucción.
    });
  }

  Future<void> loadFavorite() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final keys = prefs.getKeys();
    final prefsMap = Map<String, dynamic>();
    for(String key in keys) {
      prefsMap[key] = prefs.get(key);
    }
    print("Saved data --- $prefsMap");

    setState(() {
      itemCheckedState = (prefs.getStringList("Curso-$idCurso") ?? <bool>[]).map((value) => value == 'true').toList();
    });
    }

  _save(String key,dynamic val)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key,val);
  }

  File? _imageFile;
  bool isPhoto = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
      isPhoto = true;
    });
  }

  void asyncMethod() async{


      List<Map> asistenciaCurso = await sqlDb.readData(
          "SELECT * FROM asistencia_check WHERE asistencia_check.id_curso = '$idCurso' ");

      print('read asistencia_check ---> ${asistenciaCurso}');


      if(asistenciaCurso.isEmpty){
        hasCheckedAsisstant = false;
      }else{
        hasCheckedAsisstant = true;
      }



    List<Map> responseRead = await sqlDb.readData(""
        "SELECT capacitacion_photo.id_curso FROM capacitacion_photo WHERE capacitacion_photo.id_curso = '${widget.idCurso}' ");
    print("Tabla capacitacion_photo  --> id_curso --- $responseRead");


    if(responseRead.isEmpty || responseRead == null || responseRead == '' ) {
      print('ya se tomo foto de eso');
      setState(() {
        tomoFoto = true;
      });
    }else{
      print('NO se tomo foto de eso');
      setState(() {

        tomoFoto = false;
      });
    };
  }

  @override
  Widget build(BuildContext context) {

    double vw = MediaQuery.of(context).size.width;
    double vh = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Capacitacion', style: TextStyle(fontSize: 16, color: Colors.white),),
        backgroundColor: S2BColors.primaryColor,
        elevation: 0,
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>   CapacitacionHome(sede: widget.idSede)));
            },
            icon: Icon(Icons.arrow_back_sharp, color: Colors.white)
        ),
        actions: [
        Visibility(
        visible: !tomoFoto,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.picture_as_pdf_sharp),

              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => FichaCapacitacion(path: '' , idCurso: '${widget.idCurso}')));
              },
            )
        ),
      ),
      Visibility(
        visible: tomoFoto,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: (){

                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AsistenciaPhoto(idCurso: idCurso)));
              },
            )
        ),
      )
      ],
      ),




      body: Visibility(
        visible: true,
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
                        incVisibility = true;
                        indVisibility = false;
                        asistentesPage = false;

                        borderAsis = Border(bottom: BorderSide(width: 0), );
                        borderInc =  Border(bottom: BorderSide(width: 4, color: Color(0XFFFF9F40)), );
                        borderInd = Border(bottom: BorderSide(width: 0), );
                       }
                      );
                    },
                    child: Container(
                      decoration:  BoxDecoration(
                        border: borderInc,
                      ),
                      width: MediaQuery.of(context).size.width*0.33,
                      height: 60,
                      child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people_sharp, color: Colors.white,),
                              SizedBox(height: 2,),
                              Text("Participantes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                            ],
                          )),
                    ),
                  ),

                  Visibility(
                    visible: imgEmpty,
                    child: Column(
                      children: [
                        Center(
                          child: Image.asset('assets/gif/no_data_2.png', height: 150,),
                        )
                      ],
                    ),
                  ),


                  InkWell(
                    onTap: (){
                      setState(() {
                        incVisibility = false;
                        asistentesPage = true;
                        indVisibility = false;

                        borderAsis =  Border(bottom: BorderSide(width: 4, color: Color(0XFFFF9F40)), );
                        borderInc = Border(bottom: BorderSide(width: 0), );
                        borderInc = Border(bottom: BorderSide(width: 0), );
                      });
                    },
                    child: Container(
                      decoration:  BoxDecoration(
                        border: borderAsis,
                      ),

                      width: MediaQuery.of(context).size.width*0.33,
                      height: 60,
                      child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.userCheck, color: Colors.white, size: 16),
                              SizedBox(height: 6,),
                              Text("Resultados", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                            ],
                          )),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      setState(() {
                        asistentesPage = false;
                        incVisibility = false;
                        indVisibility = true;

                        borderAsis = Border(bottom: BorderSide(width: 0), );
                        borderInd =  Border(bottom: BorderSide(width: 4, color: Color(0XFFFF9F40)), );
                        borderInc = Border(bottom: BorderSide(width: 0), );
                      });
                    },
                    child: Container(
                      decoration:  BoxDecoration(
                        border: borderInd,
                      ),

                      width: MediaQuery.of(context).size.width*0.33,
                      height: 60,
                      child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.description, color: Colors.white ,),
                              SizedBox(height: 2,),
                              Text("Detalles", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),

            Visibility(
              visible: incVisibility,
              child: Row(
                children: [

                  Visibility(
                    visible: hasCheckedAsisstant,
                    child: Padding(
                      padding:  EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          Container(
                            height: 30,
                            child: ElevatedButton(onPressed: () async{

                              List<Map> asistenciaCurso = await sqlDb.readData(
                                  "SELECT * FROM asistencia_check WHERE asistencia_check.id_curso = '$idCurso' ");

                              for(var i=0; i<asistenciaCurso.length; i++){

                                SubirMarcadoAsistencia('${  asistenciaCurso[i]['fb_empleado_id']}');

                              print('fb_empleado id__ ${  asistenciaCurso[i]['fb_empleado_id']}');

                              int deleteParticipantesCurso = await sqlDb.deleteData("DELETE FROM asistencia_check "
                                  "WHERE asistencia_check.id_curso = '$idCurso'" );

                              print('delete participante curso $deleteParticipantesCurso');


                              //FIXME: ARREGLAR DESMARCADO DE CHECKBOX

                           //   itemCheck

                                // await SubirMarcadoAsistencia();
                              }

                              //FIXME: WS DELETE PART. ADD ASIST.

                              showDialog(context: context, builder: (_) =>
                                 Container(
                                      color: S2BColors.primaryColor,
                                      width: MediaQuery.of(context).size.width*1,
                                      child: AlertDialog(
                                        backgroundColor: S2BColors.primaryColor,
                                        elevation: 0,
                                        //.title: const Text("What's New / Que ha Cambiado"),
                                        content: Container(
                                          color: S2BColors.primaryColor,
                                          width: MediaQuery.of(context).size.width*1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              TextLabel.h6(
                                                'Actualizado exitosamente',
                                                color: S2BColors.white,
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(
                                                height: S2BSpacing.lg,
                                              ),
                                              Center(
                                                child: BtnDefault(
                                                  UiValues.volver,
                                                  color: S2BColors.white,
                                                  colorText: S2BColors.primaryColor,
                                                  onTap: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CapacitacionDetalle(idCurso: idCurso,))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );

                            }, child: Row(
                              children: [
                                Text('Actualizar Lista', style: TextStyle(color: Colors.white, fontSize: 12),),
                                SizedBox(width: 8,),
                                FaIcon(FontAwesomeIcons.upload, color: Colors.white, size: 14,),
                              ],
                            ), style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: S2BColors.primaryColor,
                            ),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),


            //Participantes Page
            Visibility(
              visible: incVisibility,
              child: Column(
                children: [
                  SizedBox(height: 1,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 15,),
                            Icon(Icons.person),
                            SizedBox(width: 12,),
                            Text("  Participantes", style: TextStyle(fontWeight: FontWeight.w500,),),
                          ],

                        ),
                        Text("Asistencia   ", style: TextStyle(fontWeight: FontWeight.w500,),),
                      ],
                    ),
                  ),
                  Divider(height: 2,),
                ],
              ),
            ),

            Visibility(
              visible: incVisibility,
              child: Expanded(
                flex: 8,
                child:        SingleChildScrollView(
                  child: FutureBuilder(
                      future: RequestParticipantesCurso(),
                      builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>
                      snapshot.hasData ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: parametros_metales.length,
                        itemBuilder: (BuildContext context, index) {

                          print("asistio: ${snapshot.data![index]['asistio']} (Tipo: ${snapshot.data![index]['asistio'].runtimeType})");

                          bool asistio = snapshot.data![index]['asistio'] == 1;

                          listOfItems = snapshot.data;
                          //itemCheckedState[index] = false;



                          for(int i = 0; i < listOfItems!.length; i++){
                            itemCheckedState.add(false);
                          // print("checkbox length ---> ${itemCheckedState[i] } ");
                          }


                          return Dismissible(
                            key: Key(snapshot.data![index]['fb_empleado_id'].toString()), // Asegúrate de que la key sea única para cada elemento
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) {
                              // Lógica para eliminar el participante
                              eliminarParticipante(snapshot.data![index]['fb_empleado_id']);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*0.4,
                                          decoration: BoxDecoration(
                                            //   color: Colors.blue,
                                              borderRadius: BorderRadius.circular(10.0) ),

                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                  child: Expanded(
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 28,
                                                              backgroundColor: Colors.transparent,
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8), // Border radius
                                                                child: ClipOval(child: Image.asset('assets/images/userDefault.png')),
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        SizedBox(width: 5,),


                                                        Container(
                                                          width: MediaQuery.of(context).size.width*0.47,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("${snapshot.data![index]['nombreCompleto']}", style: TextStyle(color: Color(0XFF505154), fontSize: 12, fontWeight: FontWeight.bold),),
                                                              SizedBox(height: 4,),
                                                              Text("${snapshot.data![index]['cargo_nombre']}", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w500),),
                                                              SizedBox(height: 4,),

                                                              Container(
                                                                width: vw*0.4,
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text("${snapshot.data![index]['area_nombre']}", style: TextStyle(color: Color(0XFF505154), fontSize: 10, ),),
                                                                  ],
                                                                ),
                                                              ),

                                                              SizedBox(height: 4,),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              ),

                                              /*
                                            Visibility(
                                              visible: !isAssistant,
                                              child: Row(
                                                children: [
                                                  Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right:32.0),
                                                      child: Container(
                                                        height: 65,
                                                        width: 30,
                                                        child: Column(
                                                          children: [
                                                            CheckboxListTile(
                                                              checkColor: Colors.white,
                                                              value: itemCheckedState[index],
                                                              //fillColor: MaterialStateProperty.resolveWith(getColor),
                                                              onChanged: (newValue) async{

                                                                Future<void> delete() async {

                                                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                  int responseDeletePuntoMetales = await sqlDb.deleteData("DELETE FROM asistencia_check "
                                                                      " WHERE asistencia_check.fb_empleado_id  = '${snapshot.data![index]['fb_empleado_id']}'" );

                                                                  print("Delete registro PuntoMetales $responseDeletePuntoMetales");
                                                                  print('position false checkbox ${itemCheckedState.length} ---- $newValue');
                                                                 // print('read asistencia_check ---> ${asistenciaCurso}');

                                                                  Future.delayed(const Duration(milliseconds: 3000), () async{
                                                                    List<Map> asistenciaCurso = await sqlDb.readData("SELECT * FROM asistencia_check WHERE asistencia_check.id_curso = '$idCurso' ");
                                                                    print('read asistencia_check ---> ${asistenciaCurso}');

                                                                    if(asistenciaCurso.isEmpty){

                                                                      setState((){
                                                                        hasCheckedAsisstant = false;
                                                                      });


                                                                    }else if(asistenciaCurso.isNotEmpty){
                                                                      setState((){
                                                                        hasCheckedAsisstant = true;
                                                                      });
                                                                    }
                                                                  });


                                                                  setState(() {
                                                                    itemCheckedState[index] = false;
                                                                  });

                                                                  await prefs.setStringList("Curso-$idCurso", itemCheckedState.map((value) => value.toString()).toList());
                                                                  setState(() {
                                                                    itemCheckedState = (prefs.getStringList("Curso-$idCurso") ?? <bool>[]).map((value) => value == 'true').toList();
                                                                  });

                                                                }

                                                                Future<void> saved() async {


                                                                  SharedPreferences prefs = await SharedPreferences.getInstance();

                                                                  int response = await sqlDb.insertData("INSERT INTO 'asistencia_check' "
                                                                      "( 'id_curso',            'fb_empleado_id',         'flag_asistio'      ) VALUES "
                                                                      "( '${widget.idCurso}',   '${snapshot.data![index]['fb_empleado_id']}',      '1') ");
                                                                  print("Guardado -- $response");
                                                                  itemCheckedState[index] = newValue;
                                                                  print('position true checkbox ${itemCheckedState.length} ---- $newValue');
                                                            //      print('read asistencia_check ---> ${asistenciaCurso}');

                                                                  setState(() {
                                                                    itemCheckedState[index] = true;
                                                                  });

                                                                  await prefs.setStringList("Curso-$idCurso", itemCheckedState.map((value) => value.toString()).toList());

                                                                  Future.delayed(const Duration(milliseconds: 1000), () async {
                                                                    List<Map> asistenciaCurso = await sqlDb.readData("SELECT * FROM asistencia_check WHERE asistencia_check.id_curso = '$idCurso' ");
                                                                    print('read asistencia_check ---> ${asistenciaCurso}');
                                                                    if(asistenciaCurso.isEmpty){

                                                                      setState((){
                                                                        hasCheckedAsisstant = false;
                                                                      });


                                                                    }else if(asistenciaCurso.isNotEmpty){
                                                                      setState((){
                                                                        hasCheckedAsisstant = true;
                                                                      });
                                                                    }
                                                                  });

                                                                  setState(() {
                                                                    itemCheckedState = (prefs.getStringList("Curso-$idCurso") ?? <bool>[]).map((value) => value == 'true').toList();
                                                                  });
                                                                }

                                                                if(newValue == true) {

                                                                       saved();

                                                                }else if (newValue == false){

                                                                       delete();

                                                                }
                                                              },
                                                            ),


                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            */



                                              Row(
                                                children: [
                                                  Center(
                                                    child: Padding(
                                                        padding: const EdgeInsets.only(right:8.0),
                                                        child:Card(
                                                          elevation: 5,
                                                          child: Container(
                                                            height: 30,
                                                            width: MediaQuery.of(context).size.width * 0.25,
                                                            child: ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                elevation: 0,
                                                                backgroundColor: asistio ? Colors.green : Colors.red,
                                                              ),
                                                              onPressed: () async{
                                                                if (asistio) {

                                                                  await ParticipanteAsistencia('${snapshot.data![index]['fb_empleado_id']}', '0');

                                                                } else {
                                                                  await ParticipanteAsistencia('${snapshot.data![index]['fb_empleado_id']}', '1');

                                                                }
                                                                setState((){});
                                                              },
                                                              child: Text(
                                                                asistio ? 'Asistió' : 'No Asistió',
                                                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, height: 1.4),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(height: 1,),
                                ],
                              ),
                            )
                          );

                        },
                      )  : const Center(
                        // render the loading indicator
                        child: CircularProgressIndicator(),
                      )
                  ),
                ),
              )
            ),

            //Asistentes Page

            Visibility(
              visible: asistentesPage,
              child: Column(
                children: [
                  SizedBox(height: 1,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 15,),
                            Icon(Icons.person),
                            SizedBox(width: 12,),
                            Text("  Asistentes", style: TextStyle(fontWeight: FontWeight.w500,),),
                          ],
                        ),
                        Text("Estado", style: TextStyle(fontWeight: FontWeight.w500,),),
                      ],
                    ),
                  ),
                  Divider(height: 1,),
                ],
              ),
            ),



            Visibility(
                visible: asistentesPage,
                child: Expanded(
                  flex: 8,
                  child:        SingleChildScrollView(
                    child: FutureBuilder(
                        future: RequestAsistenciaCurso(),
                        builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>
                        snapshot.hasData ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: parametros_metales.length,
                          itemBuilder: (BuildContext context, index) {

                            listOfItems = snapshot.data;
                            //itemCheckedState[index] = false;

                            for(int i = 0; i < listOfItems!.length; i++){
                              itemCheckedState.add(false);
                              // print("checkbox length ---> ${itemCheckedState[i] } ");
                            }


                            return  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*0.40,
                                          decoration: BoxDecoration(
                                            //   color: Colors.blue,
                                              borderRadius: BorderRadius.circular(10.0) ),

                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                  child: Expanded(
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 28,
                                                              backgroundColor: Colors.transparent,
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8), // Border radius
                                                                child: ClipOval(child: Image.asset('assets/images/userDefault.png')),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: 5,),

                                                        Container(
                                                          width: MediaQuery.of(context).size.width*0.55,

                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("${snapshot.data![index]['nombreCompleto']}", style: TextStyle(color: Color(0XFF505154), fontSize: 12, fontWeight: FontWeight.bold),),
                                                              SizedBox(height: 4,),
                                                              Text("${snapshot.data![index]['cargo_nombre']}", style: TextStyle(color: Color(0XFF505154), fontSize: 10, fontWeight: FontWeight.w500),),
                                                              SizedBox(height: 5,),

                                                              Text("${snapshot.data![index]['area_nombre']}", style: TextStyle(color: Color(0XFF505154), fontSize: 10, ),),

                                                              SizedBox(height: 4,),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              ),

                                              Row(
                                                children: [
                                                  Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right:8.0),
                                                      child: Container(
                                                        height: 45,
                                                        width: 30,
                                                        child: IconButton(
                                                          icon: FaIcon(FontAwesomeIcons.filePen, color: S2BColors.primaryColor),
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                TextEditingController notaController = TextEditingController();
                                                                TextEditingController condicionController = TextEditingController();
                                                                bool activo = false;
                                                                // Otras variables de estado necesarias para el formulario

                                                                return AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                  ),
                                                                  title: Text("Estado del empleado"),
                                                                  content: SingleChildScrollView(
                                                                    child: ListBody(
                                                                      children: <Widget>[
                                                                        TextField(
                                                                          controller: notaController,
                                                                          decoration: InputDecoration(
                                                                            labelText: 'Nota',
                                                                            border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 10),
                                                                        TextField(
                                                                          controller: condicionController,
                                                                          decoration: InputDecoration(
                                                                            labelText: 'Condición',
                                                                            border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 10),
                                                                        CheckboxListTile(
                                                                          title: Text("Activo"),
                                                                          value: activo,
                                                                          onChanged: (bool? newValue) {
                                                                            // Actualizar el estado
                                                                            activo = newValue!;
                                                                          },
                                                                        ),
                                                                        SizedBox(height: 10),
                                                                        ElevatedButton(
                                                                          onPressed: () {
                                                                            // Implementar la lógica para seleccionar un archivo o imagen
                                                                          },
                                                                          child: Text("Adjuntar Certificado"),
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor: S2BColors.primaryColor,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      child: Text("Cancelar"),
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: Text("Guardar"),
                                                                      onPressed: () {
                                                                        // Implementar lógica de guardado
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    ),
                                                    ),

                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(height: 1,),

                                ],
                              ),
                            );

                          },
                        )  : const Center(
                          // render the loading indicator
                          child: CircularProgressIndicator(),
                        )
                    ),
                  ),
                )
            ),



            //DETALLES PAGE
            Visibility(
              visible: indVisibility,
              child: Expanded(
                flex: 8,
                child: FutureBuilder(
                    future: RequestCapacitacionDetalle(),

                    builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>

                    snapshot.hasData ? ListView.builder(

                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, index) {
                          /*    String desviacion ="${snapshot.data![index]['desviacion']}";
                            if(desviacion.isEmpty){
                              desviacion='-';
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

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width*0.55,
                                                  child: Text("${snapshot.data![index]['nombre']} ", style: TextStyle(color: Color(0XFF505154), fontSize: 14, fontWeight: FontWeight.bold), )),
                                              SizedBox(height: 10,),
                                              Container(
                                                width: 80,
                                                height: 25,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                //      shape: StadiumBorder(),
                                                      backgroundColor: S2BColors.orange
                                                  ),
                                                  onPressed: (){

                                                  },
                                                  child: FittedBox(child: Text("${snapshot.data![index]['curso_estado']}", style: TextStyle(fontWeight: FontWeight.bold),)),
                                                ),
                                              )

                                            ],
                                          ),

                                      Container(
                                        width: 105,
                                        height: 50,
                                        padding: EdgeInsets.only(left: 8.0),
                                        decoration: const BoxDecoration(
                                            border: Border(left: BorderSide(width: 0.5, color: Color(0XFFB6B6B6)))),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children:[
                                                Text("Inicio: ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: S2BColors.primaryColor),),
                                                Text("${snapshot.data![index]['fecha_inicio'].substring(0,10)}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: S2BColors.primaryColor),),
                                              ],
                                            ),
                                            SizedBox(height: 7,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Fin: ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: S2BColors.primaryColor),),

                                                Text("${snapshot.data![index]['fecha_final'].substring(0,10)}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: S2BColors.primaryColor),),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  Divider(height: 20,),

                                  Container(
                                    decoration: BoxDecoration(        color: Colors.white,  borderRadius: BorderRadius.circular(10.0) ),
                                    child:   Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Expositor:   ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                              Text("${snapshot.data![index]['expositor']}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),)
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

                                  //Detalles
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
                                                              Icon(Icons.wysiwyg_rounded , color: Colors.white, size: 18,),
                                                              SizedBox(width: 4,),
                                                              Text("  Detalles", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                                                            ],
                                                          ),
                                                          Icon(Icons.arrow_drop_up, color: Colors.white,)
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
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: Column(
                                                            children: [

                                                              Container(
                                                                decoration: BoxDecoration(        color: Colors.white,  borderRadius: BorderRadius.circular(10.0) ),
                                                                  child: Column(
                                                                    children: [

                                                                      /*
                                                                      Row(
                                                                        children: [
                                                                          Text("Descripción:", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),

                                                                        ],
                                                                      ),
                                                                      SizedBox(height: 6,),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(child: Text("${snapshot.data![index]['descripcion']}", style: TextStyle(height: 1.6, fontSize: 13),))
                                                                        ],
                                                                      ),
                                                                      Divider(height: 25,),

                                                   */

                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                              width:  MediaQuery.of(context).size.width*0.30,
                                                                              child: Row(
                                                                                children: [
                                                                                  Icon(Icons.apartment_rounded, color: S2BColors.primaryColor, size: 18,),
                                                                                  SizedBox(width: 5,),
                                                                                  Text("Insitución:  ", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                                                                ],
                                                                              )),
                                                                          Container(
                                                                              width: MediaQuery.of(context).size.width*0.50,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text("${snapshot.data![index]['institucion']}", style: TextStyle(fontSize: 13,)),
                                                                                ],
                                                                              ))
                                                                        ],
                                                                      ),

                                                                      Divider(height: 20,),

                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                              width:  MediaQuery.of(context).size.width*0.30,
                                                                              child: Row(
                                                                                children: [
                                                                                  Icon(Icons.reduce_capacity_outlined, color: S2BColors.primaryColor, size: 18,),
                                                                                  SizedBox(width: 5,),
                                                                                  Text("Modalidad:  ", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                                                                ],
                                                                              )),
                                                                          Container(
                                                                              width: MediaQuery.of(context).size.width*0.50,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text("${snapshot.data![index]['modalidad']}", style: TextStyle(fontSize: 13,)),
                                                                                ],
                                                                              ))
                                                                        ],
                                                                      ),

                                                                      Divider(height: 25,),


                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Row(
                                                                              children: [

                                                                                Text("Puntaje Curso:  ", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                                                                Container(child: Text('${snapshot.data![index]['puntaje_curso']}', style: TextStyle(fontSize: 13,)),)
                                                                              ],
                                                                            ),
                                                                            //${snapshot.data![index]['Incidencia_Flag_Backlog']}
                                                                            SizedBox(child: Text('|', style: TextStyle(color: Color(0XFFB6B6B6)),),),

                                                                            Row(
                                                                              children: [

                                                                                Text("Puntaje Aprob:  ", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                                                                Container(child: Text('${snapshot.data![index]['puntaje_aprobatorio']}', style: TextStyle(fontSize: 13,)),)
                                                                              ],
                                                                            ),

                                                                            //${snapshot.data![index]['Incidencia_Pase']}

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
                                                          Icon(Icons.wysiwyg_rounded , color: Colors.white, size: 18,),
                                                          SizedBox(width: 4,),
                                                          Text("  Detalles", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
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

                                  //Temas
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
                                                              Icon(Icons.checklist , color: Colors.white, size: 18,),
                                                              SizedBox(width: 4,),
                                                              Text("  Temas", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                                                            ],
                                                          ),
                                                          Icon(Icons.arrow_drop_up, color: Colors.white,)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(children: [

                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Color(0XFFFDFDFD),
                                                            borderRadius: BorderRadius.circular(10.0) ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: Column(
                                                            children: [

                                                              /*
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text('Total de Temas:  ' , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                                                    Text('$totalTemas', style: TextStyle( fontSize: 12, fontWeight: FontWeight.bold,),),
                                                                  ],
                                                                ),
                                                              ),
                                                              */

                                                              SizedBox(height: 10,),

                                                              Container(
                                                                height: 150,
                                                                  child: FutureBuilder(
                                                                      future: RequestListaTemasCurso(),

                                                                      builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>

                                                                      snapshot.hasData ? ListView.builder(

                                                                          itemCount: snapshot.data!.length,
                                                                          itemBuilder: (BuildContext context, index) {

                                                                            return  Card(
                                                                              elevation: 5,
                                                                              child: Container(
                                                                                width: MediaQuery.of(context).size.width*0.9,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            color:Color(0XFFFDFDFD),
                                                                                            width: MediaQuery.of(context).size.width*0.77,
                                                                                            child:
                                                                                            Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [

                                                                                                Text("${snapshot.data![index]['nombre']}", style: TextStyle(fontSize: 12, color: Color(0XFF505154), fontWeight: FontWeight.bold, height: 1.5),),
                                                                                                SizedBox(height: 10,),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                  children: [
                                                                                                    Row(
                                                                                                      children: [
                                                                                                        Text("Código:  ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12 )),
                                                                                                        Text("${snapshot.data![index]['codigo']}", style: TextStyle(fontSize: 12, color: Colors.black,  height: 1.5),),
                                                                                                      ],
                                                                                                    ),
                                                                                                    Container(
                                                                                                      width: 90,
                                                                                                      height: 25,
                                                                                                      child: ElevatedButton(
                                                                                                        style: ElevatedButton.styleFrom(
                                                                                                          //   shape: StadiumBorder(),
                                                                                                          //   shape: StadiumBorder(),
                                                                                                            backgroundColor: S2BColors.orange
                                                                                                        ),
                                                                                                        onPressed: (){


                                                                                                        },
                                                                                                        child: FittedBox(child: Text("${snapshot.data![index]['tipo_tema']}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),)),
                                                                                                      ),
                                                                                                    )


                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                      )
                                                                          : const Center(
                                                                        // render the loading indicator
                                                                        child: CircularProgressIndicator(),
                                                                      )
                                                                  ),
                                                              )
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
                                                          Icon(Icons.checklist , color: Colors.white, size: 18,),
                                                          SizedBox(width: 4,),
                                                          Text("  Temas", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
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

                                  Container(
                                    decoration: BoxDecoration(        color: S2BColors.primaryColor,  borderRadius: BorderRadius.circular(10.0) ),
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
                    )),
              ),
            ),
          ],
        ),
      ),



      floatingActionButton: Visibility(
        visible: incVisibility,
        child: FloatingActionButton(
          onPressed: () => mostrarDialogoAgregarParticipantes(context), // Asumiendo '41' como idCurso de ejemplo
          backgroundColor: S2BColors.orange,
          child: const Icon(Icons.person_add),
        ),
      ),

    );
  }

  Future <List< dynamic>> RequestCapacitacionDetalle() async {
    final user = await authController.getUserFromStorage();
    idCurso = '${widget.idCurso}';
    var url = '${user!.urlApp}/ws/null/pr_ws_capacitacion_detalle?id_curso=$idCurso';
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
    var data = jsonDecode(response.body)['data'];

    /*
    final result =
    (data.map((e) => AsistenciaCheckModel.fromJson(e)).toList() as List).map((emp) {
      print('Insertando.. $emp');
      sqlDb.createAsistenciaCheck(emp);
    }).toList();
    */

   // print("data ----> ${data}]");
    return data;
  }





  //Temas x curso

  Future <List< dynamic>> RequestListaTemasCurso() async {
    final user = await authController.getUserFromStorage();
    var url = '${user!.urlApp}/ws/null/pr_ws_lista_curso_tema?id_curso=${widget.idCurso}';
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
    var data = jsonDecode(response.body)['data'];

    List  results = [];
    //   results = data.map((e) => EmpleadoIncGen_model.fromJson(e)).toList();
    print("data ----> ${data}\n length --- $totalTemas ]");
    return data;
  }


  Future <List< dynamic>> RequestParticipantesCurso() async {
    final user = await authController.getUserFromStorage();
    idCurso = '${widget.idCurso}';
    var url = '${user!.urlApp}/ws/null/pr_ws_lista_participantes_curso?id_curso=$idCurso';
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
    var data = jsonDecode(response.body)['data'];
    print("asistencia ----> ${data}]");

    parametros_metales = data as List;
    //prueba = data;
    // print("longdata ---- ${data}");
    key: ValueKey(needToUpdate);
    return data;
  }


  Future <List< dynamic>> RequestAsistenciaCurso() async {
    final user = await authController.getUserFromStorage();
    idCurso = '${widget.idCurso}';
    var url = '${user!.urlApp}/ws/null/pr_ws_lista_asistentes_curso?id_curso=$idCurso';
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
    var data = jsonDecode(response.body)['data'];
    print("asistencia ----> ${data}]");

    parametros_metales = data as List;

    return data;
  }


  Future <List< dynamic>> SubirMarcadoAsistencia(String fb_emp) async {
    final user = await authController.getUserFromStorage();
    idCurso = '${widget.idCurso}';
    var url = '${user!.urlApp}/ws/null/pr_ws_participante_asistencia?fb_empleado_id=$fb_emp&id_curso=$idCurso';
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
    var data = jsonDecode(response.body)['data'];
    print("asistencia ----> ${data}]");

    parametros_metales = data as List;
    //prueba = data;

    // print("longdata ---- ${data}");

    return data;
  }


  //Subir/Desmarcar asistencia de participantes:

  Future <http.Response> ParticipanteAsistencia(String fb_emp, String estado) async {
    final user = await authController.getUserFromStorage();
    idCurso = '${widget.idCurso}';
    var url = '${user!.urlApp}/ws/null/pr_ws_update_participante_asistente?fb_empleado_id=$fb_emp&id_curso=$idCurso&estado=$estado';
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

    return response;
  }


  void mostrarDialogoAgregarParticipantes(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    List<int> idsSeleccionados = [];

    // Suponiendo que readAllEmp() es una función que retorna una lista de EmpleadoModel

    readAllEmp().then((empleados) {

      Map<String, List<EmpleadoModel>> grupos = agruparParticipantes(empleados);
      Map<String, List<EmpleadoModel>> gruposFiltrados = Map.from(grupos);
      Map<int, bool> selectedEmpleados = Map.fromIterable(empleados, key: (e) => e.id, value: (e) => false);


      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              void filtrarParticipantes(String query) {
                if (query.isEmpty) {
                  gruposFiltrados = Map.from(grupos);
                } else {
                  gruposFiltrados.clear();
                  grupos.forEach((letra, lista) {
                    List<EmpleadoModel> listaFiltrada = lista.where((empleado) {
                      return empleado.nombreCompleto.toLowerCase().contains(query.toLowerCase());
                    }).toList();

                    if (listaFiltrada.isNotEmpty) {
                      gruposFiltrados[letra] = listaFiltrada;
                    }
                  });
                }
                setState(() {});
              }


              return AlertDialog(

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: Container(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: "Buscar participante",
                          suffixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onChanged: filtrarParticipantes,
                      ),
                      SizedBox(height: 18),

                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: ListView.builder(
                            itemCount: gruposFiltrados.keys.length,
                            itemBuilder: (context, index) {
                              String key = gruposFiltrados.keys.elementAt(index);


                              final empleado = empleados[index];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Text(key, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  ),
                                  ...gruposFiltrados[key]!.map((empleado) {
                                    final isSelected = selectedEmpleados[empleado.id] ?? false;
                                    return CheckboxListTile(
                                      title: Text(empleado.nombreCompleto),
                                      value: isSelected,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          selectedEmpleados[empleado.id] = value!;
                                          if (value) {
                                            idsSeleccionados.add(empleado.id);

                                            print('ID empleados a agregar: $idsSeleccionados');
                                          }else {
                                            idsSeleccionados.remove(empleado.id);
                                          }

                                        });
                                      },
                                    );
                                  }).toList(),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                actions: <Widget>[
                  ElevatedButton(
                      child: Text("Cancelar"),
                      onPressed: () {
                        setState(() {
                          idsSeleccionados.clear();
                          selectedEmpleados.forEach((key, value) => selectedEmpleados[key] = false);
                        });
                        Navigator.of(context).pop();
                      },
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
                  ),
              ),
              ),
                  ElevatedButton(
                      child: Text("Agregar"),
              onPressed: () async {
              for (var id in idsSeleccionados) {
              await RequestInsertarAsistentes(widget.idCurso.toString(), id, '1');
              }
              print("IDs seleccionados: $idsSeleccionados");

              // Actualiza el estado para reflejar los nuevos participantes

              setState(() {

                Navigator.of(context).pop(); // Si deseas cerrar el diálogo.
                RequestParticipantesCurso().then((updatedList) {
                  if (mounted) {
                    setState(() {
                      listOfItems = updatedList;
                      refreshParticipants(); // Llama a esto para actualizar la lista.
                    });
                  }
                });

              });


              Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              ),
              ),

                  )
                ],
              );
            },
          );
        },
      ).catchError((error) {
        // Manejar errores
      });
    });
  }

  void eliminarParticipante(int empleadoId) async {

    await RequestInsertarAsistentes(widget.idCurso.toString(), empleadoId, '0');

    print("Eliminar participante: $empleadoId");
  }

  Future<List<EmpleadoModel>> readAllEmp() async {
    final user = await authController.getUserFromStorage();
    var map = new Map<String, String>();

    map['sc_user_id'] = '18544';
    var url = '${user!.urlApp}/ws/null/empleados?pr_ws_fb_empleados';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
      },
    );
    body:map;
    //UPDATE------
    print("${response.statusCode}");
    var data = jsonDecode(response.body)['data'];
    print("lista ----> ${data}]");
    // final list = List.from(data).map((item) => EmpleadoModel.fromJson(item)).toList();
    if (data != null) {
      print('hay datos !!!');

      listNuevosAsistentes = data;
      // print('lista nuevos asistentes --- $listNuevosAsistentes');
      return   List.from(data).map((item) => EmpleadoModel.fromJson(item)).toList();
    }else{
      print("Error --");
    }
    return [];
  }


  Future <http.Response> RequestInsertarAsistentes(String idCurso, int idEmp, String est) async {
    final user = await authController.getUserFromStorage();
    var url = '${user!.urlApp}/ws/null/pr_ws_cap_registra_asistencia?fb_empleado_id=${idEmp}&id_curso=${idCurso}&estado=$est';
    var mapIncGen = Map<String, dynamic>();
    var response = await http.post(Uri.parse(url),
        headers: {
          "userLogin": "${user.userLogin}@${user.arroba}",
          "userPassword": "${user.password}",
          "systemRoot": "${user.enterprise}"
        },
        body: jsonEncode(mapIncGen)
    );

    if (response.statusCode == 201) {print('Data inserted successfully');} else {print('Insertion failed--- NULL');}

    print("${response.statusCode}");
    var data = jsonDecode(response.body)['data'];
    print("data ----> ${data}]");
    return response;
  }
}

Map<String, List<EmpleadoModel>> agruparParticipantes(List<EmpleadoModel> empleados) {
  Map<String, List<EmpleadoModel>> grupos = {};
  for (var empleado in empleados) {
    String letraInicial = empleado.nombreCompleto[0].toUpperCase();
    if (!grupos.containsKey(letraInicial)) {
      grupos[letraInicial] = [];
    }
    grupos[letraInicial]!.add(empleado);
  }
  return grupos;
}



class EmpleadoModel {
  final int id;
  final String nombreCompleto;

  EmpleadoModel({required this.id, required this.nombreCompleto});

  factory EmpleadoModel.fromJson(Map<String, dynamic> json) {
    return EmpleadoModel(
      id: json['fb_empleado_id'],
      nombreCompleto: json['nombreCompleto'],
    );
  }
}