import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/core/shared_widgets/layout/app_bar_back.dart';
import 'package:safe2biz/app/global/core/shared_widgets/layout/empty_data.dart';
import 'package:safe2biz/app/global/core/shared_widgets/navigation/nav.dart';
import 'package:safe2biz/app/global/core/shared_widgets/toast/toast.dart';
import 'package:safe2biz/app/global/core/styles/colors.dart';
import 'package:http/http.dart' as http;

import 'package:safe2biz/app/modules/InformacionSST/domain/entitities/MiInformacion/g_medico_empleado_model.dart';
import 'package:safe2biz/app/modules/InformacionSST/presenter/page/InformacionSSTHome.dart';
import 'package:safe2biz/app/modules/auth/features/login/data/data.dart';
import 'package:safe2biz/app/modules/epp/external/api/entrega_epp_api.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/agregar_entrega.dart';




class DatosTrabajador extends StatefulWidget {

  const DatosTrabajador({Key? key, this.sede, this.fb_empleado_id}) : super(key: key);
  final String? sede, fb_empleado_id;
  @override
  State<DatosTrabajador> createState() => _DatosTrabajadorState();
}
String sede_nom = LocalPreferences.prefs?.getString('current_sede') ?? '';
final _userEditTextController = TextEditingController(text: '');
String selectedButton = 'ExMedico'; // Establecer el valor inicial aquí
List<dynamic>? listNuevosAsistentes;
int? selectedId;
String scanBarcode = 'Desconocido';
TextEditingController codigoProd = TextEditingController();
MedicoEmpleadoModel? selectedItem;
bool saveOK = false;


final localSqliteInstance = LocalSqlite();
final authController = AuthController(sqlite: localSqliteInstance);

class _DatosTrabajadorState extends State<DatosTrabajador> {


  SqlDb sqlDb = SqlDb(); //SQLite Conexion

  List<Map<String, dynamic>> infoEmp = [];
  late Future<List<dynamic>> futureEpps;
  bool _showImage = true;

  String fotoUrl = '';
  String? fotoEmpleadoUrl;
  @override
  void initState() {
    super.initState();
    inicializarSeleccion();
    futureEpps = readEPPEmp();
    getInfoEmp();

  }





  void getInfoEmp() async {

    List<Map<String, dynamic>> result = await sqlDb.readData(
        "SELECT nombreCompleto, numero_documento, cargo_nombre, area_nombre, foto FROM empleadoMina WHERE empleadoMina.fb_empleado_id = '${widget.fb_empleado_id}' "
    );

    if (result.isNotEmpty) {
      // Obtener el valor de la foto
      print('result -- $result');
      String foto = result[0]['foto'];
      print('foto URL--- $foto');

      // Concatenar la URL base con el valor de la foto
      fotoUrl = 'https://app.safe2biz.com:8080/safe2biz_ASP_DEMO/PATH_UPLOAD/$foto';

      // Actualizar el estado con la información del empleado y la URL de la foto
      setState(() {
        infoEmp = result;
        fotoEmpleadoUrl = fotoUrl;

        print('foto empleado URL --> $fotoEmpleadoUrl');
      });

    }
  }

  void inicializarSeleccion() async {
    var items = await readGrupoMedEmp(); // Asumiendo que esto devuelve una lista
    if (items.isNotEmpty) {
      setState(() {
        selectedItem = items.first;
      });
    }
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


  @override
  Widget build(BuildContext context) {

    print('fb emp id --- ${widget.fb_empleado_id} ');
    print('sede --- ${widget.sede}');

    double vw = MediaQuery.of(context).size.width;
    double vh = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
          appBar:  AppBar(
            title: Text('${sede_nom}', style: TextStyle(fontSize: 16, color: Colors.white),),
            backgroundColor: S2BColors.primaryColor,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_sharp, color: Colors.white)
            ),


            actions: [
              Visibility(
                visible: false,
                child: IconButton(
                  icon: Icon(Icons.person_search),
                  onPressed: (){
                    showSearch(
                      context: context,
                      delegate:
                      MySearchDelegateSST(sede: widget.sede,   onScanResult: (barcode) => handleScan(context, barcode), ),
                    );
                  },


                ),
              ),
            ],
          ),


