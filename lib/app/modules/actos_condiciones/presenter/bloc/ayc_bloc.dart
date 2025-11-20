import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/usecases/usecases.dart';

part 'ayc_event.dart';
part 'ayc_state.dart';

typedef AyCEmitter = Emitter<AyCState>;

class AyCBloc extends Bloc<AyCEvent, AyCState> {
  AyCBloc({
    required GetActosCondicionesStorageUcImpl getActosCondicionesStorageUc,
    required final SaveActoCondicionUcImpl saveActoCondicionUc,
    required final EditStatusActoCondicionStorageUcImpl
        editStatusActoCondicionStorageUc,
    required DeleteActoCondicionStorageUcImpl deleteActoCondicionStorageUc,
  })  : _getActosCondicionesStorageUc = getActosCondicionesStorageUc,
        _saveActoCondicionUc = saveActoCondicionUc,
        _editStatusActoCondicionStorageUc = editStatusActoCondicionStorageUc,
        _deleteActoCondicionStorageUc = deleteActoCondicionStorageUc,
        super(Init(const Model())) {
    on<InitEv>(_onInitEv);
    on<UploadActosCondicionesEv>(_onUploadActosCondicionesEv);
    on<DeleteActoCondicionEv>(_onDeleteActoCondicionEv);
  }

  final GetActosCondicionesStorageUcImpl _getActosCondicionesStorageUc;
  final SaveActoCondicionUcImpl _saveActoCondicionUc;
  final EditStatusActoCondicionStorageUcImpl _editStatusActoCondicionStorageUc;
  final DeleteActoCondicionStorageUcImpl _deleteActoCondicionStorageUc;

  Future<void> _onInitEv(InitEv ev, AyCEmitter emit) async {
    emit(Loading(state.model));

    final result = await _getActosCondicionesStorageUc(ev.idSede);
    result.fold(
      (failure) => emit(
        FailureGetActosCondiciones(
          error: failure.message,
          lastState: state,
          model: state.model,
        ),
      ),
      (actosCondiciones) => emit(
        Loaded(
          state.model.copyWith(
            idSede: ev.idSede,
            actosCondiciones: actosCondiciones,
          ),
        ),
      ),
    );
  }

  Future<void> _onUploadActosCondicionesEv(
    UploadActosCondicionesEv ev,
    AyCEmitter emit,
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

  Future<void> _onDeleteActoCondicionEv(
    DeleteActoCondicionEv ev,
    AyCEmitter emit,
  ) async {
    emit(DeletingActoCondicion(state.model));
    final failureOrBool =
        await _deleteActoCondicionStorageUc(ev.actoCondicion.id);
    failureOrBool.fold(
      (l) => emit(FailureDeleteActoCondicion(
        error: 'Error al Eliminar',
        lastState: state,
        model: state.model,
      )),
      (success) => DeletedActoCondicion(state.model),
    );

    state.model.actosCondiciones.remove(ev.actoCondicion);
    emit(DeletedActoCondicion(state.model));
  }
}
