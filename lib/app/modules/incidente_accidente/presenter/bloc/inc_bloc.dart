import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/usecases/usecases.dart';

part 'inc_event.dart';
part 'inc_state.dart';

typedef INCEmitter = Emitter<INCState>;

class INCBloc extends Bloc<INCEvent, INCState> {
  INCBloc({
    required GetIncidentesAccidentesStorageUcImpl
        getIncidentesAccidentesStorageUc,
    required SaveIncidenteAccidenteUcImpl saveIncidenteAccidenteUc,
    required EditStatusIncidenteAccidenteStorageUcImpl
        editStatusIncidenteAccidenteStorageUc,
    required DeleteIncidenteAccidenteStorageUcImpl
        deleteIncidenteAccidenteStorageUc,
  })  : _getIncidentesAccidentesStorageUc = getIncidentesAccidentesStorageUc,
        _saveIncidenteAccidenteUc = saveIncidenteAccidenteUc,
        _editStatusIncidenteAccidenteStorageUc =
            editStatusIncidenteAccidenteStorageUc,
        _deleteIncidenteAccidenteStorageUc = deleteIncidenteAccidenteStorageUc,
        super(Init(const Model())) {
    on<InitEv>(_onInitEv);
    on<UploadIncidentesAccidentesEv>(onUploadIncidentesAccidentesEv);
    on<DeleteIncidenteAccidenteEv>(_onDeleteIncidenteAccidenteEv);
  }

  final GetIncidentesAccidentesStorageUcImpl _getIncidentesAccidentesStorageUc;
  final SaveIncidenteAccidenteUcImpl _saveIncidenteAccidenteUc;
  final EditStatusIncidenteAccidenteStorageUcImpl
      _editStatusIncidenteAccidenteStorageUc;
  final DeleteIncidenteAccidenteStorageUcImpl
      _deleteIncidenteAccidenteStorageUc;

  Future<void> _onInitEv(InitEv ev, INCEmitter emit) async {
    emit(Loading(state.model));
    final result = await _getIncidentesAccidentesStorageUc(ev.idSede);
    result.fold(
      (failure) => emit(
        FailureGetIncidentesAccidentes(
          error: failure.message,
          lastState: state,
          model: state.model,
        ),
      ),
      (incidentesAccidentes) => emit(
        Loaded(
          state.model.copyWith(
            idSede: ev.idSede,
            incidentesAccidentes: incidentesAccidentes,
          ),
        ),
      ),
    );
  }

  Future<void> onUploadIncidentesAccidentesEv(
    UploadIncidentesAccidentesEv ev,
    INCEmitter emit,
  ) async {
    int uploadSuccess = 0;
    emit(UploadingIncidentesAccidentes(state.model));

    final newList =
        ev.incidentesAccidentes.where((e) => e.estado == '0').toList();
    for (final inc in newList) {
      final failureOrBool = await _saveIncidenteAccidenteUc(inc);

      failureOrBool.fold((l) => l, (success) {
        uploadSuccess++;
        _editStatusIncidenteAccidenteStorageUc(inc.id, '1');
      });
    }
    log('Subido: ${newList.length} de $uploadSuccess');
    final message = 'Subido exitosamente\n${newList.length} de $uploadSuccess';
    emit(UploadedIncidentesAccidentes(state.model, message: message));

    add(
      InitEv(
        idSede: state.model.idSede,
      ),
    );
  }

  Future<void> _onDeleteIncidenteAccidenteEv(
    DeleteIncidenteAccidenteEv ev,
    INCEmitter emit,
  ) async {
    emit(DeletingIncidenteAccidente(state.model));
    final failureOrBool =
        await _deleteIncidenteAccidenteStorageUc(ev.incidenteAccidente.id);
    failureOrBool.fold(
      (l) => emit(FailureDeleteIncidenteAccidente(
        error: 'Error al Eliminar',
        lastState: state,
        model: state.model,
      )),
      (success) => DeletedIncidenteAccidente(state.model),
    );

    state.model.incidentesAccidentes.remove(ev.incidenteAccidente);
    emit(DeletedIncidenteAccidente(state.model));
  }
}