          //Mi información
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom:0.0),
                  color: Color(0xff09357E),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, bottom: 9, top: 5),
                            child: Container(child: Text("Mi Información", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),



                Container(
                  color: Color(0XFFDEE4ED),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:  8.0),
                    child: Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            elevation: 5,
                            child: Container(
                              width:  MediaQuery.of(context).size.width*0.98,

                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0) ),

                              child:  Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [

                                      Row(
                                        children: [
                                          // Imagen del trabajador
                                          Padding(
                                            padding: const EdgeInsets.only(right: 12.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 0.5),
                                                color: Colors.black87,
                                              ),
                                              child: FutureBuilder(
                                                future: loadImage(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return CircularProgressIndicator(); // Muestra un indicador de carga mientras se carga la imagen
                                                  } else if (snapshot.hasError) {
                                                    return Image.asset(
                                                      'assets/images/userDefault.png',
                                                      height: 70, // Reducido de 90 a 70
                                                      width: 60, // Reducido de 80 a 60
                                                      fit: BoxFit.cover, // Ajusta la imagen para cubrir el contenedor
                                                    );
                                                  } else {
                                                    return Image.network(
                                                      '$fotoEmpleadoUrl',
                                                      height: 70, // Reducido de 90 a 70
                                                      width: 60, // Reducido de 80 a 60
                                                      fit: BoxFit.cover, // Ajusta la imagen para cubrir el contenedor
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
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
                                                      FittedBox(
                                                        child: Row(
                                                          children: [
                                                            Text("Nombre:   ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                            Text(
                                                              infoEmp.isNotEmpty ? infoEmp[0]['nombreCompleto'] : 'Cargando...',
                                                              style: TextStyle(fontSize: 11, height: 1.4, color: Color(0XFF505154)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Divider(height: 11, color: Colors.grey, thickness: 0.3),
                                                      Row(
                                                        children: [
                                                          Text("DNI:         ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                          Text(infoEmp.isNotEmpty ? infoEmp[0]['numero_documento'] : 'Cargando...',
                                                              style: TextStyle(fontSize: 11, height: 1.4, color: Color(0XFF505154))),
                                                        ],
                                                      ),
                                                      Divider(height: 11, color: Colors.grey, thickness: 0.3),
                                                      Row(
                                                        children: [
                                                          Text("Cargo:  ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                          Container(
                                                            padding: const EdgeInsets.only(left: 8.0),
                                                            width: MediaQuery.of(context).size.width * 0.5,
                                                            child: Text(
                                                              infoEmp.isNotEmpty ? infoEmp[0]['cargo_nombre'] : 'Cargando...',
                                                              style: TextStyle(fontSize: 10, height: 1.3, color: Color(0XFF505154)),
                                                              overflow: TextOverflow.ellipsis,
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



                        Column(
                          children: [
                            Container(
                              width: vw*1,
                              height: 35,

                              padding: EdgeInsets.only(top: 4.0, left: 12.0, right: 12.0),
                              child: Container(

                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [


                                 //   _buildButton('Resumen', 'Resumen', icon: Icons.file_copy), // Cambia el color y agrega un icono al botón 'Resumen'
                                    _buildButton('ExMedico', 'Ex. Médico'),
                                    _buildButton('Accidentes', 'Accidentes'),
                                    _buildButton('Equipos EPP', 'Equipos EPP'),
                                    _buildButton('Capacitacion', 'Capacitación'),
                                    _buildButton('Enf. Ocupacionales', 'Enf. Ocupacionales'),
                                    _buildButton('Planes de Accion', 'Planes de Acción'),

                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 14,),

                            if (selectedButton == 'Resumen') _resumenEmpleado(context),


                            if (selectedButton == 'ExMedico') _examenMedicoContent(),

                            if (selectedButton == 'Accidentes') _AccidentesContent(),

                            if(selectedButton == 'Equipos EPP') _EPPContent(),

                            if(selectedButton == 'Capacitacion') _CapacitacionContent(),

                            if(selectedButton == 'Enf. Ocupacionales') _EnfOcupacionalesContent(),

                            if(selectedButton == 'Planes de Accion') _PlanesAccionContent()

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



  Widget _buildButton(String buttonKey, String buttonText, {IconData? icon}) {
    Color buttonColor = buttonKey == 'Resumen' && selectedButton != 'Resumen' ? Colors.orange : Colors.teal; // Color naranja para el botón 'Resumen' solo si no está seleccionado
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedButton = buttonKey;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null) Icon(icon, size: 14), // Agrega el icono si se proporciona
            SizedBox(width: 5,),
            Text(
              buttonText,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis, // Agregado para manejar el texto largo
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedButton == buttonKey ? S2BColors.primaryColor : buttonColor, // Cambia el color solo si el botón está seleccionado
          // En lugar de fixedSize, considera usar padding para que el botón se adapte al texto.
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          // shape: StadiumBorder(),
        ),
      ),
    );
  }

  Widget _resumenEmpleado(BuildContext context) {
    double vw = MediaQuery.of(context).size.width;
    double vh = MediaQuery.of(context).size.height;

    // Asegurarse de que el padding del Neumorphic se establezca en 0 para el ancho completo
    return Column(
      children: [

        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0)),
          ),
          padding: EdgeInsets.symmetric( horizontal: 8.0), // Eliminar el padding horizontal aquí
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(children: [
                  Icon(Icons.person, size: 22,),
                  SizedBox(width: 10,),
                  Text('Resumen del Trabajador', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Color(0xFF545150)),)
                ],),
              ),
              SizedBox(height: 5,),
              _buildStatusRow(
                  context,
                  'Certificado Médico',
                  Icons.medication_sharp,
                  [
                    "Certificado médico Coimolache",
                    "Certificado médico Anual",
                    "Certificado médico Semestral",
                  ],
                  [
                    Icons.arrow_forward_ios_outlined,
                    Icons.arrow_forward_ios_outlined,
                    Icons.arrow_forward_ios_outlined
                  ],
                  [
                    Icon(Icons.cancel, color: Colors.red),
                    Icon(Icons.cancel, color: Colors.red,),
                    Icon(Icons.check_circle_rounded, color: Colors.green,)    //remove_circle is orange
                  ],
                  Icon(Icons.circle, color: Colors.red,)
              ),

              _buildStatusRow(
                  context,
                  'Enfermedades Ocupacionales',
                  Icons.emergency,
                  ["Ciertas enfermedades infecciosas y parasitarias",
                    "Enfermedades del ojo y sus anexos",
                    "Enfermedades del sistema respiratorio"],  // Lista con un espacio para indicar que no hay detalles
                  [Icons.arrow_forward_ios_outlined],  // Los íconos son irrelevantes en este caso


                  [ Icon(Icons.cancel, color: Colors.red,),
                    Icon(Icons.cancel, color: Colors.red,),
                    Icon(Icons.cancel, color: Colors.red,),],  // Ícono de estado igualmente irrelevante aquí
                  Icon(Icons.circle, color: Colors.red)  // Ícono estático para 'trailing'
              ),
              _buildStatusRow(context, 'Capacitación', Icons.school, [
                "CAP001 - Auditoria de salud en el trabajo ",
                "CAP002 - Curso de primeros auxilios ",
                "CAP003 - Seguridad industrial ",
              ],  [
                Icons.arrow_forward_ios_outlined,
                Icons.arrow_forward_ios_outlined,
                Icons.arrow_forward_ios_outlined
              ], [
                Icon(Icons.check_circle_rounded, color: Colors.green,),
                Icon(Icons.check_circle_rounded, color: Colors.green,),
                Icon(Icons.check_circle_rounded, color: Colors.green,),
              ],
                  Icon(Icons.circle, color: Colors.green,)  // Ejemplo de ícono estático para 'trailing'
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context, String title, IconData iconData,
      List<String> details, List<IconData> detailIcons, List<Icon> statusIcons, Icon trailingIcon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Color(0XFFE3E8F0)),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            leading: Icon(iconData, color: Color(0xFF09357E)),
            title: Text(
              title,
              style: TextStyle(color: Color(0XFF545150), fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: trailingIcon,
            ),
            children: details.isEmpty || details.every((detail) => detail.trim().isEmpty) ?
            [ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text(
                "No se registran enfermedades",
                style: TextStyle(
                    color: Color(0XFF545150),
                    fontSize: 12,
                    fontWeight: FontWeight.w500
                ),
              ),
            )] :
            List.generate(details.length, (index) => _buildDetailRow(
                context,
                details[index],
                index < detailIcons.length ? detailIcons[index] : Icons.arrow_forward_ios, // Ícono por defecto si fuera de rango
                index < statusIcons.length ? statusIcons[index] : Icon(Icons.help_outline, color: Colors.grey)  // Ícono de estado por defecto si fuera de rango
            )),
          ),
        ),
      ),
    );
  }
//    digita un dni, aprece x defecto en blanco, escaneo o busqueda,
  //  datos del trabajador es otro modulo (examenes medico, cpaacitacion, )  similar... exmaen
  Widget _buildDetailRow(BuildContext context, String detail, IconData icon, Icon statusIcon) {
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



  Widget _examenMedicoContent() {
    double vw = MediaQuery.of(context).size.width;
    double vh = MediaQuery.of(context).size.height;
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0)),

      ),
      child: Padding(
        padding: const EdgeInsets.only(top:0.0),
        child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
/*
                  width: vw*1,
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),

                  child: DropdownSearch<MedicoEmpleadoModel>(

                    dropdownSearchTextStyle: TextStyle(fontSize: 12),  // Tamaño de texto para el campo de búsqueda

                    popupProps: PopupProps.menu(
                      showSelectedItems: true,
                      textStyle: TextStyle(fontSize: 12),  // Tamaño de texto para los elementos del menú

                      itemBuilder: (context, item, isSelected) {

                        return ListTile(
                          title: Text(
                            item.nombre,
                            style: TextStyle(fontSize: 12),  // Este es el tamaño de texto para cada elemento del menú
                          ),
                        );
                      },
                    ),

                    itemAsString: (MedicoEmpleadoModel? u) => u?.nombre ?? '',
                    compareFn: (item, selectedItem) => item.id == selectedItem.id,
                    dropdownSearchDecoration: InputDecoration(
                        labelText: "Exámen Médico",
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(Icons.file_copy_rounded, size: 18)
                    ),

                    asyncItems: (String filter) => readGrupoMedEmp(),
                    onChanged: (MedicoEmpleadoModel? data) {
                      if (data != null) {
                        setState(() {
                          selectedItem = data;
                        });
                        print("ID seleccionado: ${selectedItem?.id}");
                      }
                    },
                    selectedItem: selectedItem,
                  ),
                  */
                ),
              ),

              FutureBuilder<List<MedicoEmpleadoModel>>(
                future: readGrupoMedEmp(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: vh*0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Center(
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2), // Fondo semi-transparente
                                borderRadius: BorderRadius.circular(10), // Bordes redondeados
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff09357E)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ); // Muestra un indicador de carga mientras espera
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}"); // Muestra un mensaje de error si ocurre uno
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Aquí es donde construyes tu Card utilizando los datos obtenidos
                    MedicoEmpleadoModel datos = snapshot.data!.first; // Usando el primer elemento como ejemplo

                    String medicoResponsable = datos.medico_responsable.isNotEmpty ? datos.medico_responsable : "No especifica";
                    String centroMedico = datos.centro_medico.isNotEmpty ? datos.centro_medico : "No especifica";
                    String observaciones = datos.observacion_medica.isNotEmpty ? datos.observacion_medica : "No especifica";
                    String aptitudNombre = datos.aptitud_nombre.isNotEmpty ? datos.aptitud_nombre : "No especifica";
                    String tipoEvaluacion = datos.tipo_evaluacion_nombre.isNotEmpty ? datos.tipo_evaluacion_nombre : "No especifica";

                    return  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        elevation: 0,
                        child: Container(

                          width:  MediaQuery.of(context).size.width*0.96,

                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0) ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Column(
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: vw * 0.55, // Establece el ancho al 30% de la pantalla
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            child: Wrap(
                                              direction: Axis.horizontal, // Fluye en dirección horizontal
                                              children: [
                                                Text(
                                                  selectedItem?.nombre ?? "Cargando...",
                                                  style: TextStyle(
                                                    color: Color(0XFF505154),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton<MedicoEmpleadoModel>(
                                            icon: Icon(Icons.arrow_drop_down, color: Color(0XFF505154)),
                                            onSelected: (MedicoEmpleadoModel result) {
                                              setState(() {
                                                selectedItem = result;
                                              });
                                            },

                                            itemBuilder: (BuildContext context) {
                                              return <PopupMenuEntry<MedicoEmpleadoModel>>[
                                                PopupMenuItem<MedicoEmpleadoModel>(
                                                  value: null,
                                                  child: FutureBuilder<List<MedicoEmpleadoModel>>(
                                                    future: readGrupoMedEmp(),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                                        return Container(
                                                          height: vh*0.6,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,

                                                            children: [
                                                              Center(
                                                                child: Container(
                                                                  width: 70,
                                                                  height: 70,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.blue.withOpacity(0.2), // Fondo semi-transparente
                                                                    borderRadius: BorderRadius.circular(10), // Bordes redondeados
                                                                  ),
                                                                  child: Center(
                                                                    child: CircularProgressIndicator(
                                                                      strokeWidth: 5,
                                                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xff09357E)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      } else if (snapshot.hasError) {
                                                        return Text('Error: ${snapshot.error}');
                                                      } else {
                                                        return Column(
                                                          children: snapshot.data!.map((item) {
                                                            return PopupMenuItem<MedicoEmpleadoModel>(
                                                              value: item,
                                                              child: Text(item.nombre),
                                                            );
                                                          }).toList(),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ];
                                            },),
                                        ],
                                      ),
                                    ),
                                    // Otros widgets...
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
                                            children: [
                                              Text("Inicio: ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: S2BColors.primaryColor)),
                                              Text("${(datos.fecha_ini).substring(0,10)}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: S2BColors.primaryColor)),
                                            ],
                                          ),
                                          SizedBox(height: 7),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Fin: ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: S2BColors.primaryColor)),
                                              Text("${(datos.fecha_fin).substring(0,10)}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: S2BColors.primaryColor)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                //Examen Medico

                                Divider(height: 5,),
                                SizedBox(height: 10,),

                                Container(
                                  decoration: BoxDecoration(        color: Colors.white,  borderRadius: BorderRadius.circular(10.0) ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(        color: Color(0xffEBEFFB),  borderRadius: BorderRadius.circular(10.0) ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.arrow_right_rounded, ),
                                                  Container(
                                                      width: MediaQuery.of(context).size.width*0.25,
                                                      child: Text("Médico Responsable:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),)),
                                                ],
                                              ),
                                              Text("${medicoResponsable}  ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0XFF505154)),)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        decoration: BoxDecoration(        color: Color(0xffEBEFFB),  borderRadius: BorderRadius.circular(10.0) ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.arrow_right_rounded, ),
                                                  Container(
                                                      width: MediaQuery.of(context).size.width*0.25,
                                                      child: Text("Centro Médico:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),)),
                                                ],
                                              ),
                                              Text("${centroMedico}   ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0XFF505154)),)
                                            ],
                                          ),
                                        ),
                                      ),



                                    ],
                                  ),
                                ),
                                SizedBox(height: 25,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Text('Tipo de Evaluación', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), ),
                                    Text("$tipoEvaluacion", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Color(0XFF505154)),)
                                  ],
                                ),
                                Divider(height: 30),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Text('Aptitud', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), ),
                                    Row(
                                      children: [
                                        Icon(Icons.check_circle_rounded, color: Color(0xff6DAB30),),
                                        Text(" ${aptitudNombre}", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Color(0XFF505154)),),          SizedBox(width: 5,),

                                      ],
                                    )
                                  ],
                                ),

                                Divider (height: 25,),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Observaciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),

                                    Container(
                                        width: MediaQuery.of(context).size.width*0.98,
                                        height: 60,
                                        decoration: BoxDecoration( color: Color(0xffEBEFFB),   borderRadius: BorderRadius.circular(10.0) ),

                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("${observaciones}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0XFF525659)),),
                                        ))
                                  ],
                                ),

                                SizedBox(height: 20,),

                                Container(
                                  width: MediaQuery.of(context).size.width * 0.98,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        barrierColor: Colors.black54, // Añade un fondo oscuro detrás del diálogo
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            backgroundColor: Colors.transparent, // Hace el fondo del diálogo transparente
                                            insetPadding: EdgeInsets.all(10), // Añade un poco de espacio alrededor del diálogo
                                            child: InteractiveViewer(  // Permite hacer zoom a la imagen
                                              panEnabled: false, // Desactiva el desplazamiento (pan)
                                              boundaryMargin: EdgeInsets.all(80), // Margen alrededor de la imagen
                                              minScale: 0.5,  // Factor de escala mínimo
                                              maxScale: 4,    // Factor de escala máximo
                                              child: Container(
                                                width: MediaQuery.of(context).size.width * 0.8,
                                                height: MediaQuery.of(context).size.height * 0.6,
                                                decoration: BoxDecoration(
                                                  color: Colors.white, // Color de fondo del contenedor
                                                  borderRadius: BorderRadius.circular(15), // Redondea las esquinas del diálogo
                                                ),
                                                child: Image.network(
                                                  'https://app.safe2biz.com:8080/safe2biz_ASP_DEMO/PATH_UPLOAD/8950_21_certificado_medico.png',
                                                  fit: BoxFit.contain,
                                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return Center(
                                                      child: Container(
                                                        width: 70,
                                                        height: 70,
                                                        decoration: BoxDecoration(
                                                          color: Colors.blue.withOpacity(0.2), // Fondo semi-transparente
                                                          borderRadius: BorderRadius.circular(10), // Bordes redondeados
                                                        ),
                                                        child: Center(
                                                          child: CircularProgressIndicator(
                                                            value: loadingProgress.expectedTotalBytes != null
                                                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                : null,
                                                            strokeWidth: 5,
                                                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff09357E)),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: S2BColors.orange),
                                    child: Text('Ver Certificado Médico'),
                                  ),
                                ),


                                SizedBox(height: 15,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {

                    String medicoResponsable = "Sin datos";
                    String centroMedico = "Sin datos";
                    String observaciones = "Sin datos";
                    String aptitudNombre = "Sin datos";
                    String tipoEvaluacion = "Sin datos";

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        elevation: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.96,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: vw * 0.55,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            child: Wrap(
                                              direction: Axis.horizontal,
                                              children: [
                                                Text(
                                                  selectedItem?.nombre ?? "Cargando...",
                                                  style: TextStyle(
                                                    color: Color(0XFF505154),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton<MedicoEmpleadoModel>(
                                            icon: Icon(Icons.arrow_drop_down, color: Color(0XFF505154)),
                                            onSelected: (MedicoEmpleadoModel result) {
                                              setState(() {
                                                selectedItem = result;
                                              });
                                            },
                                            itemBuilder: (BuildContext context) {
                                              return <PopupMenuEntry<MedicoEmpleadoModel>>[
                                                PopupMenuItem<MedicoEmpleadoModel>(
                                                  value: null,
                                                  child: FutureBuilder<List<MedicoEmpleadoModel>>(
                                                    future: readGrupoMedEmp(),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                                        return Container(
                                                          height: vh * 0.6,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Center(
                                                                child: Container(
                                                                  width: 70,
                                                                  height: 70,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.blue.withOpacity(0.2),
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  child: Center(
                                                                    child: CircularProgressIndicator(
                                                                      strokeWidth: 5,
                                                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xff09357E)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      } else if (snapshot.hasError) {
                                                        return Text('Error: ${snapshot.error}');
                                                      } else {
                                                        return Column(
                                                          children: snapshot.data!.map((item) {
                                                            return PopupMenuItem<MedicoEmpleadoModel>(
                                                              value: item,
                                                              child: Text(item.nombre),
                                                            );
                                                          }).toList(),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ];
                                            },
                                          ),
                                        ],
                                      ),
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
                                            children: [
                                              Text("Inicio: ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: S2BColors.primaryColor)),
                                              Text("${(selectedItem?.fecha_ini ?? '').substring(0, 10)}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: S2BColors.primaryColor)),
                                            ],
                                          ),
                                          SizedBox(height: 7),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Fin: ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: S2BColors.primaryColor)),
                                              Text("${(selectedItem?.fecha_fin ?? '').substring(0, 10)}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: S2BColors.primaryColor)),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // Examen Médico

                                Divider(height: 5,),
                                SizedBox(height: 10,),
                                Container(
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(color: Color(0xffEBEFFB), borderRadius: BorderRadius.circular(10.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.arrow_right_rounded, ),
                                                  Container(
                                                      width: MediaQuery.of(context).size.width * 0.25,
                                                      child: Text("Médico Responsable:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),)),
                                                ],
                                              ),
                                              Text("${medicoResponsable}  ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0XFF505154)),)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        decoration: BoxDecoration(color: Color(0xffEBEFFB), borderRadius: BorderRadius.circular(10.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.arrow_right_rounded, ),
                                                  Container(
                                                      width: MediaQuery.of(context).size.width * 0.25,
                                                      child: Text("Centro Médico:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),)),
                                                ],
                                              ),
                                              Text("${centroMedico}   ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0XFF505154)),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 25,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Tipo de Evaluación', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), ),
                                    Text("$tipoEvaluacion", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Color(0XFF505154)),)
                                  ],
                                ),
                                Divider(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Aptitud', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), ),
                                    Row(
                                      children: [
                                        //  Icon(Icons.check_circle_rounded, color: Color(0xff6DAB30),),
                                        Text(" ${aptitudNombre}", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Color(0XFF505154)),),          SizedBox(width: 5,),
                                      ],
                                    )
                                  ],
                                ),
                                Divider (height: 25,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Observaciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.98,
                                      height: 60,
                                      decoration: BoxDecoration( color: Color(0xffEBEFFB),   borderRadius: BorderRadius.circular(10.0) ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("${observaciones}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0XFF525659)),),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.98,
                                  height: 0,
                                  child: ElevatedButton(
                                    onPressed: (){

                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: S2BColors.orange),
                                    child: Text('Ver Certificado Médico'),
                                  ),
                                ),
                                SizedBox(height: 15,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }



                },
              ),
            ]
        ),
      ),
    );
  }

//Widget Acccidentes
  Widget _AccidentesContent(){
    double vw = MediaQuery.of(context).size.width;
    double vh = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0)),

      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
        child: FutureBuilder<List<dynamic>>(
          future: readAccidentesEmp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: vh*0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2), // Fondo semi-transparente
                          borderRadius: BorderRadius.circular(10), // Bordes redondeados
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff09357E)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<dynamic> accidentes = snapshot.data!;
              return Container(

                height: vh*0.6, // Altura fija para el contenedor de la lista
                child: ListView.builder(
                  shrinkWrap: true,

                  //  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: accidentes.length,
                  itemBuilder: (context, index) {
                    var accidente = accidentes[index];
                    return Row(
                        children: [
                          Expanded(
                            child: Card(
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
                                            width: 7,
                                            height: double.infinity,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.orangeAccent,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    bottomLeft: Radius.circular(10)
                                                ),
                                              ),
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
                                                    Text("${accidente['codigo']}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                                                    Text("${accidente['fecha_evento'].substring(0,10)}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF545150)),),
                                                  ],
                                                ),

                                                Divider(height: 12,),

                                                Container(
                                                    child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text("${accidente['tipo_registro_nombre']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, height: 1.4 ),))),
                                                //  Image.asset("${ambitoImg}", width: 20,),

                                                SizedBox(height: 2,),

                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                          accidente['descripcion_evento']?.isEmpty ?? true ? "No especifica" : accidente['descripcion_evento'],
                                                          maxLines: 2,
                                                          style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                                                        )
                                                    ),
                                                  ],
                                                ),


                                                SizedBox(height: 8,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("${accidente['lugar_evento']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                                    Container(
                                                        width: 90,
                                                        height: 20,
                                                        child: ElevatedButton(onPressed: (){


                                                        },
                                                            style: ElevatedButton.styleFrom(
                                                              //shape: StadiumBorder(),
                                                                backgroundColor: Colors.orangeAccent
                                                            ),
                                                            child: FittedBox(child: Text("${accidente['potencial_perdida_nombre']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12) )  ))),
                                                  ],
                                                )
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
                    );
                  },
                ),
              );
            } else {
              return  Container(
                height: MediaQuery.of(context).size.height*0.5,
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
              );
            }
          },
        ),
      ),
    );
  }

  //Widget Epp
  Widget _EPPContent(){
    double vw = MediaQuery.of(context).size.width;
    double vh = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
        child: FutureBuilder<List<dynamic>>(
          future: futureEpps,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: vh*0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2), // Fondo semi-transparente
                          borderRadius: BorderRadius.circular(10), // Bordes redondeados
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff09357E)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<dynamic> epps = snapshot.data!;
              return Container(
                height: vh*0.6,
                child: ListView.builder(
                  shrinkWrap: true,

                  itemCount: epps.length,
                  itemBuilder: (context, index) {
                    var epp = epps[index];
                    return Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Imagen del producto (cambia según si la imagen está disponible)
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _showImage
                                        ? Container(
                                      width: 40,
                                      height: 40,
                                      child: DynamicImageLoader(
                                        imageUrlBase: "https://app.safe2biz.com:8080/safe2biz_ASP_DEMO/PATH_UPLOAD",
                                        imageCode: '5600_${epp['epp_producto_id']}_${epp['producto_codigo']}',

                                      ),
                                    )
                                        : Image.asset(
                                      'assets/images/productoDefault.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Text("${epp['producto_codigo']}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0XFF545150))),

                                ],
                              ),

                              // Divisor vertical
                              VerticalDivider(thickness: 0.3, color: Colors.grey),

                              // Detalles del producto
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Código del producto y fecha de entrega


                                    // Marca y nombre del producto
                                    SizedBox(height: 0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible( // Usa Flexible para permitir múltiples líneas
                                          child: Text(
                                            "${epp['tipo_equipo_nombre']}",
                                            style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
                                            //   overflow: TextOverflow.ellipsis, // Muestra puntos suspensivos si es demasiado largo
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                " Vigencia:",
                                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0XFF545150)),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                              child: Text(
                                                "${epp['fecha_fin_vigencia'].substring(0, 10)}",
                                                style: TextStyle(fontSize: 10, height: 1.5),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),



                                    SizedBox(height: 2),
                                    Text("${epp['producto_marca']}", style: TextStyle(fontSize: 12, color: Colors.grey)),

                                    SizedBox(height: 20,),

                                    // Cantidad y boton de acción
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Cantidad: ${epp['cantidad']}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),

                                        Container(
                                          height: 22,
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                                            child: FittedBox(child: Text("${epp['nombre']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return  Container(
                width: vw*1,
                height: MediaQuery.of(context).size.height*0.5,
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
              );
            }
          },
        ),
      ),
    );
  }

  //Widget Capacitación
  Widget _CapacitacionContent() {
    double vh = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0)),

      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
        child: FutureBuilder<List<dynamic>>(
          future: readCapacitacionEmp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: vh*0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2), // Fondo semi-transparente
                          borderRadius: BorderRadius.circular(10), // Bordes redondeados
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff09357E)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<dynamic> capacitaciones = snapshot.data!;
              return Container(
                height: vh * 0.6, // Altura fija para el contenedor de la lista
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: capacitaciones.length,
                  itemBuilder: (context, index) {
                    var capacitacion = capacitaciones[index];
                    Color botonColor = capacitacion['resultado_nombre'] == 'Aprobado' ? Colors.green : (capacitacion['resultado_nombre'] == 'Desaprobado' ? Colors.red : Colors.blueAccent);

                    return Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 7,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          color: botonColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Expanded(child: Text("${capacitacion['curso_nombre']}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 1.5),)),
                                                  Text("${capacitacion['fecha_curso'].substring(0, 10)} ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0XFF545150))),
                                                ],
                                              ),

                                              Divider(height: 16),
                                              Text("${capacitacion['rol_capacitacion_nombre']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0XFF545150))),
                                              SizedBox(height: 4),
                                              Expanded(child: Text("Puesto: ${capacitacion['puesto_trabajo_nombre']}", style: TextStyle(fontSize: 12, color: Colors.grey))),
                                              SizedBox(height: 6),

                                              Padding(
                                                padding: const EdgeInsets.only(right: 4.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox.shrink(),
                                                    Container(
                                                      width: 100,
                                                      height: 22,
                                                      child: ElevatedButton(
                                                          onPressed: () {},
                                                          style: ElevatedButton.styleFrom( backgroundColor: botonColor),
                                                          child: FittedBox(child: Text("${capacitacion['resultado_nombre']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(height: 5,)

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
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return  Container(
                width: MediaQuery.of(context).size.width*1,
                height: MediaQuery.of(context).size.height*0.5,
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
              );
            }

          },
        ),
      ),
    );
  }

  //Widget Enf. Ocupacional
  Widget _EnfOcupacionalesContent() {
    double vw = MediaQuery.of(context).size.width;
    double vh = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0)),

      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
        child: FutureBuilder<List<dynamic>>(
          future: readEnfOcupacionalesEmp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: vh*0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2), // Fondo semi-transparente
                          borderRadius: BorderRadius.circular(10), // Bordes redondeados
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff09357E)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<dynamic> enfermedades = snapshot.data!;
              return Container(
                height: vh * 0.6, // Altura fija para el contenedor de la lista
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: enfermedades.length,
                  itemBuilder: (context, index) {
                    var enfermedad = enfermedades[index];
                    return Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0, top: 0.0, bottom: 0.0),
                                child: IntrinsicHeight(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 1,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 7,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.orangeAccent,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10)
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: 10),


                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("${enfermedad['codigo']}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                    Text("${enfermedad['fecha_investigacion'].substring(0, 10)}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF545150))),
                                                  ],
                                                ),
                                                Divider(height: 12),
                                                Text("${enfermedad['nombre_aseguradora']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                SizedBox(height: 2),
                                                Expanded(child: Text("Diagnóstico: ${enfermedad['diagnostico']}", maxLines: 2, style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.6))),
                                                SizedBox(height: 6,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("${enfermedad['institucion_calificadora']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                                    Container(
                                                        width: 100,
                                                        height: 22,
                                                        child: ElevatedButton(onPressed: (){

                                                        },
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.orangeAccent
                                                            ),
                                                            child: FittedBox(child: Text("${enfermedad['tipo_causa']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12) )  ))),
                                                  ],
                                                )
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
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return  Container(

                height: MediaQuery.of(context).size.height*0.5,
                width: vw*1,
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
              );
            }
          },
        ),
      ),
    );
  }

  //Widget Plan de Accion
  Widget _PlanesAccionContent() {
    double vw = MediaQuery.of(context).size.width;
    double vh = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
        child: FutureBuilder<List<dynamic>>(
          future: readPlanAccionEmp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: vh*0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff09357E)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<dynamic> planesAccion = snapshot.data!;
              return Container(
                height: vh * 0.6,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: planesAccion.length,
                  itemBuilder: (context, index) {
                    var planAccion = planesAccion[index];
                    return Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(planAccion['codigo_accion_correctiva'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                        Text(planAccion['fecha_acordada_ejecucion'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF545150))),
                                      ],
                                    ),
                                    Divider(height: 10),
                                    Text(planAccion['accion_correctiva_detalle'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    SizedBox(height: 6),
                                    Text(planAccion['origen'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Container(
                height: MediaQuery.of(context).size.height*0.5,
                width: vw*1,
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
              );
            } else {
              // Retorna un widget por defecto en caso de que ninguno de los casos anteriores se cumpla
              return SizedBox.shrink(); // Puedes retornar un widget vacío o algún otro widget según tus necesidades
            }
          },
        ),
      ),
    );
  }




  //=== Request información médica del empleado
  Future<List<MedicoEmpleadoModel>> readGrupoMedEmp() async {

    final user = await authController.getUserFromStorage();

    var url = '${user!.urlApp}/ws/null/pr_ws_grupo_medico_empleado?fb_empleado_id=${widget.fb_empleado_id}';
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

    print("Response status: ${response.statusCode}");
    var data = jsonDecode(response.body)['data'];
    print("Data fetched: ${data}");

    if (data != null && data.isNotEmpty) {
      List<MedicoEmpleadoModel> models = List.from(data).map((item) => MedicoEmpleadoModel.fromJson(item)).toList();

      // Set the first item as selected if no item is selected yet
      if (selectedItem == null) {
        setState(() {
          selectedItem = models.first;
        });
      }

      return models;
    } else {
      print("Error: No data available");
      return [];
    }
  }

  //=== Request accidentes del empleado
  Future<List> readAccidentesEmp() async {

    var map = new Map<String, String>();

    final user = await authController.getUserFromStorage();


    var url = '${user!.urlApp}/ws/null/pr_ws_accidente_empleado?fb_emp=${widget.fb_empleado_id}&fb_uea=${widget.sede}';
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

    print("${response.statusCode}");
    var data = jsonDecode(response.body)['data'];
    print("lista ----> ${data}]");
    print('id fb_emp accidentes ---${widget.fb_empleado_id}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to load data');
    }

  }
  Future<List> readEPPEmp() async {

    final user = await authController.getUserFromStorage();
    var map = new Map<String, String>();

    var url = '${user!.urlApp}/ws/null/pr_ws_epp_empleado?fb_emp=${widget.fb_empleado_id}&fb_uea=${widget.sede}';
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


    print("${response.statusCode}");
    var data = jsonDecode(response.body)['data'];
    print("lista ----> ${data}]");

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<List> readCapacitacionEmp() async {

    final user = await authController.getUserFromStorage();
    var map = new Map<String, String>();

    var url = '${user!.urlApp}/ws/null/pr_ws_capacitacion_empleado?fb_emp=${widget.fb_empleado_id}&fb_uea=${widget.sede}';
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


    print("${response.statusCode}");
    var data = jsonDecode(response.body)['data'];
    print("lista ----> ${data}]");

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<List> readEnfOcupacionalesEmp() async {
    final user = await authController.getUserFromStorage();
    var map = new Map<String, String>();

    map['sc_user_id'] = '18544';

    var url = '${user!.urlApp}/ws/null/pr_ws_enfermedades_empleado?fb_emp=${widget.fb_empleado_id}&fb_uea=${widget.sede}';
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

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to load data');
    }

  }
  Future<List> readPlanAccionEmp() async {
    final user = await authController.getUserFromStorage();
    var map = new Map<String, String>();

    map['sc_user_id'] = '18544';

    var url = '${user!.urlApp}/ws/null/pr_movil_ACC_Consulta_Pendientes?uea_id=${widget.sede}&usuario_id=${widget.fb_empleado_id}';
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

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to load data');
    }

  }


  @override
  Future<void> scanBarcodeNormal() async {
    Toast.show(
      description: 'Escaner por agregar..',
      toastType: ToastType.error,
    );
  }

  void sendProdInfo(BuildContext context, String codigo) async {
    //sendInfoProduct

    List<Map> datoEscaneadoProd =
    await sqlDb.readData("SELECT * FROM empleadoMina "
        " WHERE empleadoMina.numero_documento = '$codigo' ");
    print(datoEscaneadoProd);

    if (datoEscaneadoProd.isNotEmpty) {
      Nav.go(context, DatosTrabajador(
        fb_empleado_id: datoEscaneadoProd.first["id"].toString(),
        sede: datoEscaneadoProd.first["fb_uea_pe_id"].toString(),))
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
                          'No encontramos el código\n"${codigo}" en nuestros registros.', style: TextStyle(height: 1.4),),
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

class DynamicImageLoader extends StatefulWidget {
  final String imageUrlBase;
  final String imageCode;


  const DynamicImageLoader({
    Key? key,
    required this.imageUrlBase,
    required this.imageCode,

  }) : super(key: key);

  @override
  _DynamicImageLoaderState createState() => _DynamicImageLoaderState();
}

class _DynamicImageLoaderState extends State<DynamicImageLoader> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _imageFound = false;
  String? _finalUrl;

  final List<String> _extensions = ['png', 'jpg', 'jpeg', 'gif'];

  @override
  void initState() {
    super.initState();
    _findImage();

  }
  void dispose(){
    //...
    super.dispose();
    //...
  }
  Future<void> _findImage() async {
    String? tempUrl;
    for (var ext in _extensions) {
      String testUrl = "${widget.imageUrlBase}/${widget.imageCode}.$ext";
      if (await _checkImage(testUrl)) {
        tempUrl = testUrl;
        break;
      }
    }

    if (mounted) {
      setState(() {
        _finalUrl = tempUrl;
        _imageFound = tempUrl != null;
      });

    }
  }

  Future<bool> _checkImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      print("Código de estado para $url: ${response.statusCode}"); // Imprimir el código de estado
      return response.statusCode == 200;
    } catch (e) {
      print("Error al verificar $url: $e"); // Imprimir cualquier error
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    print("URL final: $_finalUrl"); // Para depuración
    return _finalUrl != null
        ? Image.network(
      _finalUrl!,
      fit: BoxFit.fill,
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Image.asset('assets/images/productoDefault.png');
      },
    )
        : Image.asset('assets/images/productoDefault.png');
  }




}






