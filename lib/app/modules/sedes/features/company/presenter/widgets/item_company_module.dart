import 'dart:async';
import 'dart:io';

import 'package:bottom_nav_layout/bottom_nav_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:mobile_safe2bizapp_web_view/mobile_safe2bizapp_web_view.dart';
import 'package:mobile_safe2bizapp_web_view/web_view/page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/modules/InformacionSST/presenter/page/DatosTrabajador.dart';
import 'package:safe2biz/app/modules/InformacionSST/presenter/page/InformacionSSTHome.dart';
import 'package:safe2biz/app/modules/InformacionSST/presenter/page/MiInformacion.dart';
import 'package:safe2biz/app/modules/actos_condiciones/presenter/page/ayc_page.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/actos_condiciones_bot/presenter/page/actos_condiciones_page.dart';
import 'package:safe2biz/app/modules/capacitacion/presenter/page/capacitacion_page.dart';
import 'package:safe2biz/app/modules/epp/EPPPage.dart';
import 'package:safe2biz/app/modules/epp/external/api/entrega_epp_api.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
//import 'package:safe2biz/app/modules/epp/presenter/page/calendario_entrega.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/estadistica_entrega.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/lista_entrega.dart';
import 'package:safe2biz/app/modules/graficos/estadisticas_seguridad/estadisticas_seguridad.dart';
import 'package:safe2biz/app/modules/graficos/indicadores_seguridad/indicadores_seguridad.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/incidente_accidente.dart';
import 'package:safe2biz/app/modules/incidente_accidente/presenter/presenter.dart';
import 'package:safe2biz/app/modules/ops/presenter/page/ops_page.dart';
import 'package:safe2biz/app/modules/planes_accion/presenter/page/sac_page.dart';
import 'package:safe2biz/app/modules/reporte_acc.dart';
import 'package:safe2biz/app/modules/reporte_inc.dart';
import 'package:safe2biz/app/modules/sedes/features/company/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/presenter/page/sincronizar_body.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/presenter/page/sincronizar_page.dart';

String idSede = "";

String remotePDFpath = "";
String filename = "";
String formattedDate = "";

String remotePDFpathAcc = "";
String filenameAcc = "";
String formattedDateAcc = "";

List<int> EntregaTipoy = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];    //Seguridad
List<int> EntregaTipoy1 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];  //Salud

//AYC
List<int> AYCY1 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];    //Seguridad
List<int> AYCY2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];  //Salud
List<int> AYCY3 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];  //Sa

class ItemCompanyModule extends StatefulWidget {
   ItemCompanyModule({
    Key? key, required this.module,  this.onTap, this.remotePDFpath, this.filename, this.sede,
  }) : super(key: key);

  final ItemModule module;
  final VoidCallback? onTap;

  //reporte inc ( acc
  String? remotePDFpath, filename, sede;

  @override
  State<ItemCompanyModule> createState() => _ItemCompanyModuleState();
}
SqlDb sqlDb = SqlDb();

class _ItemCompanyModuleState extends State<ItemCompanyModule> {


