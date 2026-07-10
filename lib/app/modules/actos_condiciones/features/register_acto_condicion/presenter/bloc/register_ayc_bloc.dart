import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/models/models.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/usecases/save_acto_condicion_storage_uc.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

part 'register_ayc_event.dart';
part 'register_ayc_state.dart';

typedef ActosCondicionesEmitter = Emitter<RegisterAyCState>;

class RegisterAyCBloc extends Bloc<RegisterAyCEvent, RegisterAyCState> {
  RegisterAyCBloc({
    required AppController appController,
    required AuthController authController,
    required SaveActoCondicionStorageUcImpl saveActoCondicionStorageUc,
    required GetAreasLocalUcImpl getAreasLocalUc,
    required GetGerenciasLocalUcImpl getGerenciasLocalUc,
    required GetEmpresasEspLocalUcImpl getEmpresasEspLocalUc,
    required GetDesviacionesLocalUcImpl getDesviacionesLocalUc,
    required GetTipoEventosLocalUcImpl getTipoEventosLocalUc,
    required GetNivelesRiesgosLocalUcImpl getNivelRiesgosLocalUc,
    required GetEmpleadosLocalUcImpl getEmpleadosLocalUc,
  })  : _saveActoCondicionStorageUc = saveActoCondicionStorageUc,
        _getAreasLocalUc = getAreasLocalUc,
        _getGerenciasLocalUc = getGerenciasLocalUc,
        _getEmpresasEspLocalUc = getEmpresasEspLocalUc,
        _getDesviacionesLocalUc = getDesviacionesLocalUc,
        _getTipoEventosLocalUc = getTipoEventosLocalUc,
        _getNivelesRiesgosLocalUc = getNivelRiesgosLocalUc,
        _getEmpleadosLocalUc = getEmpleadosLocalUc,
        _appController = appController,
        _authController = authController,
        super(Init()) {
    on<InitEv>(_onInitEv);
    on<ChangeDataEv>(_onChangeDataEv);
    on<SaveActoCondicionEv>(_onSaveActoCondicionEv);
  }

  final AppController _appController;
  final AuthController _authController;
  final GetAreasLocalUcImpl _getAreasLocalUc;
  final GetGerenciasLocalUcImpl _getGerenciasLocalUc;
  final GetEmpresasEspLocalUcImpl _getEmpresasEspLocalUc;
  final SaveActoCondicionStorageUcImpl _saveActoCondicionStorageUc;
  final GetDesviacionesLocalUcImpl _getDesviacionesLocalUc;
  final GetTipoEventosLocalUcImpl _getTipoEventosLocalUc;
  final GetNivelesRiesgosLocalUcImpl _getNivelesRiesgosLocalUc;
  final GetEmpleadosLocalUcImpl _getEmpleadosLocalUc;
  ActoCondicionModel _aycModel = ActoCondicionModel.fromJson({});

  Future<void> _onInitEv(
    InitEv ev,
    ActosCondicionesEmitter emit,
  ) async {
    emit(Loading());
    _aycModel = ActoCondicionModel.fromJson({});
    final failureOrAreas = await _getAreasLocalUc();
    final resultAreas = failureOrAreas.fold((l) => l, (areas) => areas);
    List<Area> areas = [];
    if (resultAreas is! Failure) {
      areas = resultAreas as List<Area>;
    }
    final failureOrGerencias = await _getGerenciasLocalUc();
    final resultGerencias =
        failureOrGerencias.fold((l) => l, (gerencias) => gerencias);
    List<Gerencia> gerencias = [];
    if (resultGerencias is! Failure) {
      gerencias = resultGerencias as List<Gerencia>;
    }

    final failureOrEmpresas = await _getEmpresasEspLocalUc();
    final resultEmpresas =
        failureOrEmpresas.fold((l) => l, (empresas) => empresas);
    List<EmpresaEsp> empresas = [];

    if (resultEmpresas is! Failure) {
      empresas = resultEmpresas as List<EmpresaEsp>;
    }

    final failureOrDesviaciones = await _getDesviacionesLocalUc();
    final resultDesviaciones =
        failureOrDesviaciones.fold((l) => l, (desviaciones) => desviaciones);
    List<Desviacion> desviaciones = [];

    if (resultDesviaciones is! Failure) {
      desviaciones = resultDesviaciones as List<Desviacion>;
    }

    final failureOrTipoEventos = await _getTipoEventosLocalUc();
    final resultTipoEventos =
        failureOrTipoEventos.fold((l) => l, (tipoeventos) => tipoeventos);
    List<TipoEvento> tipoEventos = [];

    if (resultTipoEventos is! Failure) {
      tipoEventos = resultTipoEventos as List<TipoEvento>;
    }

    final failureOrNivelRiesgos = await _getNivelesRiesgosLocalUc();
    final resultNivelRiesgos =
        failureOrNivelRiesgos.fold((l) => l, (nivelriesgos) => nivelriesgos);
    List<NivelRiesgo> nivelRiesgos = [];

    if (resultNivelRiesgos is! Failure) {
      nivelRiesgos = resultNivelRiesgos as List<NivelRiesgo>;
    }

    final failureOrEmpleados = await _getEmpleadosLocalUc();
    final resultEmpleados =
        failureOrEmpleados.fold((l) => l, (empleados) => empleados);
    List<Empleado> empleados = [];

    if (resultEmpleados is! Failure) {
      empleados = resultEmpleados as List<Empleado>;
    }
    emit(CloseLoading());

    emit(
      Loaded(
        areas: areas,
        gerencias: gerencias,
        empresas: empresas,
        desviaciones: desviaciones,
        nivelRiesgos: nivelRiesgos,
        tipoEventos: tipoEventos,
        empleados: empleados,
      ),
    );
  }

