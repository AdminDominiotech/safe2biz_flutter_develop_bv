import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/incidente_accidente/data/models/incidente_accidente_model.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

part 'detail_inc_event.dart';
part 'detail_inc_state.dart';

typedef DetailINCEmitter = Emitter<DetailINCState>;

class DetailINCBloc extends Bloc<DetailINCEvent, DetailINCState> {
  DetailINCBloc({
    required AppController appController,
    required AuthController authController,
    required SaveIncidenteAccidenteUcImpl saveIncidenteAccidenteUc,
    required EditIncidenteAccidenteStorageUcImpl
        editIncidenteAccidenteStorageUc,
    required DeleteIncidenteAccidenteStorageUcImpl
        deleteIncidenteAccidenteStorageUc,
    required EditStatusIncidenteAccidenteStorageUcImpl
        editStatusIncidenteAccidenteStorageUc,
    required GetTipoReportesLocalUcImpl getTipoReportesLocalUc,
    required GetSubTipoReportesLocalUcImpl getSubTipoReportesLocalUc,
    required GetDetallesPerdidasLocalUcImpl getDetallesPerdidasLocalUc,
    required GetPotencialesPerdidasLocalUcImpl getPotencialesPerdidasLocalUc,
    required GetGerenciasLocalUcImpl getGerenciasLocalUc,
    required GetAreasLocalUcImpl getAreasLocalUc,
  })  : _appController = appController,
        _authController = authController,
        _saveIncidenteAccidenteUc = saveIncidenteAccidenteUc,
        _getTipoReportesLocalUc = getTipoReportesLocalUc,
        _getSubTipoReportesLocalUc = getSubTipoReportesLocalUc,
        _getDetallesPerdidasLocalUc = getDetallesPerdidasLocalUc,
        _getPotencialesPerdidasLocalUc = getPotencialesPerdidasLocalUc,
        _getAreasLocalUc = getAreasLocalUc,
        _getGerenciasLocalUc = getGerenciasLocalUc,
        _editIncidenteAccidenteStorageUc = editIncidenteAccidenteStorageUc,
        _deleteIncidenteAccidenteStorageUc = deleteIncidenteAccidenteStorageUc,
        _editStatusIncidenteAccidenteStorageUc =
            editStatusIncidenteAccidenteStorageUc,
        super(Init()) {
    on<InitEv>(_onInit);
    on<UploadIncidenteAccidenteEv>(_onUploadIncidenteAccidenteEv);
    on<ChangeDataEv>(_onChangeDataEv);
    on<EditIncidenteAccidenteEv>(_onEditIncidenteAccidenteEv);
    on<DeleteIncidenteAccidenteEv>(_onDeleteIncidenteAccidenteEv);
  }
  final AppController _appController;
  final AuthController _authController;
  final GetTipoReportesLocalUcImpl _getTipoReportesLocalUc;
  final GetSubTipoReportesLocalUcImpl _getSubTipoReportesLocalUc;
  final GetDetallesPerdidasLocalUcImpl _getDetallesPerdidasLocalUc;
  final GetPotencialesPerdidasLocalUcImpl _getPotencialesPerdidasLocalUc;
  final GetGerenciasLocalUcImpl _getGerenciasLocalUc;
  final GetAreasLocalUcImpl _getAreasLocalUc;
  final SaveIncidenteAccidenteUcImpl _saveIncidenteAccidenteUc;

  final EditIncidenteAccidenteStorageUcImpl _editIncidenteAccidenteStorageUc;
  final DeleteIncidenteAccidenteStorageUcImpl
      _deleteIncidenteAccidenteStorageUc;
  final EditStatusIncidenteAccidenteStorageUcImpl
      _editStatusIncidenteAccidenteStorageUc;

  late IncidenteAccidenteModel _incModel;

  Future<void> _onInit(
    InitEv ev,
    DetailINCEmitter emit,
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

    await Future.delayed(const Duration(milliseconds: 300));
    emit(const CloseLoading());
    emit(
      Loaded(
        incidenteAccidente: ev.incidenteAccidente,
        tipoReportes: tipoReportes,
        subTipoReportes: subTipoReportes,
        detallePerdidas: detallesPerdidas,
        potencialPerdidas: potencialesPerdidas,
        areas: areas,
        gerencias: gerencias,
      ),
    );
  }

  Future<void> _onChangeDataEv(
    ChangeDataEv ev,
    DetailINCEmitter emit,
  ) async {
    _incModel = _incModel.copyWith(
      id: ev.id,
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
      estado: ev.estado,
    );
  }

  Future<void> _onEditIncidenteAccidenteEv(
    EditIncidenteAccidenteEv ev,
    DetailINCEmitter emit,
  ) async {
    emit(EditingIncidenteAccidente());

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

    final result = await _editIncidenteAccidenteStorageUc(model);

    emit(const CloseLoading());
    result.fold(
        (failure) => emit(
              FailureEditIncidenteAccidente(
                  error: failure.message, lastState: state),
            ), (value) {
      emit(
        EditedIncidenteAccidente(),
      );
    });
  }

  Future<void> _onUploadIncidenteAccidenteEv(
    UploadIncidenteAccidenteEv ev,
    DetailINCEmitter emit,
  ) async {
    emit(UploadingIncidenteAccidente());
    final failureOrBool =
        await _saveIncidenteAccidenteUc(ev.incidenteAccidente);

    emit(const CloseLoading());
    failureOrBool.fold(
        (l) => emit(
              FailureUploadIncidenteAccidente(
                error: l.message,
                lastState: state,
              ),
            ), (success) {
      _editStatusIncidenteAccidenteStorageUc(ev.incidenteAccidente.id, '1');
      emit(UploadedIncidenteAccidente());
    });
  }

  Future<void> _onDeleteIncidenteAccidenteEv(
    DeleteIncidenteAccidenteEv ev,
    DetailINCEmitter emit,
  ) async {
    emit(const DeletingIncidenteAccidente());
    final failureOrBool =
        await _deleteIncidenteAccidenteStorageUc(ev.incidenteAccidente.id);
    emit(const CloseLoading());
    failureOrBool.fold(
      (l) => emit(
        FailureDeleteIncidenteAccidente(
          error: 'Error al Eliminar',
          lastState: state,
        ),
      ),
      (success) => emit(const DeletedIncidenteAccidente()),
    );
  }
}
