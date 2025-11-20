import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/shared_widgets/layout/app_bar_back.dart';
import 'package:safe2biz/app/global/core/shared_widgets/layout/empty_data.dart';
import 'package:safe2biz/app/global/core/shared_widgets/navigation/nav.dart';
import 'package:safe2biz/app/global/core/shared_widgets/toast/toast.dart';
import 'package:safe2biz/app/global/core/styles/colors.dart';
import 'package:http/http.dart' as http;

import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/MiInformacion/g_medico_empleado_model.dart';
import 'package:safe2biz/app/modules/InformacionSST/presenter/page/InformacionSSTHome.dart';
import 'package:safe2biz/app/modules/epp/external/api/entrega_epp_api.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/agregar_entrega.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/estadistica_entrega.dart';
//import 'package:safe2biz/app/modules/epp/presenter/page/lista_entrega.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/scan_info_prod.dart';
import 'package:safe2biz/app/modules/sedes/features/company/presenter/page/company_body.dart';
import 'package:safe2biz/app/modules/sedes/features/company/presenter/page/company_page.dart';
import 'package:safe2biz/app/ui/module_ui.dart';

import '../../../sedes/presenter/page/sede_page.dart';


class MiInformacion extends StatefulWidget {

  const MiInformacion({Key? key, this.sede, this.fb_empleado_id,  required this.shouldReset}) : super(key: key);
  final String? sede, fb_empleado_id;
  final bool shouldReset;

  @override
  State<MiInformacion> createState() => _MiInformacionState();
}
final apiEntrega = ApiEntregaEpp();

enum AuthorizationStatus { authorized, restricted, unauthorized }
String sede_nom = LocalPreferences.prefs?.getString('current_sede') ?? '';
final _userEditTextController = TextEditingController(text: '');
String selectedButton = 'ExMedico'; // Establecer el valor inicial aquí
List<dynamic>? listNuevosAsistentes;
int? selectedId;
String scanBarcode = 'Desconocido';
TextEditingController codigoProd = TextEditingController();
MedicoEmpleadoModel? selectedItem;
bool saveOK = false;
List<Map<String, dynamic>>? empleadosList;
List<Map<String, dynamic>>? infoEmp = [{
  'nombreCompleto': '', // Iniciar con cadenas vacías
  'numero_documento': '',
  'cargo_nombre': '',
  'area_nombre': '',
  'empresa': '',
  'foto': 'assets/images/userDefault.png', // Ruta por defecto si no hay foto
}];

bool chooseEmp = false;


class _MiInformacionState extends State<MiInformacion> {

  SqlDb sqlDb = SqlDb(); //SQLite Conexion
  AuthorizationStatus authorizationStatus = AuthorizationStatus.authorized;
  late Future<List<dynamic>> futureEpps;
  bool _showImage = true;

  String fotoUrl = '';
  String? fotoEmpleadoUrl;

  @override
  void initState() {
    super.initState();
    asyncMethod();
    getEmpleados();
    getInfoEmp();


    print('el valor de shouldReset es ${widget.shouldReset}');
    if(widget.shouldReset == true){

      setState((){
        chooseEmp = false;
      });
    }else if(widget.shouldReset == false){
      setState((){
        chooseEmp = true;
      });
    }


  }



  bool isAuthorized = true;

  void updateAuthorization(bool authorized) {
    // Si uno de los estados es false, todo el estado será no autorizado.
    if (!authorized) {
      if (isAuthorized != authorized) {
        setState(() {
          isAuthorized = authorized;
        });
      }
    }
  }




  void asyncMethod() async {
    List<Map<String, dynamic>> examenes = await sqlDb.readData(
        'SELECT * FROM examen_medico where examen_medico.fb_empleado_id = ${widget
            .fb_empleado_id}');
    print('Examenes medicos -- $examenes ');

    List<Map<String, dynamic>> enf = await sqlDb.readData(
        'SELECT * FROM enfermedades_ocupacionales where enfermedades_ocupacionales.fb_empleado_id = "${widget
            .fb_empleado_id}"');
    print('enfermedades_ocupacionales -- $enf ');

    List<Map<String, dynamic>> cap = await sqlDb.readData(
        'SELECT * FROM capacitacion');
    print('capacitacion -- $cap ');


    List<Map<String, dynamic>> emp = await sqlDb.readData(
        'SELECT * FROM empleadoMina');
    print('empleados Mina -- $emp ');
  }

