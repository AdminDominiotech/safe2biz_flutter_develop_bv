import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

part 'sincronizar_event.dart';
part 'sincronizar_state.dart';

typedef SincronizarEmitter = Emitter<SincronizarState>;


class SincronizarBloc extends Bloc<SincronizarEvent, SincronizarState> {
  SincronizarBloc({
    required GetEmpleadosUcImpl getEmpleadosUc,
    required GetDesviacionesUcImpl getDesviacionesUc,
    required GetGerenciasUcImpl getGerenciasUc,
    required GetAreasUcImpl getAreasUc,
    required GetTipoEventosUcImpl getTipoEventosUc,
    required GetNivelesRiesgosUcImpl getNivelesRiesgosUc,
    required GetEmpresasEspUcImpl getEmpresasEspUc,
    required GetTipoReportesUcImpl getTipoReportesUc,
    required GetSubTipoReportesUcImpl getSubTipoReportesUc,
    required GetDetallesPerdidasUcImpl getDetallesPerdidasUc,
    required GetPotencialesPerdidasUcImpl getPotencialesPerdidasUc,
    required GetVerificacionesOpsUcImpl getVerificacionesOpsUc,
    required GetSeccionesOpsUcImpl getSeccionesOpsUc,
    required GetPreguntasOpsUcImpl getPreguntasOpsUc,
    required GetTurnoOpsUcImpl getTurnoOpsUc,
    required GetCategoriasOpsUcImpl getCategoriasOpsUc,
    required SaveAreasLocalUcImpl saveAreasLocalUc,
    required SaveEmpleadosLocalUcImpl saveEmpleadosLocalUc,
    required SaveNivelRiesgosLocalUcImpl saveNivelRiesgosUc,
    required SaveGerenciasLocalUcImpl saveGerenciasLocalUc,
    required SaveEmpresasEspLocalUcImpl saveEmpresasEspLocalUc,
    required SaveDesviacionesLocalUcImpl saveDesviacionesLocalUc,
    required SaveTipoEventosLocalUcImpl saveTipoEventosLocalUc,
    required SaveTipoReportesLocalUcImpl saveTipoReportesLocalUc,
    required SaveSubTipoReportesLocalUcImpl saveSubTipoReportesLocalUc,
    required SaveDetallesPerdidasLocalUcImpl saveDetallesPerdidasLocalUc,
    required SavePotencialesPerdidasLocalUcImpl savePotencialesPerdidasLocalUc,
    required GetNivelesRiesgosLocalUcImpl getNivelesRiesgosLocalUc,
    required GetSacUcImpl getSacUc,
    required GetResultadosOpsUcImpl getResultadosOpsUc,
    required SaveSacLocalUcImpl saveSacLocalUc,
    required SaveCategoriasOpsLocalUcImpl saveCategoriasOpsLocalUc,
    required SaveSeccionesOpsLocalUcImpl saveSeccionesOpsLocalUc,
    required SavePreguntasOpsLocalUcImpl savePreguntasOpsLocalUc,
    required SaveVerificacionesOpsLocalUcImpl saveVerificacionesOpsLocalUc,
    required SaveTurnosOpsLocalUcImpl saveTurnosOpsLocalUc,
    required SaveResultadosOpsLocalUcImpl saveResultadosOpsLocalUc,
    required AuthController authController,
  })  : _getEmpleadosUc = getEmpleadosUc,
        _getDesviacionesUc = getDesviacionesUc,
        _getGerenciasUc = getGerenciasUc,
        _getAreasUc = getAreasUc,
        _getTipoEventosUc = getTipoEventosUc,
        _getNivelesRiesgosUc = getNivelesRiesgosUc,
        _getEmpresasEspUc = getEmpresasEspUc,
        _getTipoReportesUc = getTipoReportesUc,
        _getSubTipoReportesUc = getSubTipoReportesUc,
        _getDetallesPerdidasUc = getDetallesPerdidasUc,
        _getPotencialesPerdidasUc = getPotencialesPerdidasUc,
        _getVerificacionesOpsUc = getVerificacionesOpsUc,
        _getSeccionesOpsUc = getSeccionesOpsUc,
        _getPreguntasOpsUc = getPreguntasOpsUc,
        _getTurnoOpsUc = getTurnoOpsUc,
        _getCategoriasOpsUc = getCategoriasOpsUc,
        _getResultadosOpsUc = getResultadosOpsUc,
        _saveAreasLocalUc = saveAreasLocalUc,
        _saveNivelRiesgosUc = saveNivelRiesgosUc,
        _saveGerenciasLocalUc = saveGerenciasLocalUc,
        _saveEmpleadosLocalUc = saveEmpleadosLocalUc,
        _saveEmpresasEspLocalUc = saveEmpresasEspLocalUc,
        _saveTipoEventosLocalUc = saveTipoEventosLocalUc,
        _saveDesviacionesLocalUc = saveDesviacionesLocalUc,
        _saveTipoReportesLocalUc = saveTipoReportesLocalUc,
        _saveSubTipoReportesLocalUc = saveSubTipoReportesLocalUc,
        _saveDetallesPerdidasLocalUc = saveDetallesPerdidasLocalUc,
        _savePotencialesPerdidasLocalUc = savePotencialesPerdidasLocalUc,
        _saveCategoriasOpsLocalUc = saveCategoriasOpsLocalUc,
        _saveSeccionesOpsLocalUc = saveSeccionesOpsLocalUc,
        _savePreguntasOpsLocalUc = savePreguntasOpsLocalUc,
        _saveVerificacionesOpsLocalUc = saveVerificacionesOpsLocalUc,
        _saveTurnosOpsLocalUc = saveTurnosOpsLocalUc,
        _saveResultadosOpsLocalUc = saveResultadosOpsLocalUc,
        _getSacUc = getSacUc,
        _saveSacLocalUc = saveSacLocalUc,
        _authController = authController,
        super(Init()) {
    on<InitEv>(_onInitEv);
    on<GetModulosEv>(_onGetModulosEv);
  }

