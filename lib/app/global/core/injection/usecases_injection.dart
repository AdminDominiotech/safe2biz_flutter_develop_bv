import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/auth/features/login/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/auth/features/login/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/auth/features/settings/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/auth/features/settings/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/sedes/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/sedes/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

final _i = GetIt.instance;

//TODO: INYECCION DE CASOS DE USOS
class UseCasesInjection {
  static List<void> list = [
    // USECASES
    // SPLASH
    // _i.registerLazySingleton<LocalLoginUcImpl>(
    //   () => LocalLoginUcImpl(sqliteRepository: _i.get<SqliteRepository>()),
    // ),
    // _i.registerLazySingleton<HasSessionUcImpl>(
    //   () => HasSessionUcImpl(sqliteRepository: _i.get<SqliteRepository>()),
    // ),
    // _i.registerLazySingleton<LocalLogoutUcImpl>(
    //   () => LocalLogoutUcImpl(sqliteRepository: _i.get<SqliteRepository>()),
    // ),

    // LOGIN
    _i.registerLazySingleton<LoginCheckUcImpl>(
      () => LoginCheckUcImpl(loginRepository: _i.get<LoginRepository>()),
    ),
    _i.registerLazySingleton<GetAccesosLocalUcImpl>(
      () => GetAccesosLocalUcImpl(local: _i.get<LoginLocalRepository>()),
    ),
    _i.registerLazySingleton<SaveAccesosLocalUcImpl>(
      () => SaveAccesosLocalUcImpl(local: _i.get<LoginLocalRepository>()),
    ),
    // COMPANY
    _i.registerLazySingleton<GetSedesUcImpl>(
      () => GetSedesUcImpl(repository: _i.get<SedeApiRepository>()),
    ),
    _i.registerLazySingleton<GetSedesLocalUcImpl>(
      () => GetSedesLocalUcImpl(
        repository: _i.get<SedeLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveSedesLocalUcImpl>(
      () => SaveSedesLocalUcImpl(
        repository: _i.get<SedeLocalRepository>(),
      ),
    ),

    // SINCRONIZACION
    _i.registerLazySingleton<GetEmpleadosUcImpl>(
      () => GetEmpleadosUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetDesviacionesUcImpl>(
      () => GetDesviacionesUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetGerenciasUcImpl>(
      () => GetGerenciasUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetAreasUcImpl>(
      () => GetAreasUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetTipoEventosUcImpl>(
      () => GetTipoEventosUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetNivelesRiesgosUcImpl>(
      () => GetNivelesRiesgosUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetEmpresasEspUcImpl>(
      () => GetEmpresasEspUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetTipoReportesUcImpl>(
      () => GetTipoReportesUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetSubTipoReportesUcImpl>(
      () => GetSubTipoReportesUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetDetallesPerdidasUcImpl>(
      () => GetDetallesPerdidasUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetPotencialesPerdidasUcImpl>(
      () => GetPotencialesPerdidasUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetSeccionesOpsUcImpl>(
      () => GetSeccionesOpsUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetCategoriasOpsUcImpl>(
      () => GetCategoriasOpsUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetPreguntasOpsUcImpl>(
      () => GetPreguntasOpsUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetTurnoOpsUcImpl>(
      () => GetTurnoOpsUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetVerificacionesOpsUcImpl>(
      () => GetVerificacionesOpsUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetSacUcImpl>(
      () => GetSacUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetResultadosOpsUcImpl>(
      () => GetResultadosOpsUcImpl(
        repository: _i.get<SincronizarApiRepository>(),
      ),
    ),

    // SINCRONIZAR LOCAL
    _i.registerLazySingleton<SaveAreasLocalUcImpl>(
      () => SaveAreasLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveDesviacionesLocalUcImpl>(
      () => SaveDesviacionesLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveEmpresasEspLocalUcImpl>(
      () => SaveEmpresasEspLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveGerenciasLocalUcImpl>(
      () => SaveGerenciasLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveTipoEventosLocalUcImpl>(
      () => SaveTipoEventosLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveEmpleadosLocalUcImpl>(
      () => SaveEmpleadosLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveNivelRiesgosLocalUcImpl>(
      () => SaveNivelRiesgosLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveTipoReportesLocalUcImpl>(
      () => SaveTipoReportesLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveSubTipoReportesLocalUcImpl>(
      () => SaveSubTipoReportesLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveDetallesPerdidasLocalUcImpl>(
      () => SaveDetallesPerdidasLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SavePotencialesPerdidasLocalUcImpl>(
      () => SavePotencialesPerdidasLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),

    _i.registerLazySingleton<SaveSacLocalUcImpl>(
      () => SaveSacLocalUcImpl(
        repository: _i.get<SincronizarLocalRepository>(),
      ),
    ),

    _i.registerLazySingleton<SaveVerificacionesOpsLocalUcImpl>(
      () => SaveVerificacionesOpsLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveCategoriasOpsLocalUcImpl>(
      () => SaveCategoriasOpsLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveSeccionesOpsLocalUcImpl>(
      () => SaveSeccionesOpsLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SavePreguntasOpsLocalUcImpl>(
      () => SavePreguntasOpsLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),

    _i.registerLazySingleton<SaveTurnosOpsLocalUcImpl>(
      () => SaveTurnosOpsLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveResultadosOpsLocalUcImpl>(
      () => SaveResultadosOpsLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),

    // SINCRONIZAR LISTA LOCAL
    _i.registerLazySingleton<GetAreasLocalUcImpl>(
      () => GetAreasLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetEmpleadosLocalUcImpl>(
      () => GetEmpleadosLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetDesviacionesLocalUcImpl>(
      () => GetDesviacionesLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetGerenciasLocalUcImpl>(
      () => GetGerenciasLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetEmpresasEspLocalUcImpl>(
      () => GetEmpresasEspLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetTipoEventosLocalUcImpl>(
      () => GetTipoEventosLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetNivelesRiesgosLocalUcImpl>(
      () => GetNivelesRiesgosLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetTipoReportesLocalUcImpl>(
      () => GetTipoReportesLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetSubTipoReportesLocalUcImpl>(
      () => GetSubTipoReportesLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetDetallesPerdidasLocalUcImpl>(
      () => GetDetallesPerdidasLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetPotencialesPerdidasLocalUcImpl>(
      () => GetPotencialesPerdidasLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetSacLocalUcImpl>(
      () => GetSacLocalUcImpl(
        repository: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetVerificacionesOpsLocalUcImpl>(
      () => GetVerificacionesOpsLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetCategoriasOpsLocalUcImpl>(
      () => GetCategoriasOpsLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetSeccionesOpsLocalUcImpl>(
      () => GetSeccionesOpsLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetPreguntasOpsLocalUcImpl>(
      () => GetPreguntasOpsLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),

    _i.registerLazySingleton<GetTurnosOpsLocalUcImpl>(
      () => GetTurnosOpsLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetResultadosOpsLocalUcImpl>(
      () => GetResultadosOpsLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<UpdatePreguntasByRegistroGeneralOpsLocalUcImpl>(
      () => UpdatePreguntasByRegistroGeneralOpsLocalUcImpl(
        local: _i.get<SincronizarLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetRegistrarResultadoStorageUcImpl>(
      () => GetRegistrarResultadoStorageUcImpl(
        local: _i.get<ListaVerificacionLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetRegistrarResultadoByIdGeneralStorageUcImpl>(
      () => GetRegistrarResultadoByIdGeneralStorageUcImpl(
        local: _i.get<ListaVerificacionLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<EditRegistrarResultadoStorageUcImpl>(
      () => EditRegistrarResultadoStorageUcImpl(
        local: _i.get<ListaVerificacionLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<EditStatusRegistroGeneralStorageUcImpl>(
      () => EditStatusRegistroGeneralStorageUcImpl(
        local: _i.get<ListaVerificacionLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<EditStatusRegistroResultadoStorageUcImpl>(
      () => EditStatusRegistroResultadoStorageUcImpl(
        local: _i.get<ListaVerificacionLocalRepository>(),
      ),
    ),

    // ACTOS Y CONDICIONES
    _i.registerLazySingleton<GetActosCondicionesStorageUcImpl>(
      () => GetActosCondicionesStorageUcImpl(
        repository: _i.get<ActosCondicionesLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveActoCondicionStorageUcImpl>(
      () => SaveActoCondicionStorageUcImpl(
        repository: _i.get<ActosCondicionesLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<DeleteAllActosCondicionesStorageUcImpl>(
      () => DeleteAllActosCondicionesStorageUcImpl(
        repository: _i.get<ActosCondicionesLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetActoCondicionStorageUcImpl>(
      () => GetActoCondicionStorageUcImpl(
        repository: _i.get<ActosCondicionesLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<EditActoCondicionStorageUcImpl>(
      () => EditActoCondicionStorageUcImpl(
        repository: _i.get<ActosCondicionesLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveActoCondicionUcImpl>(
      () => SaveActoCondicionUcImpl(
        repository: _i.get<ActosCondicionesApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<EditStatusActoCondicionStorageUcImpl>(
      () => EditStatusActoCondicionStorageUcImpl(
        repository: _i.get<ActosCondicionesLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<DeleteActoCondicionStorageUcImpl>(
      () => DeleteActoCondicionStorageUcImpl(
        local: _i.get<ActosCondicionesLocalRepository>(),
      ),
    ),

    // INCIDENTE Y ACCIDENTE
    _i.registerLazySingleton<SaveIncidenteAccidenteUcImpl>(
      () => SaveIncidenteAccidenteUcImpl(
        repository: _i.get<IncidentesAccidentesApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetIncidentesAccidentesStorageUcImpl>(
      () => GetIncidentesAccidentesStorageUcImpl(
        local: _i.get<IncidentesAccidentesLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<DeleteIncidenteAccidenteStorageUcImpl>(
      () => DeleteIncidenteAccidenteStorageUcImpl(
        local: _i.get<IncidentesAccidentesLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<EditStatusIncidenteAccidenteStorageUcImpl>(
      () => EditStatusIncidenteAccidenteStorageUcImpl(
        local: _i.get<IncidentesAccidentesLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveIncidenteAccidenteStorageUcImpl>(
      () => SaveIncidenteAccidenteStorageUcImpl(
        local: _i.get<IncidentesAccidentesLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<EditIncidenteAccidenteStorageUcImpl>(
      () => EditIncidenteAccidenteStorageUcImpl(
        local: _i.get<IncidentesAccidentesLocalRepository>(),
      ),
    ),
    //PLANES DE ACCIÓN
    _i.registerLazySingleton<GetPlanesAccionStorageUcImpl>(
      () => GetPlanesAccionStorageUcImpl(
        repository: _i.get<PlanesAccionLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<EditPlanAccionStorageUcImpl>(
      () => EditPlanAccionStorageUcImpl(
        repository: _i.get<PlanesAccionLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<EditStatusPlanAccionStorageUcImpl>(
      () => EditStatusPlanAccionStorageUcImpl(
        repository: _i.get<PlanesAccionLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<DeletePlanAccionStorageUcImpl>(
      () => DeletePlanAccionStorageUcImpl(
        local: _i.get<PlanesAccionLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<DeleteAllPlanesAccionStorageUcImpl>(
      () => DeleteAllPlanesAccionStorageUcImpl(
        repository: _i.get<PlanesAccionLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SavePlanAccionUcImpl>(
      () => SavePlanAccionUcImpl(
        repository: _i.get<PlanesAccionApiRepository>(),
      ),
    ),
    // LISTAS VERIFICACION
    _i.registerLazySingleton<EditListaVerificacionStorageUcImpl>(
      () => EditListaVerificacionStorageUcImpl(
        repository: _i.get<ListaVerificacionLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveListaVerificacionStorageUcImpl>(
      () => SaveListaVerificacionStorageUcImpl(
        repository: _i.get<ListaVerificacionLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetListaVerificacionStorageUcImpl>(
      () => GetListaVerificacionStorageUcImpl(
        repository: _i.get<ListaVerificacionLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveRegistrarResultadoStorageUcImpl>(
      () => SaveRegistrarResultadoStorageUcImpl(
        repository: _i.get<ListaVerificacionLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveRegistroResultadoUcImpl>(
      () => SaveRegistroResultadoUcImpl(
        repository: _i.get<ListaVerificacionApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<SaveRegistrosGeneralesUcImpl>(
      () => SaveRegistrosGeneralesUcImpl(
        repository: _i.get<ListaVerificacionApiRepository>(),
      ),
    ),
    _i.registerLazySingleton<DeleteRegistroResultadoStorageUcImpl>(
      () => DeleteRegistroResultadoStorageUcImpl(
        local: _i.get<ListaVerificacionLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<DeleteRegistroGeneralStorageUcImpl>(
      () => DeleteRegistroGeneralStorageUcImpl(
        local: _i.get<ListaVerificacionLocalRepository>(),
      ),
    ),
    // SETTINGS
    _i.registerLazySingleton<SaveSettigLocalUcImpl>(
      () => SaveSettigLocalUcImpl(
        repository: _i.get<SettingsLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<GetSettigLocalUcImpl>(
      () => GetSettigLocalUcImpl(
        repository: _i.get<SettingsLocalRepository>(),
      ),
    ),
    _i.registerLazySingleton<DeleteSettigLocalUcImpl>(
      () => DeleteSettigLocalUcImpl(
        repository: _i.get<SettingsLocalRepository>(),
      ),
    ),
  ];
}
