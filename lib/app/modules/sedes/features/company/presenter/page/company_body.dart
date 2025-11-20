import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/register_acto_condicion/presenter/bloc/register_ayc_bloc.dart';
import 'package:safe2biz/app/modules/epp/external/api/entrega_epp_api.dart';
import 'package:safe2biz/app/modules/epp/external/database/database.dart';
import 'package:safe2biz/app/modules/epp/presenter/page/lista_entrega.dart';

import 'package:safe2biz/app/modules/planes_accion/data/models/plan_accion_model.dart';
import 'package:safe2biz/app/modules/sedes/features/company/domain/entities/entities.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/sedes/features/company/presenter/presenter.dart';
import 'package:safe2biz/app/modules/sedes/features/company/presenter/widgets/widgets.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/presenter/bloc/sincronizar_bloc.dart' as sync;
import 'package:safe2biz/app/modules/sedes/features/sincronizar/presenter/page/sincronizar_body.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/presenter/page/sincronizar_page.dart';
import 'package:safe2biz/app/modules/sedes/presenter/page/sede_page.dart';
import 'package:http/http.dart' as http;
import 'package:safe2biz/app/modules/epp/external/api/entrega_epp_api.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/register_acto_condicion/presenter/bloc/register_ayc_bloc.dart' as blo;

LocalSqlite sqlite = LocalSqlite();
final authController = AuthController(sqlite: sqlite);
bool _alreadySyncedSACGrisli = false;


final auth = GetIt.I<AuthController>();
final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '0';

class CompanyBody extends StatefulWidget {
  CompanyBody({Key? key}) : super(key: key);

  @override
  State<CompanyBody> createState() => _CompanyBodyState();
}

class _CompanyBodyState extends State<CompanyBody> {
  bool _isInitialized = false;


  List<ItemModule> _modules = <ItemModule>[];

  final _checkModuleINC = ValueNotifier<bool>(false);

  final _checkModuleAyC = ValueNotifier<bool>(false);

  final _checkModuleAC = ValueNotifier<bool>(false);

  final _checkModuleOPS = ValueNotifier<bool>(false);

  Widget? _completedExercises;



  @override
  void initState(){
    super.initState();
    asyncMethod();
    //_checkAndSyncFbEmpresaEspecializada(); // Verifica la tabla FB_EMPRESA_ESPECIALIZADA
   // getAllSACGrisli();
    print("sede --- ${idSede}");
  }

  void asyncMethod() async {
    SqlDb sqlDb = SqlDb();

    final db = await sqlite.database;

  }

  Future<void> _checkAndSyncFbEmpresaEspecializada() async {
    final sqlDb = SqlDb();
    try {
      // Realizamos una consulta que retorne un registro, si la tabla tiene datos
      final result = await sqlDb.readData(
          "SELECT 1 FROM ${LocalSqlite.TABLE_FB_EMPRESA_ESPECIALIZADA} LIMIT 1"
      );
      if (result.isEmpty) {
        print("La tabla ${LocalSqlite.TABLE_FB_EMPRESA_ESPECIALIZADA} está vacía. Ejecutando SincronizarPage().");
        await Nav.go(context, const SincronizarPage());
      } else {
        print("La tabla ${LocalSqlite.TABLE_FB_EMPRESA_ESPECIALIZADA} tiene datos.");
      }
    } catch (e) {
      print("Error al leer la tabla ${LocalSqlite.TABLE_FB_EMPRESA_ESPECIALIZADA}: $e");
      // Si ocurre un error, puedes decidir sincronizar o no.
      await Nav.go(context, const SincronizarPage());
    }
  }

