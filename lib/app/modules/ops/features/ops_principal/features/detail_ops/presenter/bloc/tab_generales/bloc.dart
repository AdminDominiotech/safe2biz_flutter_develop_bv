import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

part 'event.dart';
part 'state.dart';

typedef TabGeneralDetailOpsEmitter = Emitter<TabGeneralDetailOpsState>;

class TabGeneralDetailOpsBloc
    extends Bloc<TabGeneralDetailOpsEvent, TabGeneralDetailOpsState> {
  TabGeneralDetailOpsBloc({
    required GetTurnosOpsLocalUcImpl getTurnosOpsLocalUc,
    required GetAreasLocalUcImpl getAreasLocalUc,
    required GetEmpresasEspLocalUcImpl getEmpresasEspLocalUc,
    required EditListaVerificacionStorageUcImpl editListaVerificacionStorageUc,
    required SaveRegistroResultadoUcImpl saveRegistroResultadoUc,
    required SaveRegistrosGeneralesUcImpl saveRegistrosGeneralesUc,
    required GetRegistrarResultadoByIdGeneralStorageUcImpl
        getRegistrarResultadoByIdGeneralStorageUc,
    required EditStatusRegistroGeneralStorageUcImpl
        editStatusRegistroGeneralStorageUc,
    required EditStatusRegistroResultadoStorageUcImpl
        editStatusRegistroResultadoStorageUc,
    required DeleteRegistroGeneralStorageUcImpl deleteRegistroGeneralStorageUc,
    required DeleteRegistroResultadoStorageUcImpl
        deleteRegistroResultadoStorageUc,
  })  : _getTurnosOpsLocalUc = getTurnosOpsLocalUc,
        _getAreasLocalUc = getAreasLocalUc,
        _getEmpresasEspLocalUc = getEmpresasEspLocalUc,
        _editListaVerificacionStorageUc = editListaVerificacionStorageUc,
        _saveRegistroResultadoUc = saveRegistroResultadoUc,
        _saveRegistrosGeneralesUc = saveRegistrosGeneralesUc,
        _getRegistrarResultadoByIdGeneralStorageUc =
            getRegistrarResultadoByIdGeneralStorageUc,
        _editStatusRegistroResultadoStorageUc =
            editStatusRegistroResultadoStorageUc,
        _editStatusRegistroGeneralStorageUc =
            editStatusRegistroGeneralStorageUc,
        _deleteRegistroGeneralStorageUc = deleteRegistroGeneralStorageUc,
        _deleteRegistroResultadoStorageUc = deleteRegistroResultadoStorageUc,
        super(Init()) {
    on<InitEv>(_onInitEv);
    on<EditListaVerificacionEv>(_onEditListaVerificacionEv);
    on<UploadRegistrosGeneralesEv>(_onUploadRegistrosGeneralesEv);
    on<DeleteRegistrosGeneralesEv>(_onDeleteRegistrosGeneralesEv);
  }

  final GetAreasLocalUcImpl _getAreasLocalUc;
  final GetEmpresasEspLocalUcImpl _getEmpresasEspLocalUc;
  final GetTurnosOpsLocalUcImpl _getTurnosOpsLocalUc;
  final EditListaVerificacionStorageUcImpl _editListaVerificacionStorageUc;
  final SaveRegistroResultadoUcImpl _saveRegistroResultadoUc;
  final SaveRegistrosGeneralesUcImpl _saveRegistrosGeneralesUc;
  final GetRegistrarResultadoByIdGeneralStorageUcImpl
      _getRegistrarResultadoByIdGeneralStorageUc;
  final EditStatusRegistroGeneralStorageUcImpl
      _editStatusRegistroGeneralStorageUc;
  final EditStatusRegistroResultadoStorageUcImpl
      _editStatusRegistroResultadoStorageUc;
  final DeleteRegistroGeneralStorageUcImpl _deleteRegistroGeneralStorageUc;
  final DeleteRegistroResultadoStorageUcImpl _deleteRegistroResultadoStorageUc;

  Future<void> _onInitEv(
    InitEv ev,
    TabGeneralDetailOpsEmitter emit,
  ) async {
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
    final failureOrResultados =
        await _getRegistrarResultadoByIdGeneralStorageUc(ev.idGeneral);
    final resultResultados = failureOrResultados.fold(
        (l) => l, (detallesPerdidas) => detallesPerdidas);
    List<RegistroResultado> resultados = [];

    if (resultTurnos is! Failure) {
      resultados = resultResultados as List<RegistroResultado>;
    }

    await Future.delayed(const Duration(milliseconds: 300));
    emit(const CloseLoading());
    emit(
      Loaded(
        turnos: turnos,
        areas: areas,
        empresas: empresas,
        registrosResultados: resultados,
      ),
    );
  }

  Future<void> _onEditListaVerificacionEv(
    EditListaVerificacionEv ev,
    TabGeneralDetailOpsEmitter emit,
  ) async {
    emit(EditingListaVerificacion());

    await Future.delayed(const Duration(milliseconds: 500));

    final result = await _editListaVerificacionStorageUc(ev.registroGeneral);

    emit(CloseLoading());

    result.fold(
      (failure) => emit(
        FailureEditListaVerificacion(error: failure.message, lastState: state),
      ),
      (value) => emit(
        EditedListaVerificacion(),
      ),
    );
  }

  Future<void> _onUploadRegistrosGeneralesEv(
    UploadRegistrosGeneralesEv ev,
    TabGeneralDetailOpsEmitter emit,
  ) async {
    emit(UploadingRegistrosGenerales());
    final result = await _saveRegistrosGeneralesUc(
        ev.registroGeneral, ev.idUser, ev.idSede);
    for (var r in ev.registrosResultados) {
      await _saveRegistroResultadoUc(r, ev.idUser, ev.idSede);
    }

    emit(CloseLoading());
    _editStatusRegistroGeneralStorageUc(ev.registroGeneral.id, '1');
    _editStatusRegistroResultadoStorageUc(ev.registroGeneral.id, '1');

    result.fold(
      (failure) => emit(
        FailureUploadRegistrosGenerales(
            error: failure.message, lastState: state),
      ),
      (value) => emit(
        UploadedRegistrosGenerales(),
      ),
    );
  }

  Future<void> _onDeleteRegistrosGeneralesEv(
    DeleteRegistrosGeneralesEv ev,
    TabGeneralDetailOpsEmitter emit,
  ) async {
    emit(const DeletingRegistrosGenerales());
    final failureOrBool =
        await _deleteRegistroGeneralStorageUc(ev.registroGeneral.id);

    await _deleteRegistroResultadoStorageUc(ev.registroGeneral.id.toString());
    emit(CloseLoading());
    failureOrBool.fold(
      (l) => emit(
        FailureDeleteRegistrosGenerales(
          error: 'Error al Eliminar',
          lastState: state,
        ),
      ),
      (success) => emit(const DeletedRegistrosGenerales()),
    );
  }
}
