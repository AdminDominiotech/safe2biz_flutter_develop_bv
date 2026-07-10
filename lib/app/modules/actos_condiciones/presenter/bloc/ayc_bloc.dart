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
    await result.fold(
      (failure) async => emit(
        FailureGetActosCondiciones(
          error: failure.message,
          lastState: state,
          model: state.model,
        ),
      ),
      (actosCondiciones) async {
        // Purga los registros ya ENVIADOS (estado == '1'): fueron subidos al
        // servidor y no deben permanecer localmente. Los PENDIENTES
        // (estado == '0') se conservan siempre.
        final enviados =
            actosCondiciones.where((ayc) => ayc.estado == '1').toList();
        for (final ayc in enviados) {
          await _deleteActoCondicionStorageUc(ayc.id);
        }

        final pendientes =
            actosCondiciones.where((ayc) => ayc.estado != '1').toList();
        emit(
          Loaded(
            state.model.copyWith(
              idSede: ev.idSede,
              actosCondiciones: pendientes,
            ),
          ),
        );
      },
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

      if (failureOrBool.isRight()) {
        uploadSuccess++;
        // Enviado con exito al servidor: se marca como enviado y se elimina del
        // almacenamiento local. Si el borrado fallara, queda en estado='1' y se
        // purga al recargar la lista (ver _onInitEv). Los registros que NO se
        // enviaron permanecen en estado='0'.
        await _editStatusActoCondicionStorageUc(ayc.id, '1');
        await _deleteActoCondicionStorageUc(ayc.id);
      }
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
