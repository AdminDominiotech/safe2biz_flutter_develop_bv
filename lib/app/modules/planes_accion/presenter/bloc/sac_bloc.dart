import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/planes_accion/features/detail_planes_accion/presenter/bloc/detail_sac_bloc.dart';

part 'sac_event.dart';
part 'sac_state.dart';

typedef SACEmitter = Emitter<SACState>;

class SACBloc extends Bloc<SACEvent, SACState> {
  SACBloc({
    required GetPlanesAccionStorageUcImpl getPlanesAccionStorageUc,
    required EditStatusPlanAccionStorageUcImpl editStatusPlanAccionStorageUc,
    required SavePlanAccionUcImpl savePlanAccionUc,
    required DeletePlanAccionStorageUcImpl deletePlanAccionStorageUc,
    required AuthController authController,
  })  : _getPlanesAccionStorageUc = getPlanesAccionStorageUc,
        _editStatusPlanAccionStorageUc = editStatusPlanAccionStorageUc,
        _deletePlanAccionStorageUc = deletePlanAccionStorageUc,
        _savePlanAccionUc = savePlanAccionUc,
        _authController = authController,
        super(Init(const Model())) {
    on<InitEv>(_onInitEv);
    on<UploadPlanesAccionEv>(_onUploadPlanAccionEv);
    on<DeletePlanAccionEv>(_onDeletePlanAccionEv);
  }

  final GetPlanesAccionStorageUcImpl _getPlanesAccionStorageUc;
  final EditStatusPlanAccionStorageUcImpl _editStatusPlanAccionStorageUc;
  final DeletePlanAccionStorageUcImpl _deletePlanAccionStorageUc;
  final SavePlanAccionUcImpl _savePlanAccionUc;
  final AuthController _authController;

  Future<void> _onInitEv(InitEv ev, SACEmitter emit) async {
    emit(Loading(state.model));

    final result = await _getPlanesAccionStorageUc(ev.idSede);
    result.fold(
      (failure) => emit(
        FailureGetPlanesAccion(
          error: failure.message,
          lastState: state,
          model: state.model,
        ),
      ),
      (planesAccion) => emit(
        Loaded(
          state.model.copyWith(planesAccion: planesAccion),
        ),
      ),
    );
  }

  Future<void> _onUploadPlanAccionEv(
    UploadPlanesAccionEv ev,
    SACEmitter emit,
  ) async {
    int uploadSuccess = 0;
    final userId = _authController.getID;
    emit(UploadingPlanesAccion(state.model));
    for (final sac in ev.planesAccion) {
      final failureOrBool = await _savePlanAccionUc(sac, userId);

      failureOrBool.fold((l) => l, (success) {
        uploadSuccess++;
        _editStatusPlanAccionStorageUc(sac.id, '1');
      });
    }
    log('Subido: ${ev.planesAccion.length} de $uploadSuccess');
    final message =
        'Subido exitosamente\n${ev.planesAccion.length} de $uploadSuccess';
    emit(UploadedPlanesAccion(state.model, message: message));

    add(InitEv(idSede: state.model.idSede));
  }

  Future<void> _onDeletePlanAccionEv(
    DeletePlanAccionEv ev,
    SACEmitter emit,
  ) async {
    emit(DeletingPlanesAccion(state.model));
    final failureOrBool = await _deletePlanAccionStorageUc(ev.planAccion.id);
    failureOrBool.fold(
      (l) => emit(FailureDeletePlanesAccion(
        error: 'Error al Eliminar',
        lastState: state,
        model: state.model,
      )),
      (success) => DeletedPlanesAccion(state.model),
    );

    state.model.planesAccion.remove(ev.planAccion);
    emit(DeletedPlanesAccion(state.model));
  }
}