  bool _syncChecked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_syncChecked) {
      _syncChecked = true;
      // Espera a que termine el primer frame para tener un context seguro
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _maybeSyncCurrentSede();
      });
    }
  }


  Future<void> _maybeSyncCurrentSede() async {
    // 1) Obtén el id de la sede actual
    final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';
    if (idSede.isEmpty) return;

    // 2) Construye la clave única para esta sede
    final key = 'sync_done_$idSede';

    // 3) Revisa si ya sincronizamos antes
    final yaSync = LocalPreferences.prefs?.getBool(key) ?? false;
    if (yaSync) return;

    // 4) No está sincronizada: navega a SincronizarPage
    await Nav.go(context, SincronizarPage());

    // 5) Cuando regrese, marca como sincronizada
    await LocalPreferences.prefs?.setBool(key, true);
  }

  //final url = "https://app.safe2biz.com/safe2biz_demo/externalReport/execute/safe2biz_demo/rpt_inc_informe_final_status_APP/PDF/id_sede=${idSede}%7Cid_usuario=${auth.getID}/investigacion";
  //final urlAcc = "https://app.safe2biz.com/safe2biz_demo/externalReport/execute/safe2biz_demo/rpt_sac_informe_final_acciones_APP/PDF/id_sede=${idSede}%7Cid_usuario=${auth.getID}/investigacion";

  String? file;

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl();
    createFileOfPdfUrlAcc();
  }

  @override
  Widget build(BuildContext context) {

    idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '0';
    final auth = GetIt.I<AuthController>();
    final apiEntrega = ApiEntregaEpp();

    String urlExt = '';
    String urlApp = '';
    String arroba = '';
    String empresa = '';
    String fb_id = '';
    urlExt = auth.user.value!.urlExt;
    urlApp = auth.user.value!.urlApp;
    arroba = auth.user.value!.arroba;
    empresa = auth.user.value!.enterprise;
    fb_id = auth.user.value!.fbEmpleadoId;

    print("urlExt  --> $urlExt");
    print("urlApp --> $urlApp");
    print("arroba --> ${arroba}");
    print("empresa   --> $empresa");
    print("auth get id --> ${auth.getID}");
    print('fb_id ---> ${fb_id}');
    print("id sede --> ${idSede}");
    return Padding(
      padding: const EdgeInsets.all(6),
      child: InkWell(
        onTap: () {


          switch (widget.module.id) {
            case '1':
              Nav.go(context, INCPage()); //Incidentes
              break;
            case '2':
              Nav.go(context, AyCPage()); //Actos y condiciones seguras
              break;
            case '3':
              Nav.go(context, SACPage()); //Planes de accion
              break;
            case '12':
              Nav.go(context,OpsPage(ops_tipo_checklist_id: 4,));  //Lista de verificaciones
              break;
            case '4':

              Nav.go(
                context,
                WebViewPage(
                  params: WebViewParams(
                    title: 'Gráficos de incidentes',
                    initialUrl:
                    '${urlExt}safe2biz_home/Home_Plantilla.asp?Id_Home=10030&'
                        'Id_Unidad=${idSede}&'
                        'Id_Usuario=${auth.getID}&'
                        'EMPRESA=$empresa',
                  ),
                ),
              );

              break;
            case '5':
              Nav.go(
                context,
                WebViewPage(
                  params: WebViewParams(
                    title: 'Gráficos de rendimiento',
                    initialUrl:
                    '${urlExt}safe2biz_home/Home_Plantilla_Rendimiento.asp?Id_Home=10031'
                        '&Id_Unidad=${idSede}&'
                        'Id_Usuario=${auth.getID}&'
                        'EMPRESA=$empresa',
                    //webViewDashboard.loadUrl(usuario.getUrl_ext() + "/safe2biz_home/Home_Plantilla_Rendimiento.asp?Id_Home=10031&Id_Unidad="+usuario.getFb_uea_pe_id()+"&Id_Usuario="+usuario.getSc_user_id()+"&EMPRESA="+usuario.getEnterprise());
                  ),
                ),
              );
              break;
              //?? -----------
            case '6':
              Nav.go(context, ReporteIncidentes(path:  remotePDFpath , filename: filename, formattedDate: formattedDate, idSede: idSede)
          /*      WebViewPage(
                  params: WebViewParams(
                      title: 'Reporte de incidentes',
                      initialUrl:
                      'https://app.safe2biz.com/safe2biz_demo/externalReport/execute/safe2biz_demo/rpt_inc_informe_final_status_APP/PDF/id_sede=1%7Cid_usuario=18544/investigacion/'
                      'https://app.safe2biz.com/safe2biz_demo/externalReport/execute/safe2biz_demo/rpt_inc_informe_final_status_APP/PDF/id_sede=1%7Cid_usuario=18544/investigacion/'


                     /* 'https://docs.google.com/gview?embedded=true&url=${urlApp}externalReport/execute/${arroba}/rpt_inc_informe_final_status_APP/PDF/id_sede=${idSede}%7Cid_usuario=${auth
                          .getID}/investigacion/'
*/
                      //man. pdf
                    //https://docs.google.com/gview?embedded=true&url=https://app.safe2biz.com/safe2biz_demo/externalReport/execute/safe2biz_demo/rpt_inc_informe_final_status_APP/PDF/id_sede=1%7Cid_usuario=18544/investigacion/

                    //String url_pdf = usuario.getUrl_app()+"/externalReport/execute/"+usuario.getArroba()+"/rpt_inc_informe_final_status_APP/PDF/id_sede="+usuario.getFb_uea_pe_id()+"|id_usuario="+usuario.getSc_user_id()+"/investigacion/";
                  ),
                ),
                */

              );
              break;

            case '7':
              Nav.go(context, ReporteAcc(path: remotePDFpathAcc , filename: filenameAcc , formattedDate: formattedDateAcc, idSede: idSede));
              /*
              Nav.go(
                context,
                WebViewPage(
                  params: WebViewParams(
                    title: 'Reporte de plan de acción',
                    initialUrl:
                    'https://docs.google.com/gview?embedded=true&url=${urlApp}/externalReport/execute/$arroba/rpt_sac_informe_final_acciones_APP/PDF/id_sede=$idSede%7Cid_usuario=${auth.getID}/investigacion/',
                  ),
                ),
              );
               */
              break;
          //EPP
            case '8':
            //idSede
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          BottomNavLayout(

                            lazyLoadPages: true,

                            pages: [
                                  (_) => ListaPersonal(sede: idSede),
                                  (_) => EstadisticaEntrega(),
                              //  (_) => CalendarApp() ,
                            ],


                            bottomNavigationBar: (currentIndex, onTap) => BottomNavigationBar(

                              currentIndex: currentIndex,
                              onTap: (index) => onTap(index),
                              selectedItemColor: Colors.orange,
                              items: [
                                BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Lista'),
                                BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Estadisticas'),
                                // BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Calendario'),
                              ],
                            ),
                          )
                        )
                      );
              break;
            case '11':
              Nav.go(context, AYC_Bot(sede: idSede,)); //AUX
              break;

            case '13':
              Nav.go(context, EstadisticaSeguridad(sede: idSede, AYCY1: AYCY1, AYCY2: AYCY2, AYCY3: AYCY3, EntregaTipoy1: EntregaTipoy1, EntregaTipoy: EntregaTipoy ,) ).then((value) => setState((){})) ;  //AUX
              break;

            case '14':
              Nav.go(context, IndicadoresSeguridad(sede: idSede,) ); //AUX
              break;

            case '15':
              Nav.go(context, CapacitacionHome(sede: idSede,) ); //AUX
              break;

            case '17':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MiInformacion(shouldReset: true, sede: idSede, fb_empleado_id: '0',),
                ),
              );