  /* -- GRISLI
  Future<void> getAllSACGrisli() async {
    final user = await authController.getUserFromStorage();
    final url = '${user!.urlApp}/ws/null/pr_ws_accion_correctiva_por_codigo?codigo_emp=${auth.user.value!.code}';

    // Llamada al servicio
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "userLogin": "${user.userLogin}@${user.arroba}",
        "userPassword": "${user.password}",
        "systemRoot": "${user.enterprise}"
      },
    );

    // Logs para depurar
    print('URL de la petición: $url');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Decodificamos la respuesta y la mapeamos a nuestro modelo
      final data = json.decode(response.body)['data'] as List;
      final List<PlanesAccionModel> acciones = data
          .map((e) => PlanesAccionModel.fromJson(e))
          .toList();

      // Depuración: imprime cuántas acciones se recibieron
      print('Total de acciones recibidas: ${acciones.length}');


      // Obtenemos el id de sede actual y lo imprimimos para verificar
      final currentSedeId = LocalPreferences.prefs?.getString('current_sede_id') ?? '0';
      print('Valor de currentSedeId: $currentSedeId');

      // Filtramos solo las acciones cuya sede (fbUea) coincida con el id actual
      final List<PlanesAccionModel> accionesFiltradas = acciones
          .where((accion) => accion.ueaId == currentSedeId)
          .toList();

      print('Total de acciones filtradas: ${accionesFiltradas.length}');

      // Eliminamos datos previos e insertamos los registros filtrados
      print('Eliminando antiguos registros...');
      await sqlite.deleteAllSAC();

      print('Insertando registros filtrados...');
      await sqlite.createListaSAC(accionesFiltradas);

    } else {
      throw Exception('Failed to load actions');
    }
  }

  */


  List<String> _mapModuleToTables(String module) {
    final upperModule = module.toUpperCase();

    if (upperModule.contains('INC')) {
      // Módulo "INC"
      return [
        LocalSqlite.TABLE_INC_REGISTRO,
        LocalSqlite.TABLE_INC_TIPO_REPORTE,
        LocalSqlite.TABLE_INC_SUB_TIPO_REPORTE,
        LocalSqlite.TABLE_INC_DETALLE_PERDIDA,
        LocalSqlite.TABLE_INC_POTENCIAL_PERDIDA,
      ];
    } else if (upperModule.contains('AYC')) {
      // Módulo "AYC"
      return [
        LocalSqlite.TABLE_AYC_REGISTRO,
        LocalSqlite.TABLE_G_TIPO_CAUSA,
        LocalSqlite.TABLE_G_NIVEL_RIESGO,
        LocalSqlite.TABLE_ORIGEN_AYC,
        LocalSqlite.TABLE_TIPO_RIESGO_AYC,
        LocalSqlite.TABLE_AYC_EVIDENCIA,
        LocalSqlite.TABLE_AYC_REPORTANTE,
      ];
    } else if (upperModule.contains('SAC')) {
      // Módulo "SAC"
      return [
        LocalSqlite.TABLE_SAC_ACCION_CORRECTIVA,
        LocalSqlite.TABLE_SAC_ACCION_CORRECTIVA_GRISLI
      ];
    } else if (upperModule.contains('OPS')) {
      // Módulo "OPS"
      return [
        LocalSqlite.TABLE_OPS_REGISTRO_GENERALES,
        LocalSqlite.TABLE_OPS_REGISTRO_RESULTADO,
        LocalSqlite.TABLE_OPS_LISTA_VERIFICACION,
        LocalSqlite.TABLE_OPS_LISTA_VERIF_CATEGORIA,
        LocalSqlite.TABLE_OPS_LISTA_VERIF_SECCION,
        LocalSqlite.TABLE_OPS_LISTA_VERIF_PREGUNTA,
        LocalSqlite.TABLE_OPS_LISTA_VERIF_RESULTADO,
        LocalSqlite.TABLE_OPS_LISTA_TIPO_RESULTADO,
        LocalSqlite.TABLE_OPS_TURNOS,
      ];
    }
    // ... y así sucesivamente, para "PLAN_ACCION", "DAT", "SST", etc.

    // Si no coincide con nada, retornas lista vacía
    return [];
  }


