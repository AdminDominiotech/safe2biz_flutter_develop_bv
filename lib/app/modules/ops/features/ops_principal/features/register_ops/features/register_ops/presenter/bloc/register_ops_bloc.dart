import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/data/models/models.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/features/register_ops/presenter/models/models.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

part 'register_ops_event.dart';
part 'register_ops_state.dart';

typedef RegisterOpsEmitter = Emitter<RegisterOpsState>;

class RegisterOpsBloc extends Bloc<RegisterOpsEvent, RegisterOpsState> {
  RegisterOpsBloc({
    required GetResultadosOpsLocalUcImpl getResultadosOpsLocalUc,
    required SaveRegistrarResultadoStorageUcImpl
        saveRegistrarResultadoStorageUc,
    required UpdatePreguntasByRegistroGeneralOpsLocalUcImpl
        updatePreguntasByRegistroGeneralOpsLocalUc,
    required AppController appController,
    required AuthController authController,
  })  : _getResultadosOpsLocalUc = getResultadosOpsLocalUc,
        _saveRegistrarResultadoStorageUc = saveRegistrarResultadoStorageUc,
        _appController = appController,
        _authController = authController,
        _updatePreguntasByRegistroGeneralOpsLocalUc =
            updatePreguntasByRegistroGeneralOpsLocalUc,
        super(Init()) {
    on<InitEv>(_onInitEv);
    on<ChangeDataEv>(_onChangeDataEv);
    on<SaveRegistroResultadoEv>(_onSaveRegistroResultadoEv);
    on<UpdatePreguntasEv>(_onUpdatePreguntasEv);
  }
  final AppController _appController;
  final AuthController _authController;
  final GetResultadosOpsLocalUcImpl _getResultadosOpsLocalUc;
  final SaveRegistrarResultadoStorageUcImpl _saveRegistrarResultadoStorageUc;
  final UpdatePreguntasByRegistroGeneralOpsLocalUcImpl
      _updatePreguntasByRegistroGeneralOpsLocalUc;
  late RegistroResultadoModel _registroResultadoModel;
  late RegisterOpsPageArgs _pageArgs;

  Future<void> _onInitEv(
    InitEv ev,
    RegisterOpsEmitter emit,
  ) async {
    emit(Loading());
    _registroResultadoModel = RegistroResultadoModel.fromJson({});
    _pageArgs = ev.pageArgs;

    final failureOrResultados = await _getResultadosOpsLocalUc();
    final resultResultados =
        failureOrResultados.fold((l) => l, (resultados) => resultados);
    List<ResultadoOps> resultados = [];
    if (resultResultados is! Failure) {
      resultados = resultResultados as List<ResultadoOps>;
    }
    emit(CloseLoading());
    emit(Loaded(
      resultadoOps: resultados,
      idResultadoOps: _pageArgs.idResultadoOps,
    ));
  }

  Future<void> _onChangeDataEv(
    ChangeDataEv ev,
    RegisterOpsEmitter emit,
  ) async {
    _registroResultadoModel = _registroResultadoModel.copyWith(
      id: ev.id,
      opsListaVerifResultadoId: ev.opsListaVerifResultadoId,
      observacion: ev.observacion,
      rutaImagen: ev.rutaImagen,
      nombreImagen: ev.nombreImagen,
      idGeneradoSyncronizacion: ev.idGeneradoSyncronizacion,
      auxCodigo: ev.auxCodigo,
    );
  }

  Future<void> _onSaveRegistroResultadoEv(
    SaveRegistroResultadoEv ev,
    RegisterOpsEmitter emit,
  ) async {
    emit(SavingRegistroResultado());

    await Future.delayed(const Duration(milliseconds: 500));

    final imgResult1 = await _appController.transformImage(ev.file1);

    final img1Name = imgResult1.nameFile;
    final img1 = imgResult1.base64;

    final model = _registroResultadoModel.copyWith(
      rutaImagen: img1,
      nombreImagen: img1Name,
      opsRegistroGeneralesId: _pageArgs.opsRegistroGeneralesId,
      opsListaVerifCategoriaId: _pageArgs.opsListaVerifCategoriaId,
      opsListaVerifSeccionId: _pageArgs.opsListaVerifSeccionId,
      opsListaVerifPreguntaId: _pageArgs.opsListaVerifPreguntaId,
    );

    final result = await _saveRegistrarResultadoStorageUc(model);

    emit(const CloseLoading());
    result.fold(
        (failure) => emit(
              FailureSaveRegistroResultado(
                error: failure.message,
                lastState: state,
              ),
            ), (value) {
      emit(
        SavedRegistroResultado(),
      );

      add(
        UpdatePreguntasEv(
          idGeneral: _pageArgs.opsRegistroGeneralesId,
          idVerificacion: _pageArgs.idVerificacion,
        ),
      );
    });
  }

  Future<void> _onUpdatePreguntasEv(
      UpdatePreguntasEv ev, RegisterOpsEmitter emit) async {
    final result = await _updatePreguntasByRegistroGeneralOpsLocalUc(
      ev.idGeneral,
      ev.idVerificacion,
    );
    result.fold((l) => print(l), (r) => print(r));
  }
}
