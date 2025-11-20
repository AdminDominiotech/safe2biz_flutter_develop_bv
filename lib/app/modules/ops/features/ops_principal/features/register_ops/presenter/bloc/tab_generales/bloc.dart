import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/models/models.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

part 'event.dart';
part 'state.dart';

typedef TabOpsEmitter = Emitter<TabOpsState>;

class TabOpsBloc extends Bloc<TabOpsEvent, TabOpsState> {
  TabOpsBloc({
    required GetTurnosOpsLocalUcImpl getTurnosOpsLocalUc,
    required GetAreasLocalUcImpl getAreasLocalUc,
    required GetEmpresasEspLocalUcImpl getEmpresasEspLocalUc,
    required SaveListaVerificacionStorageUcImpl saveListaVerificacionStorageUc,
    required UpdatePreguntasByRegistroGeneralOpsLocalUcImpl
        updatePreguntasByRegistroGeneralOpsLocalUc,
  })  : _getTurnosOpsLocalUc = getTurnosOpsLocalUc,
        _getAreasLocalUc = getAreasLocalUc,
        _getEmpresasEspLocalUc = getEmpresasEspLocalUc,
        _saveListaVerificacionStorageUc = saveListaVerificacionStorageUc,
        _updatePreguntasByRegistroGeneralOpsLocalUc =
            updatePreguntasByRegistroGeneralOpsLocalUc,
        super(Init()) {
    on<InitEv>(_onInitEv);
    on<SaveListaVerificacionEv>(_onSaveListaVerificacionEv);
    on<UpdatePreguntasEv>(_onUpdatePreguntasEv);
  }

  final GetAreasLocalUcImpl _getAreasLocalUc;
  final GetEmpresasEspLocalUcImpl _getEmpresasEspLocalUc;
  final GetTurnosOpsLocalUcImpl _getTurnosOpsLocalUc;
  final SaveListaVerificacionStorageUcImpl _saveListaVerificacionStorageUc;
  final UpdatePreguntasByRegistroGeneralOpsLocalUcImpl
      _updatePreguntasByRegistroGeneralOpsLocalUc;
  late RegisterOpsPrincipalPageArgs _pageArgs;

  Future<void> _onInitEv(
    InitEv ev,
    TabOpsEmitter emit,
  ) async {
    _pageArgs = ev.pageArgs;
    emit(Loading());
    final failureOrAreas = await _getAreasLocalUc();
    final resultAreas = failureOrAreas.fold((l) => l, (areas) => areas);
    List<Area> areas = [];
    if (resultAreas is! Failure) {
      areas = resultAreas as List<Area>;
    }

    final failureOrEmpresas = await _getEmpresasEspLocalUc();
    final resultEmpresas =
        failureOrEmpresas.fold((l) => l, (empresas) => empresas);
    List<EmpresaEsp> empresas = [];

    if (resultEmpresas is! Failure) {
      empresas = resultEmpresas as List<EmpresaEsp>;
    }

    final failureOrTurnos = await _getTurnosOpsLocalUc();
    final resultTurnos =
        failureOrTurnos.fold((l) => l, (detallesPerdidas) => detallesPerdidas);
    List<Turno> turnos = [];

    if (resultTurnos is! Failure) {
      turnos = resultTurnos as List<Turno>;
    }

    await Future.delayed(const Duration(milliseconds: 300));
    emit(const CloseLoading());
    emit(
      Loaded(turnos: turnos, areas: areas, empresas: empresas),
    );
  }

  Future<void> _onSaveListaVerificacionEv(
    SaveListaVerificacionEv ev,
    TabOpsEmitter emit,
  ) async {
    emit(SavingListaVerificacion());

    await Future.delayed(const Duration(milliseconds: 500));

    final result = await _saveListaVerificacionStorageUc(ev.registroGeneral);

    emit(CloseLoading());

    result.fold(
        (failure) => emit(
              FailureSaveListaVerificacion(
                  error: failure.message, lastState: state),
            ), (id) {
      emit(
        SavedListaVerificacion(id.toString()),
      );

      add(
        UpdatePreguntasEv(
          idGeneral: id.toString(),
          idVerificacion: _pageArgs.verificationId,
        ),
      );
    });
  }

  Future<void> _onUpdatePreguntasEv(
    UpdatePreguntasEv ev,
    TabOpsEmitter emit,
  ) async {
    // TODO: FALTA HACER LA LOGICA
    final result = await _updatePreguntasByRegistroGeneralOpsLocalUc(
      ev.idGeneral,
      ev.idVerificacion,
    );
    result.fold((l) => print(l), (r) => print(r));
  }
}