  Future<void> _onChangeDataEv(
    ChangeDataEv ev,
    ActosCondicionesEmitter emit,
  ) async {
    _aycModel = _aycModel.copyWith(
      id: ev.id,
      origen: ev.origen,
      gTipoCausaId: ev.gTipoCausaId,
      gTipoCausaNombre: ev.gTipoCausaNombre,
      fbGerencia: ev.fbGerencia,
      fbGerenciaNombre: ev.fbGerenciaNombre,
      fbAreaId: ev.fbAreaId,
      fbAreaNombre: ev.fbAreaNombre,
      descripcion: ev.descripcion,
      lugar: ev.lugar,
      fecha: ev.fecha,
      hora: ev.hora,
      corrigio: ev.corrigio,
      tipoEventoId: ev.tipoEventoId,
      tipoEventoNombre: ev.tipoEventoNombre,
      nivelRiesgoId: ev.nivelRiesgoId,
      nivelRiesgoNombre: ev.nivelRiesgoNombre,
      accionEjec: ev.accionEjec,
      fbEmpresaEspecializadaId: ev.fbEmpresaEspecializadaId,
      fbEmpresaEspecializadaNombre: ev.fbEmpresaEspecializadaNombre,
      latitud: ev.latitud,
      longitud: ev.longitud,
      fotoPreEventoNombre: ev.fotoPreEventoNombre,
      fotoPreEventoRuta: ev.fotoPreEventoRuta,
      fotoEventoNombre: ev.fotoEventoNombre,
      fotoEventoRuta: ev.fotoEventoRuta,
      fbEmpleadoId: ev.fbEmpleadoId,
      fbEmpleadoNombre: ev.fbEmpleadoNombre,
      fbUeaPeId: ev.fbUeaPeId,
      bsafId: ev.bsafID,
      tarjetaRoja: ev.tarjetaRoja,
      interiorMina: ev.interiorMina,
      interiorMinaNivel: ev.interiorMinaNivel,
      interiorMinaLabor: ev.interiorMinaLabor,
      interiorMinaNumeroLabor: ev.interiorMinaNumeroLabor,
      estado: ev.estado,
    );
  }

  Future<void> _onSaveActoCondicionEv(
      SaveActoCondicionEv ev,
      ActosCondicionesEmitter emit,
      ) async {
    emit(SavingActoCondicion());

    await Future.delayed(const Duration(milliseconds: 500));

    String? img1Name;
    String? img1;
    String? img2Name;
    String? img2;

    if (ev.file1 != null) {
      final imgResult1 = await _appController.transformImage(ev.file1!);
      img1Name = imgResult1.nameFile;
      img1 = imgResult1.base64;
    }

    if (ev.file2 != null) {
      final imgResult2 = await _appController.transformImage(ev.file2!);
      img2Name = imgResult2.nameFile;
      img2 = imgResult2.base64;
    }

    final idUser = _authController.getID;

    final model = _aycModel.copyWith(
      fotoPreEventoNombre: img1Name,
      fotoPreEventoRuta: img1,
      fotoEventoNombre: img2Name,
      fotoEventoRuta: img2,
      fbEmpleadoId: idUser,
    );

    final result = await _saveActoCondicionStorageUc(model);

    emit(CloseLoading());

    result.fold(
          (failure) => emit(
        FailureSaveActoCondicion(error: failure.message, lastState: state),
      ),
          (value) => emit(
        SavedActoCondicion(),
      ),
    );
  }
}