class MySearchDelegateSST extends SearchDelegate {

  final Function(String) onScanResult;
  String? sede;



  MySearchDelegateSST({
    required this.onScanResult,
    required this.sede,
    String hintText = "Buscar Empleado",
  }) : super(
    searchFieldLabel: hintText,
    searchFieldStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.search,
  );

  SqlDb sqlDb = SqlDb();
  final apiEntrega = ApiEntregaEpp();

  @override
  List<Widget>? buildActions(BuildContext context) {

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
            icon: FaIcon(FontAwesomeIcons.barcode),
            onPressed: () async {
              Toast.show(
                description: 'Escaner por agregar..',
                toastType: ToastType.error,
              );
            },
          ),
        ],
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return SizedBox(width: 0);

  }

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
  Widget buildSuggestions(BuildContext context) {


    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            child: FutureBuilder<List<Map>>(
                future: postRequestSqlite(query),
                builder:
                    (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                  var data = snapshot.data;
                  if (data == null) {
                    print("NO HAY DATOS");
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    var datalength = data.length;
                    if (datalength == 0) {
                      return Container();
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
                                    int idEmp = data[index]['fb_empleado_id'];
                                    int fb_uea_pe_id = data[index]['fb_uea_pe_id'];
                                    print(
                                        "DATOS USUARIO SELECCIONADO ----> $idEmp, $fb_uea_pe_id");
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => DatosTrabajador(
                                        sede: fb_uea_pe_id.toString(),
                                        fb_empleado_id: idEmp.toString(),
                                      )),
                                          (Route<dynamic> route) => false, // No deja rutas anteriores en la pila
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
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }


  Future<List<Map>> postRequestSqlite(String query) async {
    List<Map> datoEscaneadoProd =
    await sqlDb.readData("SELECT * FROM empleadoMina where empleadoMina.nombreCompleto like '%$query%' AND empleadoMina.fb_uea_pe_id = '${sede}'  ");
    print('empleados =====>>>>> $datoEscaneadoProd');
    return datoEscaneadoProd;
  }


}


//AND fb_uea_pe_id = '${widg}'