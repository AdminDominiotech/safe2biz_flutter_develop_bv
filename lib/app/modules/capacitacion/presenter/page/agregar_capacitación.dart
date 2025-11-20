import 'dart:convert';
import 'dart:ffi';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/global/core/shared_widgets/layout/app_bar_back.dart';
import 'package:safe2biz/app/modules/capacitacion/presenter/page/SearchPage.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/epp/presenter/widgets/FechaHora.dart';
import 'package:safe2biz/app/ui/module_ui.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import '../../../auth/features/login/data/models/user_model.dart';
import '../../../sedes/features/sincronizar/data/models/empleado_model.dart';


class AgregarCapacitacion extends StatefulWidget {
  const AgregarCapacitacion({Key? key}) : super(key: key);

  @override
  State<AgregarCapacitacion> createState() => _AgregarCapacitacionState();
}
final localSqliteInstance = LocalSqlite();
final authController = AuthController(sqlite: localSqliteInstance);

class _AgregarCapacitacionState extends State<AgregarCapacitacion> {

  final _formKey = GlobalKey<FormState>();
  final _userEditTextController = TextEditingController(text: 'Mrs');

  String? institucion;


  List<String> ids = [];
  List<dynamic>? listNuevosAsistentes;

  String? _expositor;
  String? _rolExpositor;
  String? _seleccionRolExpositor;
  String? _seleccionModalidad;
  String? _seleccionEstadoCurso;



  List<String> empleadosLista = [''];

  //Comboboxes
  List<String> RolExpositorLista = [''];
  List<String> ModalidadLista = [''];
  List<String> EstadoCursoLista = [''];

  DateTime dateSelected = DateTime.now();

  String? _txtNombreCurso;
  String? _txtInstitucion;
  String? _txtPuntajeTotal;
  String? _txtPuntajeAprobatorio;
  String? _txtHora;
  String? _txtCosto;
  //ID's

  int? estadoCursoId;
  int? modalidadCursoId;
  final fechaTxtIni = TextEditingController(text: DateTime.now().formatLocalFech);
  final fechaTxtFin = TextEditingController(text: DateTime.now().formatLocalFech);


  String sede = LocalPreferences.prefs?.getString('current_sede') ?? '';

  SqlDb sqlDb = SqlDb();

  @override
  void initState(){
    super.initState();
    readDataProdEmp();
    readDataModalidad();
    readDataRolExpositor();
    readDataEstadoCurso();
  }

  Future<List<Map>> readDataProdEmp() async {
    List<Map> response =
    await sqlDb.readData("SELECT em.nombreCompleto FROM empleadoMina em ");
    print("response empleados --- ${response}");

    print("Listaa ---- $empleadosLista");
setState(() {
  //List Map to List
  empleadosLista = response.map<String>((item) => item['nombreCompleto']).toList() ;
});
    return response;
  }


  Future<List<Map>> readDataRolExpositor() async {
    List<Map> response = await sqlDb.readData("SELECT em.rol FROM RolExpositorCapacitacion em ");

    setState(() {RolExpositorLista = response.map<String>((item) => item['rol']).toList() ;});
    print("response RolExpositorLista --- ${RolExpositorLista}");
    return response;
  }

  Future<List<Map>> readDataModalidad() async {
    List<Map> response = await sqlDb.readData("SELECT em.nombre FROM ModalidadCapacitacion em ");

    setState(() {ModalidadLista = response.map<String>((item) => item['nombre']).toList() ;});
    print("response ModalidadCapacitacion --- ${ModalidadLista}");
    return response;
  }

