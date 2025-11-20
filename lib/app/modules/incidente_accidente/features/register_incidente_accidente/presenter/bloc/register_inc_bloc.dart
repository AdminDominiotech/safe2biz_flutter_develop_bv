import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/incidente_accidente/data/models/models.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/usecases/save_incidente_accidente_storage_uc.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

part 'register_inc_event.dart';
part 'register_inc_state.dart';

typedef RegisterINCEmitter = Emitter<RegisterINCState>;

class RegisterINCBloc extends Bloc<RegisterINCEvent, RegisterINCState> {
  RegisterINCBloc({
    required AppController appController,
    required AuthController authController,
    required SaveIncidenteAccidenteStorageUcImpl
        saveIncidenteAccidenteStorageUc,
    required GetTipoReportesLocalUcImpl getTipoReportesLocalUc,
    required GetSubTipoReportesLocalUcImpl getSubTipoReportesLocalUc,
    required GetDetallesPerdidasLocalUcImpl getDetallesPerdidasLocalUc,
    required GetPotencialesPerdidasLocalUcImpl getPotencialesPerdidasLocalUc,
    required GetGerenciasLocalUcImpl getGerenciasLocalUc,
    required GetAreasLocalUcImpl getAreasLocalUc,
  })  : _appController = appController,
        _authController = authController,
        _saveIncidenteAccidenteStorageUc = saveIncidenteAccidenteStorageUc,
        _getTipoReportesLocalUc = getTipoReportesLocalUc,
        _getSubTipoReportesLocalUc = getSubTipoReportesLocalUc,
        _getDetallesPerdidasLocalUc = getDetallesPerdidasLocalUc,
        _getPotencialesPerdidasLocalUc = getPotencialesPerdidasLocalUc,
        _getAreasLocalUc = getAreasLocalUc,
        _getGerenciasLocalUc = getGerenciasLocalUc,
        super(Init()) {
    on<InitEv>(_onInit);
    on<SaveIncidenteAccidenteEv>(_onSaveIncidenteAccidenteEv);
    on<EditDataEv>(_onEditDataEv);
  }

  final AppController _appController;
  final AuthController _authController;
  final GetTipoReportesLocalUcImpl _getTipoReportesLocalUc;
  final GetSubTipoReportesLocalUcImpl _getSubTipoReportesLocalUc;
  final GetDetallesPerdidasLocalUcImpl _getDetallesPerdidasLocalUc;
  final GetPotencialesPerdidasLocalUcImpl _getPotencialesPerdidasLocalUc;
  final GetGerenciasLocalUcImpl _getGerenciasLocalUc;
  final GetAreasLocalUcImpl _getAreasLocalUc;

  final SaveIncidenteAccidenteStorageUcImpl _saveIncidenteAccidenteStorageUc;

  late IncidenteAccidenteModel _incModel;

  Future<void> _onInit(
    InitEv ev,
    RegisterINCEmitter emit,
  ) async {
    emit(Loading());
    _incModel = IncidenteAccidenteModel.fromJson({});

    final failureOrTipoReportes = await _getTipoReportesLocalUc();
    final resultTipoReportes =
        failureOrTipoReportes.fold((l) => l, (tipoReportes) => tipoReportes);
    List<TipoReporte> tipoReportes = [];

    if (resultTipoReportes is! Failure) {
      tipoReportes = resultTipoReportes as List<TipoReporte>;
    }

    final failureOrSubTipoReportes = await _getSubTipoReportesLocalUc();
    final resultSubTipoReportes = failureOrSubTipoReportes.fold(
        (l) => l, (subTipoReportes) => subTipoReportes);
    List<SubTipoReporte> subTipoReportes = [];

    if (resultSubTipoReportes is! Failure) {
      subTipoReportes = resultSubTipoReportes as List<SubTipoReporte>;
    }

    final failureOrDetallesPerdidas = await _getDetallesPerdidasLocalUc();
    final resultDetallesPerdidas = failureOrDetallesPerdidas.fold(
        (l) => l, (detallesPerdidas) => detallesPerdidas);
    List<DetallePerdida> detallesPerdidas = [];

    if (resultDetallesPerdidas is! Failure) {
      detallesPerdidas = resultDetallesPerdidas as List<DetallePerdida>;
    }

    final failureOrPotencialesPerdidas = await _getPotencialesPerdidasLocalUc();
    final resultPotencialesPerdidas = failureOrPotencialesPerdidas.fold(
        (l) => l, (potencialesPerdidas) => potencialesPerdidas);
    List<PotencialPerdida> potencialesPerdidas = [];

    if (resultPotencialesPerdidas is! Failure) {
      potencialesPerdidas = resultPotencialesPerdidas as List<PotencialPerdida>;
    }

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

    emit(
      Loaded(
        tipoReportes: tipoReportes,
        subTipoReportes: subTipoReportes,
        detallePerdidas: detallesPerdidas,
        potencialPerdidas: potencialesPerdidas,
        areas: areas,
        gerencias: gerencias,
      ),
    );
  }

  Future<void> _onEditDataEv(
    EditDataEv ev,
    RegisterINCEmitter emit,
  ) async {
    _incModel = _incModel.copyWith(
      id: 0,
      fbGerencia: ev.fbGerencia,
      fbUeaPeId: ev.fbUeaPeId,
      fbGerenciaNombre: ev.fbGerenciaNombre,
      fbArea: ev.fbArea,
      fbAreaNombre: ev.fbAreaNombre,
      fecha: ev.fecha,
      hora: ev.hora,
      incTipoReporte: ev.incTipoReporte,
      incTipoReporteNombre: ev.incTipoReporteNombre,
      incSubTipoReporte: ev.incSubTipoReporte,
      incSubTipoReporteNombre: ev.incSubTipoReporteNombre,
      incSegunTipo: ev.incSegunTipo,
      incSegunTipoNombre: ev.incSegunTipoNombre,
      incPotencialPerdida: ev.incPotencialPerdida,
      incPotencialPerdidaNombre: ev.incPotencialPerdidaNombre,
      descripcion: ev.descripcion,
      lugar: ev.lugar,
      estado: '0',
    );
  }

  Future<void> _onSaveIncidenteAccidenteEv(
    SaveIncidenteAccidenteEv ev,
    RegisterINCEmitter emit,
  ) async {
    emit(SavingIncidenteAccidente());
    await Future.delayed(const Duration(milliseconds: 500));

    final imgResult1 = await _appController.transformImage(ev.file1);
    final img1Name = imgResult1.nameFile;
    final img1 = imgResult1.base64;
    final idUser = _authController.getID;

    final model = _incModel.copyWith(
      imagenPreReporteNombre: img1Name,
      imagenPreReporteRuta: img1,
      fbEmpleadoId: idUser,
    );

    final result = await _saveIncidenteAccidenteStorageUc(model);

    result.fold(
      (failure) => emit(
        FailureSaveIncidenteAccidente(error: failure.message, lastState: state),
      ),
      (value) => emit(
        SavedIncidenteAccidente(),
      ),
    );
  }
}