  @override
  Widget build(BuildContext context) {

    final auth = GetIt.I<AuthController>();


    String url = "https://app.safe2biz.com/safe2biz/externalReport/execute/safe2biz/rpt_inc_informe_final_status_APP/PDF/id_sede=${idSede}%7Cid_usuario=${auth.getID}/investigacion";
    String urlAcc = "https://app.safe2biz.com/safe2biz/externalReport/execute/safe2biz/rpt_sac_informe_final_acciones_APP/PDF/id_sede=${idSede}%7Cid_usuario=${auth.getID}/investigacion";

    return WillPopScope(
      onWillPop: () async {
        Nav.go(context, SedePage());
        return false;
      },
      child: Scaffold(
        //drawer: const DrawerMenu(),
        backgroundColor: S2BColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff0A3987),
          title: Text("${LocalPreferences.prefs?.getString('current_sede') ?? '' }", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => SedePage(),
                ),
                    (route) => false,
              );
            },
            icon: Icon(Icons.arrow_back, color: Colors.white,),
          ),


          actions: [
        InkWell(
            onTap: (){
              Nav.go(
                context,
                const SincronizarPage(),
              );
            },
            child: Row(
              children: [
                Container(
                    height: 50,
                    child: Image.asset('assets/icons/cloud_sync.png')),
                SizedBox(width: 10,)
              ],
            ))
          ],
        ),


        body: BlocListener<CompanyBloc, CompanyState>(
          listener: (context, state) {
            if (state is blo.Loading) {
              LoadingInfo.show(
                context: context,
                message: 'Cargando...',
              );
            }
            if (state is blo.CloseLoading) {
              Nav.back(context);
            }
          },
          child: BlocBuilder<CompanyBloc, CompanyState>(
            builder: (context, state) {
              if (state is Successful) {
                _modules = state.modules;
              }
              return auth.getModulos().isEmpty
                  ? const EmptyData(
                title:
                'Ups!! parece que no tienes acceso\na ningún modulo en esta sede',
              )
                  : () {
                final newModules = _modules
                    .where(
                      (e) => auth.getModulos().contains(
                    e.prefix.name,
                  ),
                )
                    .toList();

                return ListView.builder(
                  itemCount: newModules.length,
                  itemBuilder: (context, i) => ItemCompanyModule(
                    module: newModules[i],
                  ),
                  padding: const EdgeInsets.all(S2BSpacing.sm),
                );
              }();
            },
          ),
        ),
      ),
    );
  }

  void download(BuildContext context) async {
    context.read<sync.SincronizarBloc>().add(
      sync.GetModulosEv(
        downloadAyC: _checkModuleAyC.value,
        downloadINC: _checkModuleINC.value,
        downloadAC: _checkModuleAC.value,
        downloadOPS: _checkModuleOPS.value,
      ),
    );
  }

/*
  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");

    var now = new DateTime.now();
    var formatter =  new intl.DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    print("empresa -- $idSede");
    print("auth getid -- ${auth.getID} id usu ... ${getIdUser}");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final url = "https://app.safe2biz.com/safe2biz_demo/externalReport/execute/safe2biz_demo/rpt_inc_informe_final_status_APP/PDF/id_sede=${idSede}%7Cid_usuario=${auth.getID}/investigacion";
      final filename = "ReporteInc-$formattedDate-${auth.getID}.pdf";
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("url --- ${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
    return completer.future;
  }
  Future<File> createFileOfPdfUrlAcc() async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");

    var now = new DateTime.now();
    var formatter =  intl.DateFormat('yyyy-MM-dd');
    formattedDateAcc = formatter.format(now);
    print("empresa -- $idSede");
    print("auth getid -- ${auth.getID} id usu ... ${getIdUser}");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final url = "https://app.safe2biz.com/safe2biz_demo/externalReport/execute/safe2biz_demo/rpt_sac_informe_final_acciones_APP/PDF/id_sede=${idSede}%7Cid_usuario=${auth.getID}/investigacion";
      final filenameAcc = "ReporteAcc-$formattedDateAcc-${auth.getID}.pdf";
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("url --- ${dir.path}/$filenameAcc");
      File file = File("${dir.path}/$filenameAcc");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
    return completer.future;
  }

  */

}