  Future<List<Map>> readDataEstadoCurso() async {
    List<Map> response = await sqlDb.readData("SELECT em.nombre FROM EstadoCursoCapacitacion em ");

    setState(() {EstadoCursoLista = response.map<String>((item) => item['nombre']).toList() ;});
    print("response EstadoCursoCapacitacion --- ${EstadoCursoLista}");
    return response;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: S2BColors.primaryColor,
      appBar: AppBarBack('$sede'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 65,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 1,
              color: S2BColors.primaryColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text("Agregar Capacitación", style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(35.0),
                    topLeft: Radius.circular(35.0)),),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        //Fecha - Hora
                        Row(
                          children: [
                            Expanded(
                              child: InputTextField(
                                controller: fechaTxtIni,
                                readOnly: true,
                                onTap: () async {
                                  _selectDayIni(context);
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
                                placeholder: "Fecha Inicio",
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: InputTextField(
                                controller: fechaTxtFin,
                                readOnly: true,
                                onTap: () async {
                                  _selectDayFin(context);
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
                                placeholder: "Fecha Fin",
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 25,),

                        Container(
                          height: 50,
                          child: TextFormField(
                            decoration: InputDecoration(
                              //     enabled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 1.5),

                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.2),

                              ),

                              labelStyle: TextStyle(
                                fontSize: 13,
                                color: Color(0XFFB6B6B6),
                              ),

                              labelText: 'Nombre del Curso',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor ingrese su nombre';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState((){
                                _txtNombreCurso = value;
                              });

                            },
                            onChanged: (String? value) {
                              setState((){
                                _txtNombreCurso = value;
                              });

                            } ,
                          ),
                        ),

                        SizedBox(height: 25,),


                        //Expositor --- ROL

                            Container(

                             child:   DropdownSearch<String>(
                                  items: empleadosLista,

                                  // ⬇️ ANTES: dropdownSearchTextStyle / dropdownSearchDecoration
                                  // ⬇️ AHORA:
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                    // estilo del texto seleccionado
                                    baseStyle: const TextStyle(fontSize: 14),
                                    // decoración del TextField “cerrado”
                                    dropdownSearchDecoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(color: Colors.black, width: 1.2),
                                      ),
                                      hintText: 'Expositor',
                                      labelText: 'Expositor',
                                      labelStyle: const TextStyle(fontSize: 13, color: Color(0xFFB6B6B6)),
                                      contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),

                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _expositor = newValue;
                                    });
                                  },

                                  popupProps: PopupProps.bottomSheet(
                                    showSearchBox: true,

                                    // buscador dentro del popup
                                    searchFieldProps: TextFieldProps(
                                      style: const TextStyle(fontSize: 14),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                                        labelText: "Buscar Expositor",
                                      ),
                                      // padding dejó de estar soportado aquí en algunas versiones;
                                      // si da warning, quítalo o envuélvelo con Padding en title/emptyBuilder.
                                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    ),

                                    title: Container(
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        color: S2BColors.primaryColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Expositor',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ),
                                    ),

                                    // ⬇️ 'contentTextStyle' ya no existe; elimínalo.
                                    bottomSheetProps: const BottomSheetProps(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(24),
                                          topRight: Radius.circular(24),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ),


                        SizedBox(height: 25,),

                        Container(
                          height: 54,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(

                              isDense: false,
                              //     enabled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 1.5),

                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.2),
                              ),

                              labelStyle: TextStyle(
                                fontSize: 13,
                                color: Color(0XFFB6B6B6),
                              ),

