import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/registro_general.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/usecases/get_lista_verificacion_storage_uc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

part 'ops_main_event.dart';
part 'ops_main_state.dart';

typedef OpsMainEmitter = Emitter<OpsMainState>;

class OpsMainBloc extends Bloc<OpsMainEvent, OpsMainState> {
  OpsMainBloc({
    required GetListaVerificacionStorageUcImpl getListaVerificacionStorageUc,
    required UpdatePreguntasByRegistroGeneralOpsLocalUcImpl
        updatePreguntasByRegistroGeneralOpsLocalUc,
    required DeleteRegistroGeneralStorageUcImpl deleteRegistroGeneralStorageUc,
    required DeleteRegistroResultadoStorageUcImpl
        deleteRegistroResultadoStorageUc,
  })  : _getListaVerificacionStorageUc = getListaVerificacionStorageUc,
        _updatePreguntasByRegistroGeneralOpsLocalUc =
            updatePreguntasByRegistroGeneralOpsLocalUc,
        _deleteRegistroGeneralStorageUc = deleteRegistroGeneralStorageUc,
        _deleteRegistroResultadoStorageUc = deleteRegistroResultadoStorageUc,
        super(Init(const Model())) {
    on<InitEv>(_onInitEv);
    on<UpdatePreguntasEv>(_onUpdatePreguntasEv);
    on<DeleteListaVerificacionEv>(_onDeleteListaVerificacionEv);

  }

  final GetListaVerificacionStorageUcImpl _getListaVerificacionStorageUc;
  final UpdatePreguntasByRegistroGeneralOpsLocalUcImpl
      _updatePreguntasByRegistroGeneralOpsLocalUc;

  final DeleteRegistroGeneralStorageUcImpl _deleteRegistroGeneralStorageUc;
  final DeleteRegistroResultadoStorageUcImpl _deleteRegistroResultadoStorageUc;

  Future<void> _onInitEv(InitEv ev, OpsMainEmitter emit) async {
    print("😂 Volvi a cargar ps");
    emit(Loading(state.model));

    final result =
        await _getListaVerificacionStorageUc(ev.idSede, ev.idListaVerificacion);
    result.fold(
      (failure) => emit(
        FailureGetListaVerificacion(
          error: failure.message,
          lastState: state,
          model: state.model,
        ),
      ),
      (registroGeneral) => emit(
        Loaded(
          state.model.copyWith(
            idSede: ev.idSede,
            registroGeneral: registroGeneral,
          ),
        ),
      ),
    );
  }

  Future<void> _onUpdatePreguntasEv(
      UpdatePreguntasEv ev, OpsMainEmitter emit) async {
    final result = await _updatePreguntasByRegistroGeneralOpsLocalUc(
      ev.idGeneral,
      ev.idVerificacion,
    );
    result.fold((l) => print(l), (r) => print(r));
  }

  /*Future<void> _onUploadActosCondicionesEv(
    UploadActosCondicionesEv ev,
    OpsMainEmitter emit,
  ) async {
    int uploadSuccess = 0;
    emit(UploadingActosCondiciones(state.model));
    for (final ayc in ev.actosCondiciones) {
      final failureOrBool = await _saveActoCondicionUc(ayc);

      failureOrBool.fold((l) => l, (success) {
        uploadSuccess++;
        _editStatusActoCondicionStorageUc(ayc.id, '1');
      });
    }
    log('Subido: ${ev.actosCondiciones.length} de $uploadSuccess');
    final message =
        'Subido exitosamente\n${ev.actosCondiciones.length} de $uploadSuccess';
    emit(UploadedActosCondiciones(state.model, message: message));

    add(InitEv(
      idSede: state.model.idSede,
    ));
  }
*/


  Future<void> _onDeleteListaVerificacionEv(
    DeleteListaVerificacionEv ev,
    OpsMainEmitter emit,
  ) async {
    emit(DeletingListaVerificacion(state.model));
    await _deleteRegistroGeneralStorageUc(ev.registroGeneral.id);
    final failureOrBool = await _deleteRegistroResultadoStorageUc(
      ev.registroGeneral.id.toString(),
    );
    failureOrBool.fold(
      (l) => emit(FailureDeleteListaVerificacion(
        error: 'Error al Eliminar',
        lastState: state,
        model: state.model,
      )),
      (success) => DeletedListaVerificacion(state.model),
    );

    state.model.registroGeneral.remove(ev.registroGeneral);
    emit(DeletedListaVerificacion(state.model));
  }
}