  void getInfoEmp() async {
    List<Map<String, dynamic>> result = await sqlDb.readData(
        "SELECT nombreCompleto, numero_documento, cargo_nombre, area_nombre, empresa, fb_empresa_especializada, foto FROM empleadoMina WHERE empleadoMina.fb_empleado_id = '${widget
            .fb_empleado_id}' "
    );

    if (result.isNotEmpty) {
      // Obtener el valor de la foto
      print('result -- $result');
      String foto = result[0]['foto'];
      print('foto URL--- $foto');



      // Concatenar la URL base con el valor de la foto
      fotoUrl =
      'https://app.safe2biz.com:8080/safe2biz_ASP_DEMO/PATH_UPLOAD/$foto';

      // Actualizar el estado con la información del empleado y la URL de la foto
      setState(() {
        infoEmp = result;
        fotoEmpleadoUrl = fotoUrl;

        print('foto empleado URL --> $fotoEmpleadoUrl');
      });
    } else {

    }
  }



  Future<List<Map<String, dynamic>>> getEmpleados() async {
    final db = await sqlDb; // Asegúrate de que este objeto db ya está inicializado y apunta a tu base de datos SQLite
    empleadosList = await sqlDb.readData(
        'SELECT * FROM empleadoMina where empleadoMina.fb_uea_pe_id = "${widget
            .sede}" ');
    return empleadosList!;
  }

  Future<List<Map<String, dynamic>>> getExamenesMedicosPorEmpleado(
      int empleadoId) async {
    final db = await sqlDb; // Asegúrate de que este objeto db ya está inicializado y apunta a tu base de datos SQLite
    return await sqlDb.readData(
        'SELECT * FROM examen_medico where examen_medico.fb_empleado_id = "${widget
            .fb_empleado_id}" ');
  }

  Future<List<Map<String, dynamic>>> getEnfermedadesPorEmpleado(
      int empleadoId) async {
    final db = await sqlDb; // Asegúrate de que este objeto db ya está inicializado y apunta a tu base de datos SQLite
    return await sqlDb.readData(
        'SELECT * FROM enfermedades_ocupacionales where enfermedades_ocupacionales.fb_empleado_id = "${widget
            .fb_empleado_id}" ');
  }

  Future<List<Map<String, dynamic>>> getCapacitacionesPorEmpleado(
      int empleadoId) async {
    final db = await sqlDb; // Asegúrate de que este objeto db ya está inicializado y apunta a tu base de datos SQLite
    return await sqlDb.readData('SELECT * FROM capacitacion where capacitacion.fb_empleado_id = "${widget
            .fb_empleado_id}" ');
  }


  @override
  Widget build(BuildContext context) {





    print('fb emp id --- ${widget.fb_empleado_id} ');
    print('sede --- ${widget.sede}');

    double vw = MediaQuery
        .of(context)
        .size
        .width;
    double vh = MediaQuery
        .of(context)
        .size
        .height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(

          appBar: AppBar(
            title: Text('${sede_nom}',
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),),
            backgroundColor: S2BColors.primaryColor,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Nav.go(context, CompanyPage());
                },
                icon: Icon(Icons.arrow_back_sharp, color: Colors.white)
            ),

            actions: [
              Visibility(
                visible: false,
                child: IconButton(
                  icon: Icon(Icons.person_search),
                  onPressed: () {

                  },
                ),
              ),
            ],
          ),

          //Mi información
          body: SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(height: 5,),

                SearchBarWidget(),

                Container(
                  color: Color(0xffEBEFFB),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Column(
                      children: [
                        //Card Info User
                        Visibility(
                          visible: chooseEmp,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0),
                            child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15.0)),
                              ),

                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.98,

                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0)),

                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [

                                        Row(
                                          children: [
                                            // Imagen del trabajador
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(10.0),

                                                  color: Colors.black87,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: '$fotoEmpleadoUrl',
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget: (context, url,
                                                      error) =>
                                                      Image.asset(
                                                        'assets/images/userDefault.png',
                                                        height: 70,
                                                        width: 60,
                                                        fit: BoxFit.cover,
                                                      ),
                                                  height: 70,
                                                  width: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),

                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Card(

                                                    elevation: 0,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        FittedBox(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  "Nombre:    ",
                                                                  style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight
                                                                          .bold)),
                                                              Text(
                                                                infoEmp!
                                                                    .isNotEmpty
                                                                    ? infoEmp![0]['nombreCompleto']
                                                                    : 'Cargando...',
                                                                style: TextStyle(
                                                                    fontSize: 11,
                                                                    height: 1.4,
                                                                    color: Color(
                                                                        0XFF505154)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(height: 11,
                                                            color: Colors.grey,
                                                            thickness: 0.3),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "DNI:           ",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight
                                                                        .bold)),
                                                            Text(infoEmp!
                                                                .isNotEmpty
                                                                ? infoEmp![0]['numero_documento']
                                                                : 'Cargando...',
                                                                style: TextStyle(
                                                                    fontSize: 11,
                                                                    height: 1.4,
                                                                    color: Color(
                                                                        0XFF505154))),
                                                          ],
                                                        ),
                                                        Divider(height: 11,
                                                            color: Colors.grey,
                                                            thickness: 0.3),
                                                        Row(
                                                          children: [
                                                            Text("Cargo:    ",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight
                                                                        .bold)),
                                                            Container(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                  left: 8.0),
                                                              width: MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width * 0.5,
                                                              child: Text(
                                                                infoEmp!
                                                                    .isNotEmpty
                                                                    ? infoEmp![0]['cargo_nombre']
                                                                    : 'Cargando...',
                                                                style: TextStyle(
                                                                    fontSize: 10,
                                                                    height: 1.3,
                                                                    color: Color(
                                                                        0XFF505154)),
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(height: 11,
                                                            color: Colors.grey,
                                                            thickness: 0.3),
                                                        Row(
                                                          children: [
                                                            Text("Empresa:",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight
                                                                        .bold)),
                                                            Container(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                  left: 8.0),
                                                              width: MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width * 0.5,
                                                              child: Text(
                                                                  'MARTINEZ CONTRATISTAS E INGENIERIA S.A.',
                                                                style: TextStyle(
                                                                    fontSize: 11,
                                                                    height: 1.3,
                                                                    color: Color(
                                                                        0XFF505154)),
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),


                        Column(

                          children: [
                            Visibility(
                                visible: chooseEmp,
                                child: _resumenEmpleado(context,
                                    int.parse('${widget.fb_empleado_id}'))),

                            Visibility(
                              visible: !chooseEmp,
                              child: Container(
                                height: vh * 0.65,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_search,
                                      size: 140, // Tamaño grande para el icono
                                      color: Colors
                                          .grey, // Color del tema principal
                                    ),
                                    SizedBox(height: 4),
                                    // Espacio entre el icono y el texto
                                    Text(
                                      "Buscar empleado",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        "Ingrese el DNI del empleado para iniciar la búsqueda",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            height: 1.4
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),


                            SizedBox(height: vh * 0.03),
                            Visibility(
                              visible: !isAuthorized,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            'Nota:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: S2BColors.primaryColor),
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              'Indicar al personal que se comunique con su empresa',
                                              style: TextStyle(
                                                  color: Color(0XFF545150),
                                                  fontSize: 16,
                                                  height: 1.3,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }


  Widget _resumenEmpleado(BuildContext context, int empleadoId) {
    double vw = MediaQuery
        .of(context)
        .size
        .width;
    double vh = MediaQuery
        .of(context)
        .size
        .height;
    return Column(
      children: [
        SizedBox(height: 15,),
        Visibility(
          visible: chooseEmp,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(
                  20.0)), // Asegúrate de usar BorderRadius.vertical
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 0.0),
                  height: vh * 0.1,
                  decoration: BoxDecoration(
                    color: isAuthorized ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0)), // Aplica redondeo aquí
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(isAuthorized ? Icons.check_circle : Icons.cancel,
                            size: 26, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          isAuthorized ? "Autorizado" : "No Autorizado",
                          style: TextStyle(fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15,),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildStatusRowExamenMedico(
                      context, empleadoId, updateAuthorization),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: buildDocumentacionCard(context),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildStatusRowCapacitaciones(
                      context, empleadoId, updateAuthorization),
                ),


                SizedBox(height: 15,) // Asegúrate de tener esta separación
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context, String title, IconData iconData,
      List<String> details, List<IconData> detailIcons, List<Icon> statusIcons, Icon trailingIcon) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),  // Añadido un margen horizontal para mejor visualización
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),  // Asegura que todos los Card tienen bordes redondeados
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(iconData, color: Color(0xFF09357E)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(title, style: TextStyle(color: Color(0XFF545150), fontSize: 16, fontWeight: FontWeight.w500)),
                ),
                Spacer(),
                trailingIcon,
              ],
            ),
        //    Divider(),
            if (details.isEmpty || details.every((detail) => detail.trim().isEmpty))  // Para cuando no hay detalles
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),  // Añadido un margen horizontal para mejor visualización
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),  // Asegura que todos los Card tienen bordes redondeados
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text("No se registran enfermedades ocupacionales", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                  ),
                ),
              )

            else  // Para cuando hay detalles
              Visibility(
                visible: false,
                child: Column(
                  children: details.asMap().entries.map((entry) => _buildDetailRow(
                      context,
                      entry.value,
                      detailIcons.length > entry.key ? detailIcons[entry.key] : Icons.arrow_forward_ios,
                      statusIcons.length > entry.key ? statusIcons[entry.key] : Icon(Icons.cancel, color: Colors.red)
                  )).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String detail, IconData icon, Icon statusIcon)  {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          title: Row(
            children: [
              Icon(icon, size: 12, color: Colors.teal),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  detail,
                  style: TextStyle(
                      color: Color(0XFF545150),
                      fontSize: 12,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ],
          ),
          trailing: Container(
            width: 40,
            alignment: Alignment.center,
            child: statusIcon,  // Ahora pasamos el widget Icon completo
          ),
        ),
        Divider(height: 2,)
      ],
    );
  }

  Widget _buildStatusRowExamenMedico(BuildContext context, int empleadoId, Function(bool) updateAuthorization) {
    return FutureBuilder(
      future: getExamenesMedicosPorEmpleado(empleadoId),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Icon> statusIcons = snapshot.data!.map<Icon>((examen) {
              switch (examen['flag_aptitud']) {
                case '1':
                  return Icon(Icons.check_circle, color: Colors.green);
                case '2':
                  return Icon(Icons.remove_circle, color: Colors.orange);
                case '3':
                  return Icon(Icons.cancel, color: Colors.red);
                default:
                  return Icon(Icons.help_outline, color: Colors.grey);
              }
            }).toList();
            List<String> details = snapshot.data!.map<String>((examen) => examen['examen_medico']).toList();
            List<IconData> detailIcons = List.filled(details.length, Icons.arrow_forward_ios_outlined);

            bool allPassed = snapshot.data!.every((examen) => examen['flag_aptitud'] == '1');
            WidgetsBinding.instance.addPostFrameCallback((_) => updateAuthorization(allPassed));

            return _buildStatusRow(
                context,
                'Exámenes Médicos',
                Icons.medication_sharp,
                details,
                detailIcons,
                statusIcons,
                _determineTrailingIcon(statusIcons)
            );

          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              updateAuthorization(false);
            });
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded( // Usar Expanded para manejar el espacio adecuadamente
                      child: Row(
                        children: [
                          Icon(Icons.medication_sharp, color: S2BColors.primaryColor, size: 24),
                          SizedBox(width: 10), // Ajusta este valor según sea necesario
                          Text(
                            "Exámenes Médicos",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis, // Asegúrate de que el texto no desborde
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.circle, color: Colors.red, size: 24),
                  ],
                ),
              ),
            );


          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }


  Widget _buildStatusRowCapacitaciones(BuildContext context, int empleadoId, Function(bool) updateAuthorization) {
    return FutureBuilder(
      future: getCapacitacionesPorEmpleado(empleadoId),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<String> details = snapshot.data!.map<String>((capacitacion) => capacitacion['capacitacion']).toList();
            List<Icon> statusIcons = snapshot.data!.map<Icon>((capacitacion) {
              return Icon(
                capacitacion['flag_aptitud'] == '1' ? Icons.check_circle : Icons.cancel,
                color: capacitacion['flag_aptitud'] == '1' ? Colors.green : Colors.red,
              );
            }).toList();

            // Determinar si todas las capacitaciones son 'aptas'
            bool allPassed = snapshot.data!.every((capacitacion) => capacitacion['flag_aptitud'] == '1');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              updateAuthorization(allPassed);
            });


            return _buildStatusRow(
                context,
                'Capacitaciones',
                Icons.school,
                details,
                List.filled(details.length, Icons.arrow_forward_ios_outlined),
                statusIcons,
                _determineTrailingIcon(statusIcons)
            );

          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              updateAuthorization(false);
            });
            // No hay capacitaciones, se considera como pasado
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded( // Usar Expanded para manejar el espacio adecuadamente
                      child: Row(
                        children: [
                          Icon(Icons.school, color: S2BColors.primaryColor, size: 24),
                          SizedBox(width: 10), // Ajusta este valor según sea necesario
                          Text(
                            "Capacitaciones",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis, // Asegúrate de que el texto no desborde
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.circle, color: Colors.red, size: 24),
                  ],
                ),
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildDocumentacionCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea los elementos a los extremos
          children: [
            Row(
              children: [
                Icon(Icons.file_copy, color: Color(0xFF09357E), size: 24), // Ícono de documento
                SizedBox(width: 10), // Espacio entre ícono y texto
                Text(
                  "Documentación",
                  style: TextStyle(
                      color: Color(0XFF545150),
                      fontSize: 16, // Aumentado para mejor visualización
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            Icon(Icons.circle, color: Colors.green, size: 24), // Ícono verde más específico
          ],
        ),
      ),
    );
  }



  Icon _determineTrailingIcon(List<Icon> statusIcons) {
    bool containsGreen = statusIcons.any((icon) => icon.icon == Icons.check_circle);
    bool containsOrange = statusIcons.any((icon) => icon.icon == Icons.remove_circle);
    bool containsRed = statusIcons.any((icon) => icon.icon == Icons.cancel);

    if (containsRed) {
      // Si hay cualquier rojo, el ícono principal será rojo
      return Icon(Icons.circle, color: Colors.red);
    } else if (containsOrange && containsGreen) {
      // Si hay naranjas y verdes, pero no rojos
      return Icon(Icons.circle, color: Colors.orange);
    } else {
      // Todos son verdes
      return Icon(Icons.circle, color: Colors.green);
    }
  }





  Future<ImageProvider> loadImage() async {
    try {
      final response = await http.get(Uri.parse('https://app.safe2biz.com:8080/safe2biz_ASP_DEMO/PATH_UPLOAD/8950_21_certificado_medico.png'));
      if (response.statusCode == 200) {
        return NetworkImage('https://app.safe2biz.com:8080/safe2biz_ASP_DEMO/PATH_UPLOAD/8950_21_certificado_medico.png');
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      throw Exception('Failed to load image');
    }
  }
}

class SearchBarWidget extends StatefulWidget {
  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredEmployees = [];
  bool _isFiltering = false; // Variable para controlar si se está filtrando o no

  @override
  void initState() {
    super.initState();
    // Inicializar la lista de empleados al cargar la pantalla
  }
  void handleScan(BuildContext context, String barcode) {
    setState(() {
      scanBarcode = barcode;
      if (barcode != "-1") {
        sendProdInfo(context, barcode);
      } else {
        scanBarcode = "Escaneo cancelado";
      }
    });
  }


  void sendProdInfo(BuildContext context, String codigo) async {
    //sendInfoProduct

    List<Map> datoEscaneadoProd =
    await sqlDb.readData("SELECT * FROM empleadoMina "
        " WHERE empleadoMina.numero_documento = '$codigo' ");
    print(datoEscaneadoProd);

    if (datoEscaneadoProd.isNotEmpty) {
      Nav.go(context, MiInformacion(
        fb_empleado_id: datoEscaneadoProd.first["fb_empleado_id"].toString(),
        sede: datoEscaneadoProd.first["fb_uea_pe_id"].toString(),
      shouldReset: false,))
          .then((_) => setState(() {
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
            height: 120,
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
                            'No encontramos el DNI "${codigo}"\nen nuestros registros.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        width: MediaQuery.of(context).size.width * 0.98,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 2),
            Icon(Icons.search, color: Colors.grey), // Ícono de lupa al lado izquierdo
            SizedBox(width: 10), // Espacio entre la lupa y el campo de texto
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Ingresar DNI ...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                keyboardType: TextInputType.number, // Asegúrate de que el tipo de teclado sea numérico si buscas DNI
                textInputAction: TextInputAction.search, // Configura la acción del teclado a "search"
                onSubmitted: (value) {
                  // Se llama cuando se presiona el botón de búsqueda en el teclado
                  searchEmployeeByDocument(value.trim());
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Colors.grey), // Botón enviar
              onPressed: () => searchEmployeeByDocument(_searchController.text.trim()),
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.barcode, color: Colors.grey, size: 20), // Ícono de código de barras
              onPressed: () {
            //    scanBarcodeNormal();
              },
            ),
          ],
        ),
      ),
    );
  }


  void searchEmployeeByDocument(String documento) async {
    if (documento.isEmpty) return;

    List<Map> empleado = await sqlDb.readData(
        "SELECT * FROM empleadoMina WHERE empleadoMina.numero_documento = '$documento'");
    if (empleado.isNotEmpty) {
      // query = query;



      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MiInformacion(
          fb_empleado_id: empleado.first["fb_empleado_id"].toString(),
          sede: empleado.first["fb_uea_pe_id"].toString(),
          shouldReset: false,
        )),
            (Route<dynamic> route) => false, // No deja rutas anteriores en la pila
      );
    } else {
      // Mostrar diálogo si no se encuentra el empleado
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            height: 120,
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
                          'No encontramos el DNI "${documento}"\nen nuestros registros.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
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

  void searchEmployeeByDocument(String documento) async {
    if (documento.isEmpty) return;

    List<Map> empleado = await sqlDb.readData(
        "SELECT * FROM empleadoMina WHERE numero_documento = '$documento'");
    if (empleado.isNotEmpty) {
      // Si encuentra al empleado, navega a la pantalla de información del empleado
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MiInformacion(
          fb_empleado_id: empleado.first["fb_empleado_id"].toString(),
          sede: empleado.first["fb_uea_pe_id"].toString(),
          shouldReset: false,
        )),
            (Route<dynamic> route) => false, // No deja rutas anteriores en la pila
      );



    } else {
      // Mostrar diálogo si no se encuentra el empleado
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Empleado no encontrado"),
          content: Text("No se pudo encontrar un empleado con DNI: $documento"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cerrar"),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildEmployeeCard(Map<String, dynamic> employee) {

    return Card(
      child: ListTile(
        onTap: () async {
          // query = query;
          int idEmp = employee['fb_empleado_id'];
          int fb_uea_pe_id = employee['fb_uea_pe_id'];
          print("DATOS USUARIO SELECCIONADO ----> $idEmp, $fb_uea_pe_id");
          chooseEmp = true;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MiInformacion(
              sede: fb_uea_pe_id.toString(),
              fb_empleado_id: idEmp.toString(),
                shouldReset: false,
            )),
                (Route<dynamic> route) => false, // No deja rutas anteriores en la pila
          );
        },

        title: Text(employee['nombreCompleto'],style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(employee['numero_documento'], style: TextStyle(fontSize: 12)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Text(employee['cargo_codigo'], style: TextStyle(fontSize: 12),),
            ),
          ],
        ),
      ),
    );
  }

  void _filterEmployees(String query) {
    setState(() {
      _filteredEmployees = empleadosList!.where((employee) {
        List<String> keywords = query.toLowerCase().split(' ');
        List<String> employeeNameWords =
        employee['numero_documento'].toLowerCase().split(' ');


        if (employeeNameWords.length >= 7) {
          // Obtener las primeras tres palabras del nombre completo del empleado
          List<String> employeeFirstThreeWords =
          employeeNameWords.sublist(0, 3);

          // Verificar si al menos una de las tres primeras palabras del nombre y apellido del empleado
          // coincide con al menos una de las tres primeras palabras de la consulta del usuario
          return employeeFirstThreeWords.any((word) =>
              keywords.any((keyword) => word.startsWith(keyword)));
        } else {
          // Si el nombre completo del empleado tiene menos de tres palabras,
          // no lo incluimos en la lista filtrada
          return false;
        }
      }).toList();
    });
  }




}
  }