  final GetEmpleadosUcImpl _getEmpleadosUc;
  final GetDesviacionesUcImpl _getDesviacionesUc;
  final GetGerenciasUcImpl _getGerenciasUc;
  final GetAreasUcImpl _getAreasUc;
  final GetTipoEventosUcImpl _getTipoEventosUc;
  final GetNivelesRiesgosUcImpl _getNivelesRiesgosUc;
  final GetEmpresasEspUcImpl _getEmpresasEspUc;
  final GetTipoReportesUcImpl _getTipoReportesUc;
  final GetSubTipoReportesUcImpl _getSubTipoReportesUc;
  final GetDetallesPerdidasUcImpl _getDetallesPerdidasUc;
  final GetPotencialesPerdidasUcImpl _getPotencialesPerdidasUc;
  final GetVerificacionesOpsUcImpl _getVerificacionesOpsUc;
  final GetSeccionesOpsUcImpl _getSeccionesOpsUc;
  final GetPreguntasOpsUcImpl _getPreguntasOpsUc;
  final GetTurnoOpsUcImpl _getTurnoOpsUc;
  final GetCategoriasOpsUcImpl _getCategoriasOpsUc;
  final GetSacUcImpl _getSacUc;
  final GetResultadosOpsUcImpl _getResultadosOpsUc;
  final SaveAreasLocalUcImpl _saveAreasLocalUc;
  final SaveEmpleadosLocalUcImpl _saveEmpleadosLocalUc;
  final SaveNivelRiesgosLocalUcImpl _saveNivelRiesgosUc;
  final SaveGerenciasLocalUcImpl _saveGerenciasLocalUc;
  final SaveEmpresasEspLocalUcImpl _saveEmpresasEspLocalUc;
  final SaveDesviacionesLocalUcImpl _saveDesviacionesLocalUc;
  final SaveTipoEventosLocalUcImpl _saveTipoEventosLocalUc;
  final SaveTipoReportesLocalUcImpl _saveTipoReportesLocalUc;
  final SaveSubTipoReportesLocalUcImpl _saveSubTipoReportesLocalUc;
  final SaveDetallesPerdidasLocalUcImpl _saveDetallesPerdidasLocalUc;
  final SavePotencialesPerdidasLocalUcImpl _savePotencialesPerdidasLocalUc;
  final SaveCategoriasOpsLocalUcImpl _saveCategoriasOpsLocalUc;
  final SaveSeccionesOpsLocalUcImpl _saveSeccionesOpsLocalUc;
  final SavePreguntasOpsLocalUcImpl _savePreguntasOpsLocalUc;
  final SaveVerificacionesOpsLocalUcImpl _saveVerificacionesOpsLocalUc;
  final SaveTurnosOpsLocalUcImpl _saveTurnosOpsLocalUc;
  final SaveSacLocalUcImpl _saveSacLocalUc;
  final SaveResultadosOpsLocalUcImpl _saveResultadosOpsLocalUc;
  final AuthController _authController;

  int _totalProcess = 0;
  int _totalDownload = 18;

