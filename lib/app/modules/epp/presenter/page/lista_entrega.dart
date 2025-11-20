import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bottom_nav_layout/bottom_nav_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:safe2biz/app/global/core/shared_widgets/navigation/nav.dart';
import 'package:safe2biz/app/global/core/utils/utils.dart';
import 'package:safe2biz/app/modules/epp/external/api/entrega_epp_api.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/SubirReg.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/agregar_entrega.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/estadistica_entrega.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/lista_productos_personal.dart';
import 'package:safe2biz/app/modules/epp/presenter/widgets/FechaHora.dart';
import 'package:safe2biz/app/modules/sedes/features/company/presenter/page/company_page.dart';
import 'dart:convert';   //--> Json
import 'package:flutter_slidable/flutter_slidable.dart';

String result = "";
bool? flag;

final TextEditingController searchController = TextEditingController();

final localSqliteInstance = LocalSqlite();
final authController = AuthController(sqlite: localSqliteInstance);

void main() => runApp(

    MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF0A3987),

          hintColor: Colors.black,


          ),


        debugShowCheckedModeBanner: false,
        title: 'Lista',
        home: BottomNavLayout(
          lazyLoadPages: true,
          pages: [
                (_) => ListaPersonal(),
                (_) => EstadisticaEntrega(),
          ],
          bottomNavigationBar: (currentIndex, onTap) => BottomNavigationBar(
            backgroundColor: Color(0xFF0A3987),
            currentIndex: currentIndex,
            onTap: (index) => onTap(index),
            selectedItemColor: Colors.orange,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Lista'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Estadisticas'),
            ],
          ),
        )
    )
);

//variable global
int? idEmpleadoFuture;
int? fb_empleado_id;
String? dni;
String? nombreCompleto ;
int? fb_area_id;
String? codigo_area;
String? nombre_area;
int? fb_puesto_trabajo_id;
String? codigo_puesto;
String? nombre_puesto;
int? fb_cargo_id;
String? codigo_cargo;
String? nombre_cargo;
int? epp_rol_epp_id;
String? rol_epp_codigo;
String? rol_epp_nombre;
int? epp_ficha_entrega_id;
int? fb_uea_pe_id;
String? fecha_entrega_epp;
String? hora_entrega_epp;
bool logoNoExistenRegistro =true;
bool btnEliminarRegistro = true;
//int? sede;  //Sede escogida
int? getIdUser; //user_id
String? sedeEmp;
bool updateIcon=true;

int? entrega_id;

int? cantProdEntregar;
class ListaPersonal extends StatefulWidget {

  final String? sede;
  final String? fecha;
  const ListaPersonal ({Key? key, this.fecha, this.sede}) : super(key: key);
  @override
  State<ListaPersonal> createState() => _ListaPersonalState();
}


final apiEntrega = ApiEntregaEpp();

Color? colorEstado;

//Filtrar empleados
String? fFiltro;
//Escaner
bool isSwitched = false;
String scanBarcode = 'Desconocido';
String? fotoUsuario;

DioMicroServices? dioMicroServices;


class _ListaPersonalState extends State<ListaPersonal> {

  SqlDb sqlDb = SqlDb();
  List empleados = [];