                              labelText: 'Rol Expositor',

                            ),
                            value: _seleccionRolExpositor,
                            style: TextStyle(fontSize: 11, color: Colors.black),
                            onChanged: (String? newValue) {
                              setState(() {
                                _seleccionRolExpositor = newValue;
                              });
                            },
                            items: RolExpositorLista
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(

                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 25,),

                        Container(
                          height: 50,
                          child: TextFormField(
                            decoration: InputDecoration(
                              //     enabled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 1.5),

                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.2),

                              ),

                              labelStyle: TextStyle(
                                fontSize: 13,
                                color: Color(0XFFB6B6B6),
                              ),

                              labelText: 'Institución',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Institución';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              institucion = value;
                            },
                            onChanged: (String? value) {
                              setState((){
                                _txtInstitucion = value;
                              });
                            } ,
                          ),
                        ),


                        SizedBox(height: 25,),
                        //=========PUNTAJES
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width*0.42,
                              child: TextFormField(
                                decoration: InputDecoration(

                                  //     enabled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.5),

                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.2),

                                  ),

                                  labelStyle: TextStyle(
                                    fontSize: 13,
                                    color: Color(0XFFB6B6B6),
                                  ),

                                  labelText: 'Puntaje Total',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor ingrese su puntaje total';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _txtPuntajeTotal = value;
                                },
                                onChanged: (String? value) {
                                  setState((){
                                    _txtPuntajeTotal = value;
                                  });

                                } ,

                              ),
                            ),

                            Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width*0.42,
                              child: TextFormField(
                                decoration: InputDecoration(

                                  //     enabled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.5),

                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.2),

                                  ),

                                  labelStyle: TextStyle(
                                    fontSize: 13,
                                    color: Color(0XFFB6B6B6),
                                  ),

                                  labelText: 'Puntaje Aprob.',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor ingrese su puntaje aprobatorio';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _txtPuntajeAprobatorio = value;
                                },
                                onChanged: (String? value) {
                                  setState((){
                                    _txtPuntajeAprobatorio = value;
                                  });

                                } ,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25,),
                        //Horas-Modalidad
                        Container(
                          height: 54,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(

                              isDense: false,
                              //     enabled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 1.5),

                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.2),
                              ),
                              labelStyle: TextStyle(
                                fontSize: 13,
                                color: Color(0XFFB6B6B6),
                              ),


                              labelText: 'Modalidad',
                            ),
                            value: _seleccionModalidad,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            onChanged: (String? newValue) {
                              setState(() {
                                _seleccionModalidad = newValue;
                              });


                              Future.delayed(const Duration(milliseconds: 500), () async{

                                await readIdModalidad('$_seleccionModalidad');

                              });


                            },
                            items: ModalidadLista
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),

                        SizedBox(height: 25,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width*0.42,
                              child: TextFormField(
                                decoration: InputDecoration(
                                 /* suffixIcon: new Icon(
                                    Icons.access_time_sharp,
                                    color: S2BColors.primaryColor,
                                  ),
                                  */
                                  //     enabled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                        color: Color(0XFFB6B6B6), width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.2),
                                  ),

                                  labelStyle: TextStyle(
                                    fontSize: 13,
                                    color: Color(0XFFB6B6B6),
                                  ),


                                  labelText: 'Horas',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor ingrese su nombre';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _txtHora = value;
                                },
                                onChanged: (String? value) {
                                  setState((){
                                    _txtHora = value;
                                  });

                                } ,
                              ),
                            ),
                            Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width*0.42,
                              child: TextFormField(
                                decoration: InputDecoration(

                                  prefixIcon: Image.asset('assets/icons/sol-icon.png', scale: 3),
                                  //     enabled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.2),

                                  ),

                                  labelStyle: TextStyle(
                                    fontSize: 13,
                                    color: Color(0XFFB6B6B6),
                                  ),


                                  labelText: 'Costo',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor ingrese el costo';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _txtCosto = value;
                                },
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _txtCosto = newValue;
                                  });
                                },
                              ),
                            ),

                          ],
                        ),

                        SizedBox(height: 25,),
                        Container(
                          height: 54,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(

                              isDense: false,
                              //     enabled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 1.5),

                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.2),
                              ),

                              labelStyle: TextStyle(
                                fontSize: 13,
                                color: Color(0XFFB6B6B6),
                              ),

                              labelText: 'Estado Curso',
                            ),
                            value: _seleccionEstadoCurso,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            onChanged: (String? newValue) {
                              setState((){
                                _seleccionEstadoCurso = newValue;

                              });



                              Future.delayed(const Duration(milliseconds: 500), () async{

                                await readIdEstado('$_seleccionEstadoCurso');

                              });



                            },
                            items: EstadoCursoLista
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),

                        SizedBox(height: 50,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.6,
                              height: 45,
                              child:ElevatedButton(
                                 child: Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                                onPressed: () async{


                                  int response = await sqlDb.insertData("INSERT INTO 'cap_curso' "
                                      "( 'nombre',            'institucion',                'expositor',    'fecha_inicio',                      'fecha_final',                            'puntaje_curso',       'puntaje_aprobatorio',       'costo',            'horas',     'cap_curso_estado_id',    'fb_uea_pe_id',       'cap_curso_modalidad_id',  'user_id',  'estado') VALUES "
                                      "( '${_txtNombreCurso}',   '${_txtInstitucion}',     '${_expositor}', '${fechaTxtIni.text.substring(0,10)}', '${fechaTxtFin.text.substring(0,10)}', '${_txtPuntajeTotal}', '${_txtPuntajeAprobatorio}',   '${_txtCosto}',  '${_txtHora}',      '$estadoCursoId' ,   '1',           '$modalidadCursoId',                '1'   ,     '1' ) ");
                                  print("Guardado -- $response");




                                  Future.delayed(const Duration(milliseconds: 500), () async {
                                    List<Map> response = await sqlDb.readData("SELECT * FROM cap_curso");
                                    print("response cap_curso BD local ---- $response");
                                  });

                                  Container(
                                    color: S2BColors.primaryColor,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextLabel.h6(
                                          'Guardado exitosamente',
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
                                            onTap: () {
                                              Nav.back(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );



                                  /*
                                      int response = await sqlDb.insertData("INSERT INTO 'cap_curso' "
                                      "('codigo',      'nombre',            'institucion',                'expositor',    'fecha_inicio',                      'fecha_final',                            'puntaje_curso',       'puntaje_aprobatorio',       'costo',            'horas',     'cap_curso_estado_id', 'fb_uea_pe_id', 'estado') VALUES "
                                      "('0',        '${_txtNombreCurso}',   '${_txtInstitucion}',     '${_expositor}', '${fechaTxtIni.text.substring(0,10)}', '${fechaTxtFin.text.substring(0,10)}', '${_txtPuntajeTotal}', '${_txtPuntajeAprobatorio}',   '${_txtCosto}'),  '${_txtHora},        '2' ,               '${sede}',       '1'  ");
                                      print("Guardado -- $response");
                                   */

                                  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage()));

                              print('rol expo ${    _rolExpositor}');
                              print('nombre curso ${    _txtNombreCurso}');

                                   },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: S2BColors.primaryColor,
                                  shape: StadiumBorder()
                                ),
                              ),
                            )
                          ],
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  RenderBox? _findBorderBox(RenderBox box) {
    RenderBox? borderBox;

    box.visitChildren((child) {
      if (child is RenderCustomPaint) {
        borderBox = child;
      }

      final box = _findBorderBox(child as RenderBox);
      if (box != null) {
        borderBox = box;
      }
    });
    return borderBox;
  }

  Future<void> _selectDayIni(BuildContext context) async {
   // DateTime fecha2 =  DateTime.parse('2069-07-20 00:10:00Z');
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
            lastDate: dateSelected,
            
            onDateChanged: (d) {
              dateSelected = d;
              fechaTxtIni.text = d.formatLocalFech;
              Navigator.pop(
                context,
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _selectDayFin(BuildContext context) async {
     DateTime fechaFin =  DateTime.parse('2069-07-20 00:10:00Z');
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
            lastDate: fechaFin,

            onDateChanged: (d) {
              dateSelected = d;
              fechaTxtFin.text = d.formatLocalFech;
              Navigator.pop(
                context,
              );
            },
          ),
        );
      },
    );
  }

  Future<List<Map>> readIdEstado(String estadoCursoValue) async {
    List<int> estado = [];
    List<Map> response = await sqlDb.readData("SELECT * FROM EstadoCursoCapacitacion em "
        "WHERE em.nombre = '$estadoCursoValue' ");
    setState(() {estado = response.map<int>((item) => item['cap_curso_estado_id']).toList() ;});
    print("response estado curso --- ${estado[0]}");
    print("response estado res $response}");

    estadoCursoId = estado.first;
    print("response estadoCursoId res $estadoCursoId}");
    return response;
  }

  Future<List<Map>> readIdModalidad(String estadoCursoValue) async {
    List<int> estado = [];
    List<Map> response = await sqlDb.readData("SELECT * FROM ModalidadCapacitacion em "
        "WHERE em.nombre = '$estadoCursoValue' ");
    setState(() {estado = response.map<int>((item) => item['cap_curso_modalidad_id']).toList() ;});
    print("response estado curso --- ${estado[0]}");
    print("response estado res $response}");

    modalidadCursoId = estado.first;
    print("response modalidadCursoId res $modalidadCursoId}");
    return response;
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

  Widget _customDropDownExampleMultiSelection(
      BuildContext context, List<EmpleadoModel?> selectedItems) {
    if (selectedItems.isEmpty) {
      return Container(

        child: ListTile(
          contentPadding: EdgeInsets.all(0),

          leading: Icon(Icons.people, color: Color(0XFF505154),),
          title: Text("", style: TextStyle(color: Color(0XFF505154), fontSize: 16),),
        ),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height*0.8,
      child: Wrap(
        children: selectedItems.map((e) {
          return Container(
            child: Padding(
              padding: EdgeInsets.symmetric( vertical: 4.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(    borderRadius: BorderRadius.circular(5.0) ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading:  CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8), // Border radius
                          child: ClipOval(child: Image.asset('assets/images/userDefault.png')),
                        ),
                      ),
                      title: Text(e?.nombreCompleto ?? '', style: TextStyle(color: Color(0XFF505154), fontSize: 14),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e?.numeroDocumento.toString() ?? '', style: TextStyle(fontSize: 12, color: Color(0XFFB6B6B6), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      child: Divider(height: 5, color: Color(0XFFB6B6B6),))
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  Widget _customPopupItemBuilderExample2(
      BuildContext context, EmpleadoModel? item, bool isSelected) {
    return Container(

      margin: EdgeInsets.zero,
      decoration: !isSelected
          ? null
          : BoxDecoration(
        border: Border.all(color: S2BColors.primaryColor),
//        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.nombreCompleto ?? '', style: TextStyle(color: Color(0XFF505154), fontSize: 14),),
        subtitle: Text(
          item?.numeroDocumento.toString() ?? '', style: TextStyle(fontSize: 12, color: Color(0XFFB6B6B6), fontWeight: FontWeight.bold),
        ),
        leading:   Container(
          decoration: const BoxDecoration(
              border: Border(right: BorderSide(width: 1, color:Color(0XFFB6B6B6) ),)),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.transparent,
              // Border radius
              child: ClipOval(child: Image.asset('assets/images/userDefault.png')),
            ),
          ),
        ),
      ),
    );
  }

}



class UserModel {
  final String id;
  final DateTime createdAt;
  final String name;
  final String avatar;

  UserModel({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      createdAt: DateTime.parse(json["createdAt"]),
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  static List<UserModel> fromJsonList(List list) {
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String filter) {
    return this.createdAt.toString().contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel model) {
    return this.id == model.id;
  }

  @override
  String toString() => name;
}