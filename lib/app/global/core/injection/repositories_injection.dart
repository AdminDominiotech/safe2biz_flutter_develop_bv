import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/repositories/repositories.dart';
import 'package:safe2biz/app/modules/auth/features/login/external/local/local.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/data/repositories/lista_verificacion_local_repository_impl.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/data/repositories/lista_verificacion_repository_impl.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/external/external.dart';
import 'package:safe2biz/app/modules/planes_accion/data/repositories/repositories.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/actos_condiciones/external/external.dart';
import 'package:safe2biz/app/modules/planes_accion/external/external.dart';
import 'package:safe2biz/app/modules/auth/features/settings/data/implementations/implementations.dart';
import 'package:safe2biz/app/modules/auth/features/settings/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/auth/features/settings/external/local/local.dart';
import 'package:safe2biz/app/modules/incidente_accidente/data/repositories/repositories.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/incidente_accidente/external/api/api.dart';
import 'package:safe2biz/app/modules/incidente_accidente/external/local/local.dart';
import 'package:safe2biz/app/modules/sedes/data/repositories/repositories.dart';
import 'package:safe2biz/app/modules/auth/features/login/data/data.dart';
import 'package:safe2biz/app/modules/auth/features/login/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/auth/features/login/external/api/api.dart';
import 'package:safe2biz/app/modules/sedes/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/sedes/external/api/api.dart';
import 'package:safe2biz/app/modules/sedes/external/local/local.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/repositories/repositories.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/external/api/api.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/external/local/local.dart';
import 'package:safe2biz/app/modules/splash/data/repositories/repositories.dart';
import 'package:safe2biz/app/modules/splash/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/splash/external/local/local.dart';

final _i = GetIt.instance;

//TODO: INYECCION DE REPOSITORIOS
class RepositoriesInjection {
  static List<void> list = [
    // REPOSITORIES SPLASH
    _i.registerLazySingleton<SqliteRepository>(
      () => SqliteRepositoryImpl(remoteDatasource: _i.get<LocalSqliteApi>()),
    ),

    // REPOSITORIES LOGIN
    _i.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(remoteDatasource: _i.get<LoginApi>()),
    ),
    _i.registerLazySingleton<LoginLocalRepository>(
      () => LoginLocalRepositoryImpl(localDatasource: _i.get<LoginLocal>()),
    ),
    // REPOSITORIES COMPANY
    _i.registerLazySingleton<SedeApiRepository>(
      () => SedeApiRepositoryImpl(remoteDatasource: _i.get<SedeApi>()),
    ),
    _i.registerLazySingleton<SedeLocalRepository>(
      () => SedeLocalRepositoryImpl(remoteDatasource: _i.get<SedeLocal>()),
    ),
    // REPOSITORIES SINCRONIZACION
    _i.registerLazySingleton<SincronizarApiRepository>(
      () => SincronizarRepositoryImpl(
        remoteDatasource: _i.get<SincronizarApi>(),
      ),
    ),
    _i.registerLazySingleton<SincronizarLocalRepository>(
      () => SincronizarLocalRepositoryImpl(
        localDatasource: _i.get<SincronizarLocal>(),
      ),
    ),
    // REPOSITORIES AYC
    _i.registerLazySingleton<ActosCondicionesLocalRepository>(
      () => ActosCondicionesLocalRepositoryImpl(
        remoteDatasource: _i.get<ActosCondicionesLocal>(),
      ),
    ),
    _i.registerLazySingleton<ActosCondicionesApiRepository>(
      () => ActosCondicionesApiRepositoryImpl(
        remoteDatasource: _i.get<ActosCondicionesApi>(),
      ),
    ),

    // REPOSITORIES ACCIDENTE Y INCIDENTE
    _i.registerLazySingleton<IncidentesAccidentesLocalRepository>(
      () => IncidentesAccidentesLocalRepositoryImpl(
        localDatasource: _i.get<IncidentesAccidentesLocal>(),
      ),
    ),
    _i.registerLazySingleton<IncidentesAccidentesApiRepository>(
      () => IncidentesAccidentesApiRepositoryImpl(
        remoteDatasource: _i.get<IncidentesAccidentesApi>(),
      ),
    ),

    // REPOSITORIES PLANES ACCION (SAC)
    _i.registerLazySingleton<PlanesAccionLocalRepository>(
      () => PlanesAccionLocalRepositoryImpl(
        remoteDatasource: _i.get<PlanesAccionLocal>(),
      ),
    ),
    _i.registerLazySingleton<PlanesAccionApiRepository>(
      () => PlanesAccionApiRepositoryImpl(
        remoteDatasource: _i.get<PlanesAccionApi>(),
      ),
    ),
    // REPOSITORIES LISTA VERIFICACIÓN (OPS)
    _i.registerLazySingleton<ListaVerificacionLocalRepository>(
      () => ListaVerificacionLocalRepositoryImpl(
        remoteDatasource: _i.get<ListaVerificacionLocal>(),
      ),
    ),
    _i.registerLazySingleton<ListaVerificacionApiRepository>(
      () => ListaVerificacionApiRepositoryImpl(
        remoteDatasource: _i.get<ListaVerificacionApi>(),
      ),
    ),
    // REPOSITORIES SETTINGS
    _i.registerLazySingleton<SettingsLocalRepository>(
      () => SettingsLocalRepositoryImpl(
        localDatasource: _i.get<SettingsLocal>(),
      ),
    ),
  ];
}
