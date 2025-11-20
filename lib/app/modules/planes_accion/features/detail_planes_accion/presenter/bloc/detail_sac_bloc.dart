import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/modules/planes_accion/data/models/models.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/usecases/usecases.dart';

part 'detail_sac_event.dart';
part 'detail_sac_state.dart';

typedef DetailSACEmitter = Emitter<DetailSACState>;

class DetailSACBloc extends Bloc<DetailSACEvent, DetailSACState> {
  DetailSACBloc({
    required AppController appController,
    required EditPlanAccionStorageUcImpl editPlanAccionStorageUc,
    required EditStatusPlanAccionStorageUcImpl editStatusPlanAccionStorageUc,
    required SavePlanAccionUcImpl savePlanAccionUc,
    required DeletePlanAccionStorageUcImpl deletePlanAccionStorageUc,
    required AuthController authController,
  })  : _appController = appController,
        _editPlanAccionStorageUc = editPlanAccionStorageUc,
        _editStatusPlanAccionStorageUc = editStatusPlanAccionStorageUc,
        _deletePlanAccionStorageUc = deletePlanAccionStorageUc,
        _savePlanAccionUc = savePlanAccionUc,
        _authController = authController,
        super(Init()) {
    on<InitEv>(_onInit);
    on<UploadPlanAccionEv>(_onUploadPlanAccionEv);
    on<EditPlanAccionEv>(_onEditPlanAccionEv);
    on<DeletePlanAccionEv>(_onDeletePlanAccionEv);
    on<ChangeDataEv>(_onChangeDataEv);
  }

  final AppController _appController;
  final EditPlanAccionStorageUcImpl _editPlanAccionStorageUc;
  final EditStatusPlanAccionStorageUcImpl _editStatusPlanAccionStorageUc;
  final DeletePlanAccionStorageUcImpl _deletePlanAccionStorageUc;
  final SavePlanAccionUcImpl _savePlanAccionUc;
  final AuthController _authController;

  late PlanesAccionModel _planAccionModel;

  Future<void> _onInit(
    InitEv ev,
    DetailSACEmitter emit,
  ) async {
    _planAccionModel = PlanesAccionModel.fromJson({});
    emit(
      Loaded(
        planAccion: ev.planAccion,
      ),
    );
  }

  Future<void> _onEditPlanAccionEv(
    EditPlanAccionEv ev,
    DetailSACEmitter emit,
  ) async {
    emit(EditingPlanAccion());

    await Future.delayed(const Duration(milliseconds: 500));

    final imgResult1 = await _appController.transformImage(ev.file1);

    final img1Name = imgResult1.nameFile;
    final img1 = imgResult1.base64;
    final idUser = _authController.getID;

    final model = _planAccionModel.copyWith(
      evidenciaNombre: img1Name,
      evidenciaRuta: img1,
    );

    final result = await _editPlanAccionStorageUc(model);

    result.fold(
      (failure) => emit(
        FailureEditPlanAccion(error: failure.message, lastState: state),
      ),
      (value) => emit(
        EditedPlanAccion(),
      ),
    );
  }

  Future<void> _onUploadPlanAccionEv(
    UploadPlanAccionEv ev,
    DetailSACEmitter emit,
  ) async {
    emit(UploadingPlanAccion());

    final id = _authController.getID;
    final failureOrBool = await _savePlanAccionUc(ev.planAccion, id);

    failureOrBool.fold(
        (l) => emit(FailureUploadPlanAccion(
              error: l.message,
              lastState: state,
            )), (success) {
      _editStatusPlanAccionStorageUc(ev.planAccion.id, '1');
      emit(UploadedPlanAccion());
    });
  }

  Future<void> _onChangeDataEv(
      ChangeDataEv ev,
      DetailSACEmitter emit,
      ) async {
    _planAccionModel = _planAccionModel.copyWith(
      id: ev.id,
      codigo: ev.codigo,
      fechaEjec: ev.fechaEjec,
      responsable: ev.responsable,
      origen: ev.origen,
      detalle: ev.detalle,
      fechaEjecucion: ev.fechaEjecucion,
      obsRespCorr: ev.obsRespCorr,
      estado: ev.estado,
      ueaId: ev.ueaId,
      evidenciaNombre: ev.evidenciaNombre,
      evidenciaRuta: ev.evidenciaRuta,
      fechaOrigen: ev.fechaOrigen,
      responsableVerificador: ev.responsableVerificador


      // Nuevos campos de la sección condicional:
     /* nombreGenerador: ev.nombreGenerador,
      nivelRiesgoNombre: ev.nivelRiesgoNombre,
      lugarProblema: ev.lugarProblema,
      causaInmediata: ev.causaInmediata,
      causaInmediataDetalle: ev.causaInmediataDetalle,
      causaBasica: ev.causaBasica,
      causaBasicaDetalle: ev.causaBasicaDetalle,
      tipoAccionCorrectivaInmDetalle: ev.tipoAccionCorrectivaInmDetalle,
      calidadHallazgo: ev.calidadHallazgo,
      fechaDeteccionCondicion: ev.fechaDeteccionCondicion,
      code_emp:  ev.code_emp,
        contratista_grisli:  ev.contratista_grisli
        */

    );
  }


  Future<void> _onDeletePlanAccionEv(
    DeletePlanAccionEv ev,
    DetailSACEmitter emit,
  ) async {
    emit(const DeletingPlanAccion());
    final failureOrBool = await _deletePlanAccionStorageUc(ev.planAccion.id);
    failureOrBool.fold(
      (l) => emit(FailureDeletePlanAccion(
        error: 'Error al Eliminar',
        lastState: state,
      )),
      (success) => emit(const DeletedPlanAccion()),
    );
  }
}
