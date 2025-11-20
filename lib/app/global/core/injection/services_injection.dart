import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_connectivity/mobile_safe2bizapp_connectivity.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/modules/actos_condiciones/external/api/api.dart';
import 'package:safe2biz/app/modules/actos_condiciones/external/local/local.dart';

import 'package:safe2biz/app/modules/auth/features/login/external/api/api.dart';
import 'package:safe2biz/app/modules/auth/features/login/external/local/local.dart';
import 'package:safe2biz/app/modules/auth/features/settings/external/local/local.dart';
import 'package:safe2biz/app/modules/incidente_accidente/external/api/api.dart';
import 'package:safe2biz/app/modules/incidente_accidente/external/local/local.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/external/external.dart';
import 'package:safe2biz/app/modules/planes_accion/external/external.dart';
import 'package:safe2biz/app/modules/sedes/external/api/api.dart';
import 'package:safe2biz/app/modules/sedes/external/local/local.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/external/api/api.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/external/local/local.dart';
import 'package:safe2biz/app/modules/splash/external/local/local.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';

final _i = GetIt.instance;

//TODO: INYECCION DE SEVICIOS
class ServicesInjection {
  static List<void> list = [
    // SERVICES
    _i.registerLazySingleton<DioMicroServices>(() => DioMicroServices()),
    _i.registerLazySingleton<LocalSqlite>(() => LocalSqlite()),
    _i.registerLazySingleton<ConnectivityStatus>(() => ConnectivityStatus()),
    // SERVICES SPLASH
    _i.registerLazySingleton<LocalSqliteApi>(
      () => LocalSqliteApi(sqlite: _i.get<LocalSqlite>()),
    ),

    // SERVICES LOGIN
    _i.registerLazySingleton<LoginApi>(
      () => LoginApi(dioMicroServices: _i.get<DioMicroServices>()),
    ),
    _i.registerLazySingleton<LoginLocal>(
      () => LoginLocal(sqlite: _i.get<LocalSqlite>()),
    ),
    // SERVICES SINCRONIZACION
    _i.registerLazySingleton<SincronizarApi>(
      () => SincronizarApi(dioMicroServices: _i.get<DioMicroServices>()),
    ),
    _i.registerLazySingleton<SincronizarLocal>(
      () => SincronizarLocal(sqlite: _i.get<LocalSqlite>()),
    ),

    // SERVICES COMPANY
    _i.registerLazySingleton<SedeApi>(
      () => SedeApi(dioMicroServices: _i.get<DioMicroServices>()),
    ),
    _i.registerLazySingleton<SedeLocal>(
      () => SedeLocal(sqlite: _i.get<LocalSqlite>()),
    ),

    // SERVICES ACTOS Y CONDICIONES
    _i.registerLazySingleton<ActosCondicionesLocal>(
      () => ActosCondicionesLocal(sqlite: _i.get<LocalSqlite>()),
    ),
    _i.registerLazySingleton<ActosCondicionesApi>(
      () => ActosCondicionesApi(dioMicroServices: _i.get<DioMicroServices>()),
    ),
    // SERVICES INCIDENTE Y ACCIDENTE
    _i.registerLazySingleton<IncidentesAccidentesLocal>(
      () => IncidentesAccidentesLocal(sqlite: _i.get<LocalSqlite>()),
    ),
    _i.registerLazySingleton<IncidentesAccidentesApi>(
      () =>
          IncidentesAccidentesApi(dioMicroServices: _i.get<DioMicroServices>()),
    ),
    // SERVICES PLANES ACCION
    _i.registerLazySingleton<PlanesAccionLocal>(
      () => PlanesAccionLocal(sqlite: _i.get<LocalSqlite>()),
    ),
    _i.registerLazySingleton<PlanesAccionApi>(
      () => PlanesAccionApi(dioMicroServices: _i.get<DioMicroServices>()),
    ),
    // SERVICES LISTA VERIFICACION
    _i.registerLazySingleton<ListaVerificacionLocal>(
      () => ListaVerificacionLocal(sqlite: _i.get<LocalSqlite>()),
    ),
    _i.registerLazySingleton<ListaVerificacionApi>(
      () => ListaVerificacionApi(dioMicroServices: _i.get<DioMicroServices>()),
    ),
    // SERVICES SETTINGS
    _i.registerLazySingleton<SettingsLocal>(
      () => SettingsLocal(sqlite: _i.get<LocalSqlite>()),
    ),
  ];
}