  //Elegir fecha
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _asyncMethod();
        });
    });

    apiEntrega.readDataEntregaMinaEpp();
    apiEntrega.readDataEntregaEpp();
    apiEntrega.readDataEntreg();
    apiEntrega.readDataEntregaDetalleEpp();

    result = '';
    sedeEmp = "${widget.sede}";
    print("SEDE ---> ${sedeEmp}");
    print("sede epp ---> ${widget.sede}");
    print("sede epp ---> ${sedeEmp}");
    searchController.text = '';
    dateInput.text = "dd/mm/yyyy";

    super.initState();
  }


  _asyncMethod() async {

    List<Map> listaReg = await readData();
    print("lista reg--> ${listaReg}");

    if(listaReg.isEmpty || listaReg == ''){
      logoNoExistenRegistro = true;
      btnEliminarRegistro = false;
      setState(() {});
      print("======NO HAY DATOS");


    }
    else{
      logoNoExistenRegistro = false;
      btnEliminarRegistro = true;
      setState(() {});
      print("======SI HAY DATOS");
    }
  }

  //Se movio desde Widget build(BuildContext context)
  Future<List<Map>> readData() async {
    setState(() {});

    List<Map> responseReadAll = await sqlDb.readData(
        "SELECT empleadoMina.id, empleadoMina.fb_empleado_id, empleadoMina.nombreCompleto,empleadoMina.fb_puesto_trabajo_id,empleadoMina.cargo_nombre, empleadoMina.foto,empleadoMina.numero_documento,empleadoMina.area_nombre, empleadoMina.fb_area_id,empleadoMina.area_codigo,empleadoMina.puesto_trabajo_codigo,empleadoMina.puesto_trabajo_nombre,empleadoMina.fb_cargo_id,empleadoMina.cargo_codigo,empleadoMina.cargo_nombre,empleadoMina.epp_rol_epp_id,empleadoMina.codigo_rol,empleadoMina.nombre_rol, empleadoMina.fb_uea_pe_id, "
            " empleadoMina.empresa, producto_empleado_mina.fecha_entrega, producto_empleado_mina.hora_entrega, producto_empleado_mina.id_empleado as prod_emp_mina_id, producto_empleado_mina.foto_evidencia, producto_empleado_mina.estado_subido, producto_empleado_mina.anho,  producto_empleado_mina.motivo, "
            " SUM(producto_empleado_mina.cantidad) as sumacantidad"
            " FROM empleadoMina "
            " INNER JOIN producto_empleado_mina ON empleadoMina.id = producto_empleado_mina.id_empleado"
            " WHERE empleadoMina.fb_uea_pe_id = ${widget.sede} "
            " GROUP BY producto_empleado_mina.foto_evidencia, producto_empleado_mina.hora_entrega"
            " ORDER BY substr(producto_empleado_mina.fecha_entrega,1,4) DESC, substr(producto_empleado_mina.fecha_entrega,9,2) DESC, substr(producto_empleado_mina.fecha_entrega,4,2) ASC, "
            " substr(producto_empleado_mina.hora_entrega, 1,2) ASC, substr(producto_empleado_mina.hora_entrega, 4,2) DESC "
    );
    print(responseReadAll);
    return responseReadAll;

  }



  @override
  Widget build(BuildContext context) {

    Future<int> cantDataEntregaDetalleEpp(int id, String fecha, String hora) async{
      List<Map> datoEntregaDetalleProd = await sqlDb.readData(
          " SELECT EntregaEpp.epp_entrega_id, EntregaDetalleEpp.epp_entrega_id, EntregaDetalleEpp.epp_ficha_entrega_id, EntregaDetalleEpp.epp_equipo_id, EntregaDetalleEpp.epp_producto_id, EntregaDetalleEpp.epp_motivo_entrega_id, EntregaDetalleEpp.epp_almacen_temp_id, EntregaDetalleEpp.estado_vigencia, EntregaDetalleEpp.flag_uso, EntregaDetalleEpp.fecha_entrega, EntregaDetalleEpp.fecha_fin_vigencia, EntregaDetalleEpp.flag_pertenece_rol, EntregaDetalleEpp.cantidad, EntregaDetalleEpp.tiempo_recambio  "
              " FROM EntregaDetalleEpp "
              " INNER JOIN EntregaEpp ON EntregaDetalleEpp.id_emp = EntregaEpp.fb_empleado_id "
              " WHERE EntregaEpp.fb_empleado_id = '${id}' AND EntregaEpp.fecha_entrega = '${fecha}' AND EntregaEpp.hora_entrega = '${hora}' ");
      print("DATO ENTREGA DETALLE ====> ${datoEntregaDetalleProd.length}");
      return datoEntregaDetalleProd.length;
    }

    Future<int> subirDatos(int id, String fecha, String hora) async {

      //Si sube 2 registros, agregar otro parametro prod_emp_mina.id
      int response = await sqlDb.insertData("UPDATE 'producto_empleado_mina' "
          " SET 'estado_subido' = 'Enviado' "
          " WHERE producto_empleado_mina.id_empleado = ${id} AND producto_empleado_mina.estado_subido = 'Por Enviar'  AND producto_empleado_mina.fecha_entrega = '${fecha}' AND producto_empleado_mina.hora_entrega = '${hora}' ");
      print(response);
      return response;
    }

    String sede = LocalPreferences.prefs?.getString('current_sede') ?? '';
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
    backgroundColor:  Color(0xffEBEFFB),
      appBar: AppBar(title: Text("$sede", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),), elevation: 0, backgroundColor: Color(0xff09357E),

        leading: Container(
          child: IconButton(onPressed: (){
           // Navigator.pop(context);
           // Navigator.pop(context);


            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>  CompanyPage() ),
            );

            }, icon: Icon(Icons.arrow_back , color: Colors.white)),

        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child:Column(
                children: [
                  Stack(alignment: Alignment.bottomRight , children: [
                Container(
                  margin: const EdgeInsets.only(bottom:24.0),
                  color: Color(0xff09357E),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, bottom: 12, top: 10),
                            child: Container(child: Text("Entrega EPP", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(right: 30),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Color(0xffF49536),
                            borderRadius: BorderRadius.all(Radius.circular(50))
                        ),

                        child: IconButton (onPressed:(){
                          Nav.go(context, AgregarEntrega());
                          }, icon: Icon(Icons.add, size: 30, color: Colors.white,)))

              ]),


                  SizedBox(height: 6,),
                  FutureBuilder(
                      future:  readData(),
                      builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot ){
                        if(snapshot.hasData){
                          return
                            ListView.builder(
                                itemCount: snapshot.data!.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, i){

                                  idEmpleadoFuture = snapshot.data![i]['id'];
                                  fb_empleado_id = snapshot.data![i]['fb_empleado_id'];
                                  dni = snapshot.data![i]['numeroDocumento'];
                                  nombreCompleto = snapshot.data![i]['nombreCompleto'];
                                  fb_area_id= snapshot.data![i]['fb_area_id'];
                                  codigo_area=snapshot.data![i]['area_codigo'];
                                  nombre_area=snapshot.data![i]['area_nombre'];
                                  fb_puesto_trabajo_id= snapshot.data![i]['fb_puesto_trabajo_id'];
                                  codigo_puesto=snapshot.data![i]['puesto_trabajo_codigo'];
                                  nombre_puesto= snapshot.data![i]['puesto_trabajo_nombre'];
                                  fb_cargo_id= snapshot.data![i]['fb_cargo_id'];
                                  codigo_cargo=snapshot.data![i]['cargo_codigo'];
                                  nombre_cargo=snapshot.data![i]['cargo_nombre'];
                                  epp_rol_epp_id= snapshot.data![i]['epp_rol_epp_id'];
                                  rol_epp_codigo=snapshot.data![i]['codigo_rol'];
                                  rol_epp_nombre=snapshot.data![i]['nombre_rol'];
                                  epp_ficha_entrega_id= snapshot.data![i]['id'];   //fixme: corregir
                                  fb_uea_pe_id=snapshot.data![i]['fb_uea_pe_id'];
                                  fecha_entrega_epp= snapshot.data![i]['fecha_entrega'];
                                  hora_entrega_epp = snapshot.data![i]['hora_entrega'];







                                  if("${snapshot.data![i]['estado_subido']}" == 'En Registro'){
                                    colorEstado = Color(0xffFF7777);
                                  }
                                  else if("${snapshot.data![i]['estado_subido']}" == 'Por Enviar'){
                                    colorEstado = Color(0xffFFBA55);
                                  }
                                  else if("${snapshot.data![i]['estado_subido']}" == 'Enviado'){
                                    colorEstado = Color(0xff67A856);
                                  }

                                  if(snapshot.data![i]['estado_subido'] == 'Enviado'){

                                    updateIcon = false;

                                  }else{

                                    updateIcon = true;

                                  }


                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,


                                    children: [

                                  Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                          child: Material(

                                            elevation: 0,

                                            child: Container(

                                              color:  Color(0xffEBEFFB),
                                              width: MediaQuery.of(context).size.width*1,
                                              child: InkWell(

                                                onTap : (){ Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => ListaProdPersonal(
                                                      ///Cambiar var
                                                      idEmp: snapshot.data![i]['id'],
                                                      codigo: "${snapshot.data![i]['codigo']}",
                                                      nombre: "${snapshot.data![i]['nombreCompleto']}",
                                                      dni: "${snapshot.data![i]['numero_documento']}",
                                                      cargo: "${snapshot.data![i]['cargo_nombre']}",
                                                      //   email: "${snapshot.data![i]['email']}",
                                                      area: "${snapshot.data![i]['area_nombre']}",
                                                      //    foto: "${snapshot.data![i]['foto']}",
                                                      organizacion: "${snapshot.data![i]['empresa']}",
                                                      f_entrega: "${snapshot.data![i]['fecha_entrega']}",
                                                      h_entrega: "${snapshot.data![i]['hora_entrega']}",

                                                      foto_emp: "${snapshot.data![i]['foto']}",
                                                      foto_prod: "${snapshot.data![i]['foto_prod']}",
                                                      foto_evidencia: "${snapshot.data![i]['foto_evidencia']}",  //path file /data ... .jpg
                                                      estado_subido: "${snapshot.data![i]['estado_subido']}",

                                                      //

                                                    ),),);
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.zero,
                                                  child: Card(
                                                    color: Colors.white,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Slidable(
                                                          key: Key(snapshot.toString()),
                                                          startActionPane: ActionPane(

                                                            extentRatio: 0.3,
                                                            // A motion is a widget used to control how the pane animates.
                                                            motion:  DrawerMotion(),
                                                            dismissible: DismissiblePane(onDismissed: () async {

                                                              if(snapshot.data![i]['estado_subido'] == 'Por enviar' || snapshot.data![i]['estado_subido'] == 'Enviado'){

                                                                showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return AlertDialog(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                                                        title: Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [

                                                                                Icon(Icons.delete, size: 25, ),
                                                                                Text(' Eliminar Entrega'),
                                                                              ],
                                                                            ),

                                                                            SizedBox(height: 10,),
                                                                            Divider(height: 1, color: Colors.grey,),
                                                                          ],
                                                                        ),
                                                                        content:
                                                                        Text('¿Desea eliminar la entrega de ${snapshot.data![i]['nombreCompleto']} con ${snapshot.data![i]['sumacantidad']} equipos por enviar?', style: TextStyle(height: 1.5, fontSize: 14),),
                                                                        actions: [
                                                                          ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text('No')),
                                                                          ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                                              onPressed: () async {


                                                                                print("ID EMP --> ${snapshot.data![i]['id']}");
                                                                                print("Fecha -->${snapshot.data![i]['fecha_entrega']}");
                                                                                print("Hora -->${snapshot.data![i]['hora_entrega']}");



                                                                                int responseEntregaEpp = await sqlDb.deleteData("DELETE FROM EntregaEpp "
                                                                                    " WHERE EntregaEpp.id_emp = '${snapshot.data![i]['id']}' "
                                                                                    " AND EntregaEpp.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                                    " AND EntregaEpp.hora_entrega = '${snapshot.data![i]['hora_entrega']}' ");
                                                                                print("se elimino ---> $responseEntregaEpp");




                                                                                int response = await sqlDb.deleteData("DELETE FROM producto_empleado_mina "
                                                                                    " WHERE producto_empleado_mina.id_empleado = '${snapshot.data![i]['prod_emp_mina_id']}' "
                                                                                    " AND producto_empleado_mina.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                                    " AND producto_empleado_mina.hora_entrega = '${snapshot.data![i]['hora_entrega']}' ");
                                                                                print(response);



                                                                                print("ID EMP --> ${snapshot.data![i]['id']}");
                                                                                print("Fecha -->${snapshot.data![i]['fecha_entrega']}");
                                                                                print("Hora -->${snapshot.data![i]['hora_entrega']}");



                                                                                int responseEntregaDetalleEpp = await sqlDb.deleteData("DELETE FROM EntregaDetalleEpp "
                                                                                    " WHERE EntregaDetalleEpp.id_emp  = '${snapshot.data![i]['id']}}' "
                                                                                    " AND EntregaDetalleEpp.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                                    " AND EntregaDetalleEpp.hora_entrega = '${snapshot.data![i]['hora_entrega']}' " );
                                                                                print(responseEntregaEpp);
                                                                                print("se elimino ----> $responseEntregaDetalleEpp");



                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text(
                                                                                'Eliminar',
                                                                              )),
                                                                        ],
                                                                      );
                                                                    });
                                                              }else{

                                                                print("ID EMP --> ${snapshot.data![i]['id']}");
                                                                print("Fecha -->${snapshot.data![i]['fecha_entrega']}");
                                                                print("Hora -->${snapshot.data![i]['hora_entrega']}");



                                                                int responseEntregaEpp = await sqlDb.deleteData("DELETE FROM EntregaEpp "
                                                                    " WHERE EntregaEpp.id_emp = '${snapshot.data![i]['id']}' "
                                                                    " AND EntregaEpp.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                    " AND EntregaEpp.hora_entrega = '${snapshot.data![i]['hora_entrega']}' ");
                                                                print("se elimino ---> $responseEntregaEpp");




                                                                int response = await sqlDb.deleteData("DELETE FROM producto_empleado_mina "
                                                                    " WHERE producto_empleado_mina.id_empleado = '${snapshot.data![i]['prod_emp_mina_id']}' "
                                                                    " AND producto_empleado_mina.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                    " AND producto_empleado_mina.hora_entrega = '${snapshot.data![i]['hora_entrega']}' ");
                                                                print(response);



                                                                print("ID EMP --> ${snapshot.data![i]['id']}");
                                                                print("Fecha -->${snapshot.data![i]['fecha_entrega']}");
                                                                print("Hora -->${snapshot.data![i]['hora_entrega']}");



                                                                int responseEntregaDetalleEpp = await sqlDb.deleteData("DELETE FROM EntregaDetalleEpp "
                                                                    " WHERE EntregaDetalleEpp.id_emp  = '${snapshot.data![i]['id']}' "
                                                                    " AND EntregaDetalleEpp.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                    " AND EntregaDetalleEpp.hora_entrega = '${snapshot.data![i]['hora_entrega']}' " );
                                                                print(responseEntregaEpp);
                                                                print("se elimino ----> $responseEntregaDetalleEpp");

                                                                setState(() {});
                                                              }
                                                            }),



                                                            children: [
                                                              Container(
                                                                child: SlidableAction(


                                                                  flex:2,
                                                                  onPressed:(BuildContext context) async{

                                                                    if(snapshot.data![i]['estado_subido'] == 'Por enviar' || snapshot.data![i]['estado_subido'] == 'Enviado'){
                                                                      showDialog(
                                                                          context: context,
                                                                          builder: (BuildContext context) {
                                                                            return AlertDialog(
                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                                                              title: Column(
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Icon(Icons.delete, size: 25),
                                                                                      Text(' Eliminar Entrega'),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(height: 10,),
                                                                                  Divider(height: 1, color: Colors.grey,),
                                                                                ],
                                                                              ),
                                                                              content:
                                                                              Text('¿Desea eliminar la entrega de ${snapshot.data![i]['nombreCompleto']} con ${snapshot.data![i]['sumacantidad']} equipos por enviar?', style: TextStyle(height: 1.5, fontSize: 14),),
                                                                              actions: [
                                                                                ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: const Text('No')),
                                                                                ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                                                    onPressed: () async {

                                                                                      print("ID EMP --> ${snapshot.data![i]['id']}");
                                                                                      print("Fecha -->${snapshot.data![i]['fecha_entrega']}");
                                                                                      print("Hora -->${snapshot.data![i]['hora_entrega']}");



                                                                                      int responseEntregaEpp = await sqlDb.deleteData("DELETE FROM EntregaEpp "
                                                                                          " WHERE EntregaEpp.id_emp = '${snapshot.data![i]['id']}' "
                                                                                          " AND EntregaEpp.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                                          " AND EntregaEpp.hora_entrega = '${snapshot.data![i]['hora_entrega']}' ");
                                                                                      print("se elimino ---> $responseEntregaEpp");




                                                                                      int response = await sqlDb.deleteData("DELETE FROM producto_empleado_mina "
                                                                                          " WHERE producto_empleado_mina.id_empleado = '${snapshot.data![i]['prod_emp_mina_id']}' "
                                                                                          " AND producto_empleado_mina.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                                          " AND producto_empleado_mina.hora_entrega = '${snapshot.data![i]['hora_entrega']}' ");
                                                                                      print(response);



                                                                                      print("ID EMP --> ${snapshot.data![i]['id']}");
                                                                                      print("Fecha -->${snapshot.data![i]['fecha_entrega']}");
                                                                                      print("Hora -->${snapshot.data![i]['hora_entrega']}");

                                                                                      int responseEntregaDetalleEpp = await sqlDb.deleteData("DELETE FROM EntregaDetalleEpp "
                                                                                          " WHERE EntregaDetalleEpp.id_emp  = '${snapshot.data![i]['id']}' "
                                                                                          " AND EntregaDetalleEpp.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                                          " AND EntregaDetalleEpp.hora_entrega = '${snapshot.data![i]['hora_entrega']}' " );
                                                                                      print(responseEntregaEpp);
                                                                                      print("se elimino ----> $responseEntregaDetalleEpp");

                                                                                      setState(() {});
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: const Text(
                                                                                      'Eliminar',
                                                                                    )),
                                                                              ],
                                                                            );
                                                                          });

                                                                    }else{

                                                                      print("ID EMP --> ${snapshot.data![i]['id']}");
                                                                      print("Fecha -->${snapshot.data![i]['fecha_entrega']}");
                                                                      print("Hora -->${snapshot.data![i]['hora_entrega']}");



                                                                      int responseEntregaEpp = await sqlDb.deleteData("DELETE FROM EntregaEpp "
                                                                          " WHERE EntregaEpp.id_emp = '${snapshot.data![i]['id']}' "
                                                                          " AND EntregaEpp.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                          " AND EntregaEpp.hora_entrega = '${snapshot.data![i]['hora_entrega']}' ");
                                                                      print("se elimino ---> $responseEntregaEpp");




                                                                      int response = await sqlDb.deleteData("DELETE FROM producto_empleado_mina "
                                                                          " WHERE producto_empleado_mina.id_empleado = '${snapshot.data![i]['prod_emp_mina_id']}' "
                                                                          " AND producto_empleado_mina.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                          " AND producto_empleado_mina.hora_entrega = '${snapshot.data![i]['hora_entrega']}' ");
                                                                      print(response);



                                                                      print("ID EMP --> ${snapshot.data![i]['id']}");
                                                                      print("Fecha -->${snapshot.data![i]['fecha_entrega']}");
                                                                      print("Hora -->${snapshot.data![i]['hora_entrega']}");



                                                                      int responseEntregaDetalleEpp = await sqlDb.deleteData("DELETE FROM EntregaDetalleEpp "
                                                                          " WHERE EntregaDetalleEpp.id_emp  = '${snapshot.data![i]['id']}' "
                                                                          " AND EntregaDetalleEpp.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                          " AND EntregaDetalleEpp.hora_entrega = '${snapshot.data![i]['hora_entrega']}' " );
                                                                      print(responseEntregaEpp);
                                                                      print("se elimino ----> $responseEntregaDetalleEpp");

                                                                      setState(() {});

                                                                    }
                                                                  },


                                                                  backgroundColor: Color(0xFFFE4A49),
                                                                  //  foregroundColor: Colors.white,
                                                                  icon:  Icons.delete,
                                                                  label: 'Eliminar',
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                            child: Column(

                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: <Widget>[

                                                                Container(
                                                                  padding: EdgeInsets.symmetric(vertical:2.0),
                                                                  height: 35,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      SizedBox(height: 0,),
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width*0.77,
                                                                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(Icons.insert_drive_file_outlined, size: 18, color: Color(0xff00297B)),
                                                                            Text("  ${snapshot.data![i]['fecha_entrega']}", style: TextStyle(fontSize: 15, color: Color(0xff00297B), fontWeight: FontWeight.bold ),),
                                                                            SizedBox(width: 5,),
                                                                            Text("-"),
                                                                            SizedBox(width: 5,),
                                                                            Text("${snapshot.data![i]['hora_entrega']}", style: TextStyle(fontSize: 15, color: Color(0xff00297B), fontWeight: FontWeight.bold))
                                                                          ],
                                                                        )
                                                                      ),


                                                                     Visibility(
                                                                       visible: updateIcon,
                                                                       child: IconButton(icon: FaIcon(FontAwesomeIcons.upload,size: 16, color: Color(0xff09357E),) ,onPressed: () async{

                                                                         cantProdEntregar = await cantDataEntregaDetalleEpp(idEmpleado, fechaEntrega, horaEntrega);

                                                                         List<Map> datoEntregaDetalleProd = await sqlDb.readData(
                                                                             " SELECT EntregaDetalleEpp.epp_entrega_id, EntregaDetalleEpp.epp_ficha_entrega_id, EntregaDetalleEpp.epp_equipo_id, EntregaDetalleEpp.epp_producto_id, EntregaDetalleEpp.epp_motivo_entrega_id, "
                                                                                 "EntregaDetalleEpp.epp_almacen_temp_id, EntregaDetalleEpp.estado_vigencia, EntregaDetalleEpp.flag_uso, EntregaDetalleEpp.fecha_entrega, EntregaDetalleEpp.fecha_fin_vigencia, "
                                                                                 "EntregaDetalleEpp.flag_pertenece_rol, EntregaDetalleEpp.cantidad, EntregaDetalleEpp.tiempo_recambio  "
                                                                                 " FROM EntregaDetalleEpp "
                                                                                 " WHERE EntregaDetalleEpp.id_emp = '${snapshot.data![i]['id']}' AND EntregaDetalleEpp.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' AND EntregaDetalleEpp.hora_entrega = '${snapshot.data![i]['hora_entrega']}' ");


                                                                         print("DATO ENTREGA DETALLE ====> ${datoEntregaDetalleProd}");
                                                                         print("id_emp ---> ${idEmpleado}");
                                                                         print("fecha_entrega --> ${fechaEntrega}");
                                                                         print("hora_entrega ---> ${horaEntrega}");

                                                                         print("id_emp ---> ${snapshot.data![i]['id']}");
                                                                         print("fecha_entrega --> ${snapshot.data![i]['fecha_entrega']}");
                                                                         print("hora_entrega ---> ${snapshot.data![i]['hora_entrega']}");


                                                                         print("${snapshot.data![i]['fecha_entrega']}");
                                                                         print("${snapshot.data![i]['hora_entrega']}");
                                                                         print("${snapshot.data![i]['id']}");



                                                                         await apiEntrega.readDataEntregaEpp;

                                                                         bool press = true;
                                                                         if(press && snapshot.data![i]['estado_subido'] == 'Enviado' ){

                                                                           AwesomeDialog(
                                                                             context: context,
                                                                             dialogType: DialogType.info,
                                                                             borderSide: const BorderSide(
                                                                               color: Color(0xff09357E),
                                                                               width: 2,
                                                                             ),
                                                                             width: 300,
                                                                             buttonsBorderRadius: const BorderRadius.all(
                                                                               Radius.circular(2),
                                                                             ),
                                                                             dismissOnTouchOutside: true,
                                                                             dismissOnBackKeyPress: false,
                                                                             onDismissCallback: (type) {
                                                                               ScaffoldMessenger.of(context).showSnackBar(
                                                                                 SnackBar(
                                                                                   content: Text('Dismissed by $type'),
                                                                                 ),
                                                                               );
                                                                             },
                                                                             headerAnimationLoop: false,
                                                                             animType: AnimType.bottomSlide,
                                                                             title: 'Info',
                                                                             desc: 'Este registro ya fue enviado',
                                                                             showCloseIcon: true,
                                                                             btnCancelOnPress: () {

                                                                             },
                                                                             btnOkOnPress: () {

                                                                             },
                                                                           ).show();



                                                                         }else if(press && snapshot.data![i]['estado_subido'] == 'En Registro' ){


                                                                           AwesomeDialog(
                                                                             context: context,
                                                                             dialogType: DialogType.info,
                                                                             borderSide: const BorderSide(
                                                                               color: Color(0xff09357E),
                                                                               width: 2,
                                                                             ),
                                                                             width: 300,
                                                                             buttonsBorderRadius: const BorderRadius.all(
                                                                               Radius.circular(2),
                                                                             ),
                                                                             dismissOnTouchOutside: true,
                                                                             dismissOnBackKeyPress: false,
                                                                             onDismissCallback: (type) {
                                                                               ScaffoldMessenger.of(context).showSnackBar(
                                                                                 SnackBar(
                                                                                   content: Text('Dismissed by $type'),
                                                                                 ),
                                                                               );
                                                                             },
                                                                             headerAnimationLoop: false,
                                                                             animType: AnimType.bottomSlide,
                                                                             title: 'Info',
                                                                             desc: 'Este registro aún sigue en proceso',
                                                                             showCloseIcon: true,
                                                                             btnCancelOnPress: () {

                                                                             },
                                                                             btnOkOnPress: () {

                                                                             },
                                                                           ).show();


                                                                         }else{

                                                                         await subirDatos(snapshot.data![i]['id'], snapshot.data![i]['fecha_entrega'], snapshot.data![i]['hora_entrega']);


                                                                         //ENTREGA EPP

                                                                         print("Id ==> ${idEmpleado},  fecha===> ${fecha_entrega_epp},   hora ==> ${hora_entrega_epp} ");

                                                                         var data =[];

                                                                  //     List<Map> datosEntrega = await EntregaProd();
                                                                   //    print("DATOS DEL RESULTADO 2 ==> ${datosEntrega}");
                                                                         Future<File> _toFile(dynamic v) async {
                                                                           if (v is File) return v;
                                                                           if (v is XFile) return File(v.path);
                                                                           if (v is String) return File(v);        // ruta
                                                                           throw Exception('Tipo no soportado: ${v.runtimeType}');
                                                                         }


                                                                         String formatDate = "${snapshot.data![i]['fecha_entrega'].replaceAll(new RegExp(r'[^\w\s]+'),'')}";
                                                                         String formatHour = "${snapshot.data![i]['hora_entrega'].replaceAll(new RegExp(r'[^\w\s]+'),'')}";

                                                                         //path to base64
                                                                         final String path = snapshot.data![i]["foto_evidencia"] as String;
                                                                         final File original = File(path);

// compressImage probablemente devuelve XFile? o File?
                                                                           final compressed = await Utils.compressImage(original);

// usa el comprimido si existe, si no el original
                                                                           final File listo = await _toFile(compressed ?? original);

// ahora sí: convertir a base64
                                                                           final String? fotoBase64Compress = await Utils.fileToBase64(listo);


                                                                         String? base64 = fotoBase64Compress;
                                                                         print("BASE 64  $base64");
                                                                         print("formatDate ${formatDate}");
                                                                         String base64Subida = '${formatDate}${formatHour}${snapshot.data![i]['id']}-min.jpg;${base64}';


                                                                         Future <http.Response> postEntregaEpp() async {
                                                                           final user = await authController.getUserFromStorage();


                                                                           var url = '${user!.urlApp}/ws/null/entrega_epp?pr_ws_entrega';
                                                                           var map = new Map<String, dynamic>();
                                                                           map['fb_empleado_id'] = '${snapshot.data![i]['fb_empleado_id']}';
                                                                           map['dni']= '${snapshot.data![i]['numero_documento']}';
                                                                           map['nombreCompleto']='${snapshot.data![i]['nombreCompleto']}';
                                                                           map['fb_area_id']= '${snapshot.data![i]["fb_area_id"]}';
                                                                           map['codigo_area']= '${snapshot.data![i]["area_codigo"]}';
                                                                           map['nombre_area']= '${snapshot.data![i]["area_nombre"]}';
                                                                           map['fb_puesto_trabajo_id'] = '${snapshot.data![i]["fb_puesto_trabajo_id"]}';
                                                                           map['codigo_puesto'] = '${snapshot.data![i]["puesto_trabajo_codigo"]}';
                                                                           map['nombre_puesto'] = '${snapshot.data![i]["puesto_trabajo_nombre"]}';
                                                                           map['fb_cargo_id'] = '${snapshot.data![i]["fb_cargo_id"]}';
                                                                           map['codigo_cargo'] = '${snapshot.data![i]["cargo_codigo"]}';
                                                                           map['nombre_cargo'] = '${snapshot.data![i]["cargo_nombre"]}';
                                                                           map['epp_rol_epp_id'] = '${snapshot.data![i]["epp_rol_epp_id"]}';
                                                                           map['rol_epp_codigo'] = '${snapshot.data![i]["codigo_rol"]}';
                                                                           map['rol_epp_nombre'] ='${snapshot.data![i]["nombre_rol"]}';
                                                                           map['epp_ficha_entrega_id'] = '1';
                                                                           map['fb_uea_pe_id'] = '${snapshot.data![i]["fb_uea_pe_id"]}';
                                                                           map['fecha_entrega'] = '${snapshot.data![i]["fecha_entrega"]}';
                                                                           map['foto_evidencia'] = '${base64Subida}';


                                                                           //datoEntregaProd.first["fecha_entrega"].substring(0,10)
                                                                           final response2 = await http.post(Uri.parse(url),
                                                                               headers: {

                                                                                 "userLogin": "${user.userLogin}@${user.arroba}",
                                                                                 "userPassword": "${user.password}",
                                                                                 "systemRoot": "${user.enterprise}"
                                                                               },
                                                                               body: map
                                                                           );

                                                                           print("Mapa ---> $map");

                                                                           log('${result}');
                                                                           if (response2.statusCode == 201) {print('Data inserted successfully');} else {print('Insertion failed--- NULL');}
                                                                           data = json.decode(response2.body)['data'];
                                                                           print("Valores ENTREGA------> ${data[0]['epp_entrega_id']}");

                                                                           entrega_id = data[0]['epp_entrega_id'];

                                                                           //                entrega_id = jsonDecode(response2.body[0]);
                                                                           //              print("Valor entrega_id ==> $entrega_id");

                                                                           print(response2.body);
                                                                           return response2;
                                                                         }
                                                                         await postEntregaEpp();

                                                                         print("cantidad ---> ${num}");
                                                                         print("id --->  $idEmpleado   fecha ---_> $fechaEntrega ,   hora ---> $horaEntrega");

                                                                         Future.delayed(Duration(milliseconds: 2000), () async {

                                                                            cantProdEntregar = snapshot.data!.length;


                                                                           for(var j = 0; j<=cantProdEntregar!; j++){
                                                                             //print("Entregas ----> $entregas");

                                                                           Future <http.Response> postEntregaDetalleEpp() async {
                                                                             final user = await authController.getUserFromStorage();


                                                                             var url2 = '${user!.urlApp}/ws/null/entrega_detalle_epp?pr_ws_entrega_detalle';

                                                                             var map2 = Map<String, dynamic>();
                                                                             map2['epp_entrega_id'] = '${entrega_id}';
                                                                             map2['epp_ficha_entrega_id'] = '1';
                                                                             map2['epp_equipo_id'] = '${datoEntregaDetalleProd[j]["epp_equipo_id"]}';
                                                                             map2['epp_producto_id'] = '${datoEntregaDetalleProd[j]["epp_producto_id"]}';
                                                                             map2['epp_motivo_entrega_id'] = '${datoEntregaDetalleProd[j]["epp_motivo_entrega_id"]}';
                                                                             map2['epp_almacen_temp_id'] = '${datoEntregaDetalleProd[j]["epp_almacen_temp_id"]}';
                                                                             map2['fb_puesto_trabajo_id'] = '${datoEntregaDetalleProd[j]["fb_puesto_trabajo_id"]}';
                                                                             map2['estado_vigencia'] = '${datoEntregaDetalleProd[j]["estado_vigencia"]}';
                                                                             map2['flag_uso'] = '${datoEntregaDetalleProd[j]["flag_uso"]}';
                                                                             map2['fecha_entrega'] = '${datoEntregaDetalleProd[j]["fecha_entrega"]}';   //current day when the register is update on server
                                                                             map2['fecha_fin_vigencia'] = '${datoEntregaDetalleProd[j]["fecha_fin_vigencia"]}';  //current day when the register is update on server + tiempo_recambio
                                                                      //       map2['cantidad_dias_vigente'] = '30';                              //Fecha actual - fecha de vigencia
                                                                             map2['flag_pertenencia'] = '${datoEntregaDetalleProd[j]["flag_pertenencia"]}';
                                                                             map2['cantidad'] = '${datoEntregaDetalleProd[j]["cantidad"]}';
                                                                             map2['fb_uea_pe_id'] = '${fb_uea_pe_id}';
                                                                             map2['flag_pertenece_rol'] = '1';
                                                                             map2['tiempo_recambio'] = '${datoEntregaDetalleProd[j]["tiempo_recambio"]}';

                                                                             //datoEntregaProd.first["fecha_entrega"].substring(0,10)
                                                                             final response3 = await http.post(Uri.parse(url2),
                                                                                 headers: {

                                                                                   "userLogin": "${user.userLogin}@${user.arroba}",
                                                                                   "userPassword": "${user.password}",
                                                                                   "systemRoot": "${user.enterprise}"
                                                                                 },
                                                                                 body: map2
                                                                             ).timeout(Duration(seconds: 5));

                                                                             log('${result}');
                                                                             if (response3.statusCode == 201) {
                                                                               print('Data inserted successfully');
                                                                             } else {
                                                                               print(
                                                                                   'Insertion failed--- NULL');
                                                                             }
                                                                             print(
                                                                                 "Valores ENTREGA_DETALLE------> ${jsonDecode(
                                                                                     response3.body)}");
                                                                             print(
                                                                                 "ENTREGA DETALLE VALORES ----> ${response3.body}");
                                                                             print(
                                                                                 "MAPA entrega_detalle ${map2}");
                                                                             print(
                                                                                 "data length ---> ${snapshot.data!.length} ");

                                                                             setState(() { });

                                                                             return response3;


                                                                             }
                                                                             await postEntregaDetalleEpp();

                                                                           }

                                                                         });

                                                                           List<Widget> children;



                                                                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubirReg(sede: "${widget.sede}",)));

                                                                         }
                                                                       },),
                                                                     )
                                                                    ],
                                                                  ),
                                                                ),


                                                              //  SizedBox(height: 5,),

                                                                Row(
                                                                  children: [
                                                                   // Image.asset('assets/images/${snapshot.data![i]['foto']}', width: 50, height: 50,),
                                                                    Container(
                                                                      width:  MediaQuery.of(context).size.width*0.75,
                                                                      padding: EdgeInsets.only(left: 3.0),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                        Row(
                                                                          children: [
                                                                            Text("Nombre: ", style: TextStyle( fontSize: 11, fontWeight: FontWeight.bold)),
                                                                            Text("    ${snapshot.data![i]['nombreCompleto']}",
                                                                              style: TextStyle(fontSize: 11, color: Colors.black),
                                                                              textAlign: TextAlign.left,
                                                                            ),
                                                                          ],
                                                                        ),

                                                                        SizedBox(height: 2,),

                                                                        FittedBox(
                                                                          child: Row(
                                                                            children: [
                                                                              Text("Cargo:",  style: TextStyle( fontSize: 11, fontWeight: FontWeight.bold)),
                                                                              Text("        ${snapshot.data![i]['cargo_nombre']}",
                                                                                  style: TextStyle( fontSize: 11, color: Colors.black),
                                                                                  textAlign: TextAlign.left),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 2,),

                                                                        Container(
                                                                          width:  MediaQuery.of(context).size.width*0.65,
                                                                          child: Row(
                                                                            children: [
                                                                              Text("Empresa:   ", style: TextStyle( fontSize: 11, fontWeight: FontWeight.bold) ),
                                                                              Container(
                                                                                child: Expanded(
                                                                                  child: Text("${snapshot.data![i]['empresa']}",
                                                                                      style: TextStyle( fontSize: 12, color: Colors.black),
                                                                                      textAlign: TextAlign.left),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                          SizedBox(height: 4,),

                                                                          Container(

                                                                            width: MediaQuery.of(context).size.width*0.93,
                                                                            height: 25,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        Text("Equipos Registrados:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                                                                        Text(" ${snapshot.data![i]['sumacantidad']}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                                                                      ],
                                                                                    ),
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



                                                                Container(

                                                                  width: MediaQuery.of(context).size.width*0.90,
                                                                  child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                                child: Container(
                                                                                  width: 130,
                                                                                     height: 24,
                                                                                     child:  ElevatedButton(onPressed: (){}, child: Text("${snapshot.data![i]['estado_subido']}", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
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
                                                                        ),


                                                                            Column(

                                                                              children: [
                                                                                Container(

                                                                                  child: IconButton(onPressed: (){
                                                                                  }, icon:   IconButton(onPressed: ()async{
                                                                                    AwesomeDialog(
                                                                                      context: context,
                                                                                      dialogType: DialogType.warning,
                                                                                      headerAnimationLoop: false,
                                                                                      showCloseIcon: true,
                                                                                      closeIcon: const Icon(Icons.close),
                                                                                      title: 'Eliminar',
                                                                                      desc:
                                                                                      '¿Estás seguro que quieres eliminar el registro de ${snapshot.data![i]['nombreCompleto']} con fecha ${snapshot.data![i]['fecha_entrega']} ${snapshot.data![i]['hora_entrega']}',
                                                                                      btnCancelOnPress: () {},
                                                                                      onDismissCallback: (type) {
                                                                                        debugPrint('Dialog Dismiss from callback $type');
                                                                                      },
                                                                                      btnOkOnPress: () async{


                                                                                        print("ID EMP --> ${snapshot.data![i]['id']}");
                                                                                        print("Fecha -->${snapshot.data![i]['fecha_entrega']}");
                                                                                        print("Hora -->${snapshot.data![i]['hora_entrega']}");


                                                                                        int responseEntregaEpp = await sqlDb.deleteData("DELETE FROM EntregaEpp "
                                                                                            " WHERE EntregaEpp.id_emp = '${snapshot.data![i]['id']}' "
                                                                                            " AND EntregaEpp.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                                            " AND EntregaEpp.hora_entrega = '${snapshot.data![i]['hora_entrega']}' ");
                                                                                        print("se elimino ---> $responseEntregaEpp");




                                                                                        int response = await sqlDb.deleteData("DELETE FROM producto_empleado_mina "
                                                                                            " WHERE producto_empleado_mina.id_empleado = '${snapshot.data![i]['prod_emp_mina_id']}' "
                                                                                            " AND producto_empleado_mina.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                                            " AND producto_empleado_mina.hora_entrega = '${snapshot.data![i]['hora_entrega']}' ");
                                                                                        print(response);



                                                                                        print("ID EMP --> ${snapshot.data![i]['id']}");
                                                                                        print("Fecha -->${snapshot.data![i]['fecha_entrega']}");
                                                                                        print("Hora -->${snapshot.data![i]['hora_entrega']}");



                                                                                        int responseEntregaDetalleEpp = await sqlDb.deleteData("DELETE FROM EntregaDetalleEpp "
                                                                                            " WHERE EntregaDetalleEpp.id_emp  = '${snapshot.data![i]['id']}' "
                                                                                            " AND EntregaDetalleEpp.fecha_entrega = '${snapshot.data![i]['fecha_entrega']}' "
                                                                                            " AND EntregaDetalleEpp.hora_entrega = '${snapshot.data![i]['hora_entrega']}' " );
                                                                                        print(responseEntregaEpp);
                                                                                        print("se elimino ----> $responseEntregaDetalleEpp");




                                                                                             setState(() {});

                                                                                      },
                                                                                    ).show().then((value) =>  setState(() {}));
                                                                                  }, icon: Icon(Icons.delete , size: 22), color: Colors.red,),  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                      ],
                                                                    ),
                                                                  ),
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
                                        ),




                                        //=============Slidable





                                    ],
                                  );
                                });
                        }
                        return Center(child: CircularProgressIndicator(),);
                      }),


                  Visibility(
                    visible: btnEliminarRegistro,

                    child: MaterialButton(onPressed: () async {
                      await sqlDb.mydeleteDatabase();
                    },
                      child: Text("Eliminar registros", style: TextStyle(color: Colors.grey),),
                    ),
                  ),



                  /* Visibility(
                    visible: true,

                    child: MaterialButton(onPressed: () async {
                      await sqlDb.mydeleteDatabase();
                    },
                      child: Text("Eliminar registros", style: TextStyle(color: Colors.grey),),
                    ),
                  ),

                   */

                  Visibility(
                    visible: logoNoExistenRegistro,
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width*0.35,
                           child: Image.asset('assets/gif/no_data_2.png')
                          ),
                          SizedBox(height: 30,),
                          Text("No existen registros", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color:Colors.grey),)
                        ],
                      ),
                    ),
                  )


                ],
              ),
            )
          ],
        ),
      ),








    );
  }
}



