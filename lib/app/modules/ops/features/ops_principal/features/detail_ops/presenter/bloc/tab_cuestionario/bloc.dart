import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

part 'event.dart';
part 'state.dart';

typedef TabCuestionarioEmitter = Emitter<TabCuestionarioState>;

class TabCuestionarioBloc
    extends Bloc<TabCuestionarioEvent, TabCuestionarioState> {
  TabCuestionarioBloc({
    required GetSeccionesOpsLocalUcImpl getSeccionesLocalOpsUc,
    required GetPreguntasOpsLocalUcImpl getPreguntasLocalOpsUc,
    required GetCategoriasOpsLocalUcImpl getCategoriasLocalOpsUc,
  })  : _getSeccionesLocalOpsUc = getSeccionesLocalOpsUc,
        _getPreguntasLocalOpsUc = getPreguntasLocalOpsUc,
        _getCategoriasLocalOpsUc = getCategoriasLocalOpsUc,
        super(Init(Model.empty())) {
    on<InitEv>(_onInitEv);
  }

  final GetSeccionesOpsLocalUcImpl _getSeccionesLocalOpsUc;
  final GetPreguntasOpsLocalUcImpl _getPreguntasLocalOpsUc;
  final GetCategoriasOpsLocalUcImpl _getCategoriasLocalOpsUc;

  Future<void> _onInitEv(InitEv ev, TabCuestionarioEmitter emit) async {
    emit(Loading(state.model));
    List<ExpansionModel> _listCategories = [];
    List<ExpansionModel> _listSections = [];
    List<ExpansionModel> _listQuestions = [];
    final failureOrCategories = await _getCategoriasLocalOpsUc();
    final failureOrSections = await _getSeccionesLocalOpsUc();
    final failureOrQuestions = await _getPreguntasLocalOpsUc();

    final resultCategories =
        failureOrCategories.fold((failure) => failure, (areas) => areas);

    final resultSections =
        failureOrSections.fold((failure) => failure, (sections) => sections);

    final resultQuestions =
        failureOrQuestions.fold((failure) => failure, (questions) => questions);

    if (resultCategories is! Failure &&
        resultSections is! Failure &&
        resultSections is! Failure &&
        resultQuestions is! Failure) {
      _listCategories = (resultCategories as List<CategoriaOps>)
          .where((e) => e.opsListaVerificacionId == ev.verificationId)
          .map((c) {
        return ExpansionModel(
          id: int.tryParse(c.id) ?? 0,
          idReference: int.tryParse(c.opsListaVerificacionId) ?? 0,
          nombre: c.nombre,
        );
      }).toList();
    }

    if (resultSections is! Failure) {
      _listSections = (resultSections as List<SeccionOps>)
          .map((s) => ExpansionModel(
                id: int.tryParse(s.id) ?? 0,
                idReference: int.tryParse(s.opsListaVerifCategoriaId) ?? 0,
                nombre: s.nombre,
              ))
          .toList();
    }

    if (resultQuestions is! Failure) {
      _listQuestions = (resultQuestions as List<PreguntaOps>)
          .map(
            (q) => ExpansionModel(
              id: int.tryParse(q.id) ?? 0,
              idReference: int.tryParse(q.opsListaVerifSeccionId) ?? 0,
              nombre: q.nombre,
              tag: q.codigo,
            ),
          )
          .toList();
    }

    emit(
      Loaded(
        state.model.copyWith(
          categories: _listCategories,
          sections: _listSections,
          questions: _listQuestions,
        ),
      ),
    );
  }
}
