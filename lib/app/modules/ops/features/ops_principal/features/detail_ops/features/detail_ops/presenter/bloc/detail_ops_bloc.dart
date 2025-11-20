import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/data/models/models.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/features/detail_ops/presenter/models/page_arguments.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

part 'detail_ops_event.dart';
part 'detail_ops_state.dart';

typedef DetailOpsEmitter = Emitter<DetailOpsState>;

class DetailOpsBloc extends Bloc<DetailOpsEvent, DetailOpsState> {
  DetailOpsBloc({
    required GetResultadosOpsLocalUcImpl getResultadosOpsLocalUc,
    required SaveRegistrarResultadoStorageUcImpl
        saveRegistrarResultadoStorageUc,
    required AppController appController,
    required AuthController authController,
    required GetRegistrarResultadoStorageUcImpl getRegistrarResultadoStorageUc,
    required EditRegistrarResultadoStorageUcImpl
        editRegistrarResultadoStorageUc,
    required UpdatePreguntasByRegistroGeneralOpsLocalUcImpl
        updatePreguntasByRegistroGeneralOpsLocalUc,
  })  : _getResultadosOpsLocalUc = getResultadosOpsLocalUc,
        _saveRegistrarResultadoStorageUc = saveRegistrarResultadoStorageUc,
        _appController = appController,
        _authController = authController,
        _getRegistrarResultadoStorageUc = getRegistrarResultadoStorageUc,
        _editRegistrarResultadoStorageUc = editRegistrarResultadoStorageUc,
        _updatePreguntasByRegistroGeneralOpsLocalUc =
            updatePreguntasByRegistroGeneralOpsLocalUc,
        super(Init()) {
    on<InitEv>(_onInitEv);
    on<ChangeDataEv>(_onChangeDataEv);
    on<SaveRegistroResultadoEv>(_onSaveRegistroResultadoEv);
    on<EditRegistroResultadoEv>(_onEditRegistroResultadoEv);
    on<UpdatePreguntasEv>(_onUpdatePreguntasEv);
  }
  final AppController _appController;
  final AuthController _authController;
  final GetResultadosOpsLocalUcImpl _getResultadosOpsLocalUc;
  final SaveRegistrarResultadoStorageUcImpl _saveRegistrarResultadoStorageUc;
  final GetRegistrarResultadoStorageUcImpl _getRegistrarResultadoStorageUc;
  final EditRegistrarResultadoStorageUcImpl _editRegistrarResultadoStorageUc;
  final UpdatePreguntasByRegistroGeneralOpsLocalUcImpl
      _updatePreguntasByRegistroGeneralOpsLocalUc;

  late RegistroResultadoModel _registroResultadoModel;
  late DetailOpsPageArgs _pageArgs;

  Future<void> _onInitEv(
    InitEv ev,
    DetailOpsEmitter emit,
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
    final failureOrRegistroResultado = await _getRegistrarResultadoStorageUc(
      _pageArgs.opsRegistroGeneralesId,
      _pageArgs.opsListaVerifCategoriaId,
      _pageArgs.opsListaVerifSeccionId,
      _pageArgs.opsListaVerifPreguntaId,
    );
    final resultRegistroResultado =
        failureOrRegistroResultado.fold((l) => l, (resultados) => resultados);

    RegistroResultado registroResultado = RegistroResultadoModel.fromJson({});
    if (resultRegistroResultado is! Failure) {
      registroResultado = resultRegistroResultado as RegistroResultado;
      emit(
        RegistroResultadoLoaded(
          registroResultado: registroResultado,
        ),
      );
    }

    emit(CloseLoading());
    emit(Loaded(
      resultadoOps: resultados,
      idResultadoOps: _pageArgs.idResultadoOps,
    ));
  }

  Future<void> _onChangeDataEv(
    ChangeDataEv ev,
    DetailOpsEmitter emit,
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
    DetailOpsEmitter emit,
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
      ),
      (value) {
        emit(
          SavedRegistroResultado(),
        );
        add(
          UpdatePreguntasEv(
            idGeneral: _pageArgs.opsRegistroGeneralesId,
            idVerificacion: _pageArgs.idVerificacion,
          ),
        );
      },
    );
  }

  Future<void> _onEditRegistroResultadoEv(
    EditRegistroResultadoEv ev,
    DetailOpsEmitter emit,
  ) async {
    emit(EditingRegistroResultado());
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

    final result = await _editRegistrarResultadoStorageUc(model);

    emit(const CloseLoading());
    result.fold(
      (failure) => emit(
        FailureEditRegistroResultado(
          error: failure.message,
          lastState: state,
        ),
      ),
      (value) {
        emit(
          EditedRegistroResultado(_pageArgs.idVerificacion),
        );

        add(
          UpdatePreguntasEv(
            idGeneral: _pageArgs.opsRegistroGeneralesId,
            idVerificacion: _pageArgs.idVerificacion,
          ),
        );
      },
    );
  }

  Future<void> _onUpdatePreguntasEv(
    UpdatePreguntasEv ev,
    DetailOpsEmitter emit,
  ) async {
    final result = await _updatePreguntasByRegistroGeneralOpsLocalUc(
      ev.idGeneral,
      ev.idVerificacion,
    );
    result.fold((l) => print(l), (r) => print(r));
  }
}