//AUX
              break;

            case '18':
              Nav.go(context, DatosTrabajador(sede: idSede, fb_empleado_id: fb_id,) ); //AUX
              break;

            case '19':
              Nav.go(context, OpsPage(ops_tipo_checklist_id: 3,));   //Lista de verificaciones
              break;

          }
        },
        child: PhysicalModel(
          borderRadius: BorderRadius.circular(S2BRadius.xs),
          color: S2BColors.white,
          elevation: 5,
          child: Row(
            children:[
              Padding(
                padding: const EdgeInsets.all(S2BSpacing.sl),
                child: SizedBox(
                  width: 40.0,
                  child: ImageIcon(
                    AssetImage(widget.module.icon),
                    color: S2BColors.orange,
                    size: 24,
                  ),
                  height: 40.0,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextLabel.body(
                    widget.module.name,
                    fontWeight: FontWeight.w500,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<File> createFileOfPdfUrl() async {
  Completer<File> completer = Completer();
//  print("Start download file from internet!");

  var now = new DateTime.now();
  var formatter =  intl.DateFormat('yyyy-MM-dd');
  formattedDate = formatter.format(now);
  // print("empresa -- $idSede");
  // print("auth getid -- ${auth.getID} id usu ... ${getIdUser}");
  try {
    // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
    // final url = "https://pdfkit.org/docs/guide.pdf";
    final url = "https://app.safe2biz.com/safe2biz/externalReport/execute/safe2biz/rpt_inc_informe_final_status_APP/PDF/id_sede=${idSede}%7Cid_usuario=${auth.getID}/investigacion";
    filename = "ReporteInc-$formattedDate-${idSede}-${auth.getID}.pdf";
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    //  print("Download files");
    //  print("url --- ${dir.path}/$filename");
    File file = File("${dir.path}/$filename");

    remotePDFpath = '${dir.path}/$filename';

    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
  } catch (e) {
    throw Exception('Error parsing asset file!');
  }
  return completer.future;
}

Future<File> createFileOfPdfUrlAcc() async {
  Completer<File> completer = Completer();
  // print("Start download file from internet!");

  var now = new DateTime.now();
  var formatter =  intl.DateFormat('yyyy-MM-dd');
  formattedDateAcc = formatter.format(now);
  // print("empresa -- $idSede");
  // print("auth getid -- ${auth.getID} id usu ... ${getIdUser}");
  try {
    // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
    // final url = "https://pdfkit.org/docs/guide.pdf";
    final url = "https://app.safe2biz.com/safe2biz/externalReport/execute/safe2biz/rpt_sac_informe_final_acciones_APP/PDF/id_sede=${idSede}%7Cid_usuario=${auth.getID}/investigacion";
    filenameAcc = "ReporteAcc-$formattedDateAcc-${idSede}--${auth.getID}.pdf";
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    // print("Download files");
    // print("url --- ${dir.path}/$filenameAcc");
    File file = File("${dir.path}/$filenameAcc");
    remotePDFpathAcc = '${dir.path}/$filenameAcc';

    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
  } catch (e) {
    throw Exception('Error parsing asset file!');
  }
  return completer.future;
}



Future<List<IncidenteAccidente>> getIncidentesAccidentes() async {
  final db = await sqlite.database; // Asegúrate de obtener tu instancia de la base de datos aquí
  final List<Map<String, dynamic>> maps = await db.query(
      'INC_REGISTRO',
      orderBy: 'fecha_evento DESC' // Ordena los resultados por fecha_evento de manera descendente
  );

  // Convierte la List<Map<String, dynamic>> a una lista de IncidenteAccidente
  return List.generate(maps.length, (i) {
    return ConcreteIncidenteAccidente.fromMap(maps[i]);
  });

}