  Future<void> _onInitEv(InitEv ev, SincronizarEmitter emit) async {
    emit(Loading());
    // final result2 = await _getSubTipoReportesUc();
    // result2.fold((l) => print(l), (r) => print(r));
    // final result3 = await _getDetallesPerdidasUc();
    // result3.fold((l) => print(l), (r) => print(r));
    // final result4 = await _getPotencialesPerdidasUc();
    // result4.fold((l) => print(l), (r) => print(r));

    emit(Loaded());
  }

  Future<void> _onGetModulosEv(
    GetModulosEv ev,
    SincronizarEmitter emit,
  ) async {
    _totalProcess = 0;
    emit(DownloadingModulos());
    // log('entro 1');
    // if (ev.downloadAyC) {
    //   log('entro 2');
    await _getModuloAyC();
    //   log('entro 3');
    // }
    // log('entro 4');
    // if (ev.downloadINC) {
    //   log('entro 5');
    await _getModuloINC();
    //   log('entro 6');
    // }



    await Future.delayed(const Duration(seconds: 2));

    emit(CloseLoading());
    emit(DownloadedModulos(total: _totalDownload, completed: _totalProcess));

  }

  Future<void> _getModuloAyC() async {
    final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';
    final idUser = _authController.user.value?.fbEmpleadoId;

    final failureOrDesviaciones = await _getDesviacionesUc();
    final failureOrGerencias = await _getGerenciasUc();
    final failureOrAreas = await _getAreasUc();
    final failureOrTipoEventos = await _getTipoEventosUc();
    final failureOrNivelRiesgos = await _getNivelesRiesgosUc();
    final failureOrEmpresasEsp = await _getEmpresasEspUc();
    final failureOrEmpleados = await _getEmpleadosUc(_authController.getID);
    final failureOrSac = await _getSacUc(idSede, idUser!);

    final resultAreas =
        failureOrAreas.fold((failure) => failure, (areas) => areas);

    if (resultAreas is! Failure) {
      final areas = resultAreas as List<Area>;
      await _saveAreasLocalUc(areas);
      _totalProcess = _totalProcess + 1;
    }

    final resultGerencias =
        failureOrGerencias.fold((failure) => failure, (gerencias) => gerencias);

    if (resultGerencias is! Failure) {
      final gerencias = resultGerencias as List<Gerencia>;
      await _saveGerenciasLocalUc(gerencias);
      _totalProcess = _totalProcess + 1;
    }

    final resultEmpresasEsp =
        failureOrEmpresasEsp.fold((failure) => failure, (empresas) => empresas);

    if (resultEmpresasEsp is! Failure) {
      final empresas = resultEmpresasEsp as List<EmpresaEsp>;

      await _saveEmpresasEspLocalUc(empresas);
      _totalProcess = _totalProcess + 1;
    }

    final resultDesviaciones = failureOrDesviaciones.fold(
        (failure) => failure, (gerencias) => gerencias);

    if (resultDesviaciones is! Failure) {
      final desviaciones = resultDesviaciones as List<Desviacion>;
      await _saveDesviacionesLocalUc(desviaciones);
      _totalProcess = _totalProcess + 1;
    }

    final resultEmpleados =
        failureOrEmpleados.fold((failure) => failure, (empleados) => empleados);

    if (resultEmpleados is! Failure) {
      final empleados = resultEmpleados as List<Empleado>;
      await _saveEmpleadosLocalUc(empleados);
      _totalProcess = _totalProcess + 1;
    }

    final resultTipoEventos = failureOrTipoEventos.fold(
        (failure) => failure, (tipoeventos) => tipoeventos);

    if (resultTipoEventos is! Failure) {
      final tipoEventos = resultTipoEventos as List<TipoEvento>;
      await _saveTipoEventosLocalUc(tipoEventos);
      _totalProcess = _totalProcess + 1;
    }

    final resultNivelesRiesgos = failureOrNivelRiesgos.fold(
        (failure) => failure, (nivelesriesgos) => nivelesriesgos);

    if (resultNivelesRiesgos is! Failure) {
      final nivelesRiesgos = resultNivelesRiesgos as List<NivelRiesgo>;
      await _saveNivelRiesgosUc(nivelesRiesgos);
      _totalProcess = _totalProcess + 1;
    }

    final resultSac =
        failureOrSac.fold((failure) => failure, (sacList) => sacList);

    if (resultSac is! Failure) {
      final sacList = resultSac as List<PlanAccion>;
      await _saveSacLocalUc(sacList, idSede);
      _totalProcess = _totalProcess + 1;
    }
  }

  Future<void> _getModuloINC() async {
    final failureOrTipoReportes = await _getTipoReportesUc();
    final failureOrSubTipoReportes = await _getSubTipoReportesUc();
    final failureOrDetalles = await _getDetallesPerdidasUc();
    final failureOrPotenciales = await _getPotencialesPerdidasUc();
    final userLogin = _authController.user.value != null
        ? _authController.user.value!.userLogin
        : '';
    // TODO: CONSULTAR DONDE SE DEBE PONER PARA DESCARGAR ESTAS LISTAS
    final failureOrVerificaciones = await _getVerificacionesOpsUc(userLogin);
    final failureOrSecciones = await _getSeccionesOpsUc(userLogin);
    final failureOrPreguntas = await _getPreguntasOpsUc(userLogin);
    final failureOrCategorias = await _getCategoriasOpsUc(userLogin);
    final failureOrTurnos = await _getTurnoOpsUc();
    final failureOrResultados = await _getResultadosOpsUc();

    final resultTipoReportes =
        failureOrTipoReportes.fold((failure) => failure, (areas) => areas);

    if (resultTipoReportes is! Failure) {
      final tiposReportes = resultTipoReportes as List<TipoReporte>;
      await _saveTipoReportesLocalUc(tiposReportes);
      _totalProcess = _totalProcess + 1;
    }

    final resultSubTipoReportes = failureOrSubTipoReportes.fold(
        (failure) => failure, (gerencias) => gerencias);

    if (resultSubTipoReportes is! Failure) {
      final subTipoReportes = resultSubTipoReportes as List<SubTipoReporte>;
      await _saveSubTipoReportesLocalUc(subTipoReportes);
      _totalProcess = _totalProcess + 1;
    }

    final resultDetalles = failureOrDetalles.fold(
        (failure) => failure, (detallePerdidas) => detallePerdidas);

    if (resultDetalles is! Failure) {
      final detalles = resultDetalles as List<DetallePerdida>;

      await _saveDetallesPerdidasLocalUc(detalles);
      _totalProcess = _totalProcess + 1;
    }

    final resultPotenciales = failureOrPotenciales.fold(
        (failure) => failure, (potencialPerdidas) => potencialPerdidas);

    if (resultPotenciales is! Failure) {
      final potenciales = resultPotenciales as List<PotencialPerdida>;
      await _savePotencialesPerdidasLocalUc(potenciales);
      _totalProcess = _totalProcess + 1;
    }

    final resultSecciones =
        failureOrSecciones.fold((failure) => failure, (secciones) => secciones);

    if (resultSecciones is! Failure) {
      final secciones = resultSecciones as List<SeccionOps>;
      await _saveSeccionesOpsLocalUc(secciones);
      _totalProcess = _totalProcess + 1;
    }

    final resultPreguntas =
        failureOrPreguntas.fold((failure) => failure, (preguntas) => preguntas);

    if (resultPreguntas is! Failure) {
      final preguntas = resultPreguntas as List<PreguntaOps>;
      await _savePreguntasOpsLocalUc(preguntas);
      _totalProcess = _totalProcess + 1;
    }

    final resultVerificaciones = failureOrVerificaciones.fold(
        (failure) => failure, (verificaciones) => verificaciones);

    if (resultVerificaciones is! Failure) {
      final verificaciones = resultVerificaciones as List<VerificacionOps>;
      await _saveVerificacionesOpsLocalUc(verificaciones);
      _totalProcess = _totalProcess + 1;
    }

    final resultCategorias = failureOrCategorias.fold(
        (failure) => failure, (categorias) => categorias);

    if (resultCategorias is! Failure) {
      final categorias = resultCategorias as List<CategoriaOps>;
      await _saveCategoriasOpsLocalUc(categorias);
      _totalProcess = _totalProcess + 1;
    }

    //TODO: AGREGAR DESCARGA DE TURNOS.
    final resultTurnos =
        failureOrTurnos.fold((failure) => failure, (turnos) => turnos);

    if (resultTurnos is! Failure) {
      final turnos = resultTurnos as List<Turno>;
      await _saveTurnosOpsLocalUc(turnos);
      _totalProcess = _totalProcess + 1;
    }

    final resultResultados = failureOrResultados.fold(
        (failure) => failure, (resultados) => resultados);

    if (resultResultados is! Failure) {
      final resultados = resultResultados as List<ResultadoOps>;
      await _saveResultadosOpsLocalUc(resultados);
      _totalProcess = _totalProcess + 1;
    }
  }
}
