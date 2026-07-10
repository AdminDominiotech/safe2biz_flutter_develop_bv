import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/models/models.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

part 'detail_ayc_event.dart';
part 'detail_ayc_state.dart';

typedef DetailAycEmitter = Emitter<DetailAycState>;

class DetailAycBloc extends Bloc<DetailAycEvent, DetailAycState> {
  DetailAycBloc({
    required AppController appController,
    required AuthController authController,
    required SaveActoCondicionUcImpl saveActoCondicionUc,
    required GetAreasLocalUcImpl getAreasLocalUc,
    required GetGerenciasLocalUcImpl getGerenciasLocalUc,
    required GetEmpresasEspLocalUcImpl getEmpresasEspLocalUc,
    required GetDesviacionesLocalUcImpl getDesviacionesLocalUc,
    required GetTipoEventosLocalUcImpl getTipoEventosLocalUc,
    required GetNivelesRiesgosLocalUcImpl getNivelRiesgosLocalUc,
    required GetEmpleadosLocalUcImpl getEmpleadosLocalUc,
    required EditActoCondicionStorageUcImpl editActoCondicionStorageUc,
    required DeleteActoCondicionStorageUcImpl deleteActoCondicionStorageUc,
    required EditStatusActoCondicionStorageUcImpl
        editStatusActoCondicionStorageUc,
  })  : _saveActoCondicionUc = saveActoCondicionUc,
        _getAreasLocalUc = getAreasLocalUc,
        _getGerenciasLocalUc = getGerenciasLocalUc,
        _getEmpresasEspLocalUc = getEmpresasEspLocalUc,
        _getDesviacionesLocalUc = getDesviacionesLocalUc,
        _getTipoEventosLocalUc = getTipoEventosLocalUc,
        _getNivelesRiesgosLocalUc = getNivelRiesgosLocalUc,
        _getEmpleadosLocalUc = getEmpleadosLocalUc,
        _editActoCondicionStorageUc = editActoCondicionStorageUc,
        _deleteActoCondicionStorageUc = deleteActoCondicionStorageUc,
        _editStatusActoCondicionStorageUc = editStatusActoCondicionStorageUc,
        _appController = appController,
        _authController = authController,
        super(Init()) {
    on<InitEv>(_onInit);
    on<ChangeDataEv>(_onChangeDataEv);
    on<UploadActoCondicionEv>(_onUploadActoCondicionEv);
    on<EditActoCondicionEv>(_onEditActoCondicionEv);
    on<DeleteActoCondicionEv>(_onDeleteActoCondicionEv);
  }

  final AppController _appController;
  final AuthController _authController;
  final GetAreasLocalUcImpl _getAreasLocalUc;
  final GetGerenciasLocalUcImpl _getGerenciasLocalUc;
  final GetEmpresasEspLocalUcImpl _getEmpresasEspLocalUc;
  final SaveActoCondicionUcImpl _saveActoCondicionUc;
  final GetDesviacionesLocalUcImpl _getDesviacionesLocalUc;
  final GetTipoEventosLocalUcImpl _getTipoEventosLocalUc;
  final GetNivelesRiesgosLocalUcImpl _getNivelesRiesgosLocalUc;
  final GetEmpleadosLocalUcImpl _getEmpleadosLocalUc;
  final EditActoCondicionStorageUcImpl _editActoCondicionStorageUc;
  final DeleteActoCondicionStorageUcImpl _deleteActoCondicionStorageUc;
  final EditStatusActoCondicionStorageUcImpl _editStatusActoCondicionStorageUc;
  late ActoCondicionModel _aycModel;

  Future<void> _onInit(
    InitEv ev,
    DetailAycEmitter emit,
  ) async {
    final a = ev.actoCondicion;
    _aycModel = ActoCondicionModel(
      id: a.id,
      origen: a.origen,
      gTipoCausaId: a.gTipoCausaId,
      gTipoCausaNombre: a.gTipoCausaNombre,
      fbGerencia: a.fbGerencia,
      fbGerenciaNombre: a.fbGerenciaNombre,
      fbAreaId: a.fbAreaId,
      fbAreaNombre: a.fbAreaNombre,
      descripcion: a.descripcion,
      lugar: a.lugar,
      fecha: a.fecha,
      hora: a.hora,
      corrigio: a.corrigio,
      tipoEventoId: a.tipoEventoId,
      tipoEventoNombre: a.tipoEventoNombre,
      nivelRiesgoId: a.nivelRiesgoId,
      nivelRiesgoNombre: a.nivelRiesgoNombre,
      accionEjec: a.accionEjec,
      fbEmpresaEspecializadaId: a.fbEmpresaEspecializadaId,
      fbEmpresaEspecializadaNombre: a.fbEmpresaEspecializadaNombre,
      latitud: a.latitud,
      longitud: a.longitud,
      fotoPreEventoNombre: a.fotoPreEventoNombre,
      fotoPreEventoRuta: a.fotoPreEventoRuta,
      fotoEventoNombre: a.fotoEventoNombre,
      fotoEventoRuta: a.fotoEventoRuta,
      fbEmpleadoId: a.fbEmpleadoId,
      fbEmpleadoNombre: a.fbEmpleadoNombre,
      fbUeaPeId: a.fbUeaPeId,
      bsafId: a.bsafId,
      tarjetaRoja: a.tarjetaRoja,
      interiorMina: a.interiorMina,
      interiorMinaNivel: a.interiorMinaNivel,
      interiorMinaLabor: a.interiorMinaLabor,
      interiorMinaNumeroLabor: a.interiorMinaNumeroLabor,
      estado: a.estado,
    );
    emit(Loading());
    final failureOrAreas = await _getAreasLocalUc();
    final resultAreas = failureOrAreas.fold((l) => l, (areas) => areas);
    List<Area> areas = [];
    if (resultAreas is! Failure) {
      areas = resultAreas as List<Area>;
    }
    final failureOrGerencias = await _getGerenciasLocalUc();
    final resultGerencias =
        failureOrGerencias.fold((l) => l, (gerencias) => gerencias);
    List<Gerencia> gerencias = [];
    if (resultGerencias is! Failure) {
      gerencias = resultGerencias as List<Gerencia>;
    }

    final failureOrEmpresas = await _getEmpresasEspLocalUc();
    final resultEmpresas =
        failureOrEmpresas.fold((l) => l, (empresas) => empresas);
    List<EmpresaEsp> empresas = [];

    if (resultEmpresas is! Failure) {
      empresas = resultEmpresas as List<EmpresaEsp>;
    }

    final failureOrDesviaciones = await _getDesviacionesLocalUc();
    final resultDesviaciones =
        failureOrDesviaciones.fold((l) => l, (desviaciones) => desviaciones);
    List<Desviacion> desviaciones = [];

    if (resultDesviaciones is! Failure) {
      desviaciones = resultDesviaciones as List<Desviacion>;
    }

    final failureOrTipoEventos = await _getTipoEventosLocalUc();
    final resultTipoEventos =
        failureOrTipoEventos.fold((l) => l, (tipoeventos) => tipoeventos);
    List<TipoEvento> tipoEventos = [];

    if (resultTipoEventos is! Failure) {
      tipoEventos = resultTipoEventos as List<TipoEvento>;
    }

    final failureOrNivelRiesgos = await _getNivelesRiesgosLocalUc();
    final resultNivelRiesgos =
        failureOrNivelRiesgos.fold((l) => l, (nivelriesgos) => nivelriesgos);
    List<NivelRiesgo> nivelRiesgos = [];

    if (resultNivelRiesgos is! Failure) {
      nivelRiesgos = resultNivelRiesgos as List<NivelRiesgo>;
    }

    final failureOrEmpleados = await _getEmpleadosLocalUc();
    final resultEmpleados =
        failureOrEmpleados.fold((l) => l, (empleados) => empleados);
    List<Empleado> empleados = [];

    if (resultEmpleados is! Failure) {
      empleados = resultEmpleados as List<Empleado>;
    }
    emit(CloseLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    emit(
      Loaded(
        actoCondicion: ev.actoCondicion,
        areas: areas,
        gerencias: gerencias,
        empresas: empresas,
        desviaciones: desviaciones,
        nivelRiesgos: nivelRiesgos,
        tipoEventos: tipoEventos,
        empleados: empleados,
      ),
    );
  }

  Future<void> _onChangeDataEv(
    ChangeDataEv ev,
    DetailAycEmitter emit,
  ) async {
    _aycModel = _aycModel.copyWith(
      id: ev.id,
      origen: ev.origen,
      gTipoCausaId: ev.gTipoCausaId,
      gTipoCausaNombre: ev.gTipoCausaNombre,
      fbGerencia: ev.fbGerencia,
      fbGerenciaNombre: ev.fbGerenciaNombre,
      fbAreaId: ev.fbAreaId,
      fbAreaNombre: ev.fbAreaNombre,
      descripcion: ev.descripcion,
      lugar: ev.lugar,
      fecha: ev.fecha,
      hora: ev.hora,
      corrigio: ev.corrigio,
      tipoEventoId: ev.tipoEventoId,
      tipoEventoNombre: ev.tipoEventoNombre,
      nivelRiesgoId: ev.nivelRiesgoId,
      nivelRiesgoNombre: ev.nivelRiesgoNombre,
      accionEjec: ev.accionEjec,
      fbEmpresaEspecializadaId: ev.fbEmpresaEspecializadaId,
      fbEmpresaEspecializadaNombre: ev.fbEmpresaEspecializadaNombre,
      latitud: ev.latitud,
      longitud: ev.longitud,
      fotoPreEventoNombre: ev.fotoPreEventoNombre,
      fotoPreEventoRuta: ev.fotoPreEventoRuta,
      fotoEventoNombre: ev.fotoEventoNombre,
      fotoEventoRuta: ev.fotoEventoRuta,
      fbEmpleadoId: ev.fbEmpleadoId,
      fbEmpleadoNombre: ev.fbEmpleadoNombre,
      fbUeaPeId: ev.fbUeaPeId,
      bsafId: ev.bsafId,
      tarjetaRoja: ev.tarjetaRoja,
      interiorMina: ev.interiorMina,
      interiorMinaNivel: ev.interiorMinaNivel,
      interiorMinaLabor: ev.interiorMinaLabor,
      interiorMinaNumeroLabor: ev.interiorMinaNumeroLabor,
      estado: ev.estado,
    );
  }

  Future<void> _onEditActoCondicionEv(
    EditActoCondicionEv ev,
    DetailAycEmitter emit,
  ) async {
    emit(EditingActoCondicion());
    await Future.delayed(const Duration(milliseconds: 500));

    String img1Name = _aycModel.fotoPreEventoNombre;
    String img1 = _aycModel.fotoPreEventoRuta;
    String img2Name = _aycModel.fotoEventoNombre;
    String img2 = _aycModel.fotoEventoRuta;

    if (ev.file1 != null) {
      final imgResult1 = await _appController.transformImage(ev.file1!);
      img1Name = imgResult1.nameFile;
      img1 = imgResult1.base64;
    }

    if (ev.file2 != null) {
      final imgResult2 = await _appController.transformImage(ev.file2!);
      img2Name = imgResult2.nameFile;
      img2 = imgResult2.base64;
    }

    final idUser = _authController.getID;

    final model = _aycModel.copyWith(
      fotoPreEventoNombre: img1Name,
      fotoPreEventoRuta: img1,
      fotoEventoNombre: img2Name,
      fotoEventoRuta: img2,
      fbEmpleadoId: idUser,
    );

    final result = await _editActoCondicionStorageUc(model);
    emit(CloseLoading());
    result.fold(
      (failure) => emit(
        FailureEditActoCondicion(error: failure.message, lastState: state),
      ),
      (value) => emit(
        EditedActoCondicion(),
      ),
    );
  }

  Future<void> _onUploadActoCondicionEv(
    UploadActoCondicionEv ev,
    DetailAycEmitter emit,
  ) async {
    emit(UploadingActoCondicion());
    final failureOrBool = await _saveActoCondicionUc(ev.actoCondicion);
    emit(CloseLoading());
    failureOrBool.fold(
        (l) => emit(FailureUploadActoCondicion(
              error: l.message,
              lastState: state,
            )), (success) {
      _editStatusActoCondicionStorageUc(ev.actoCondicion.id, '1');
      emit(UploadedActoCondicion());
    });
  }

  Future<void> _onDeleteActoCondicionEv(
    DeleteActoCondicionEv ev,
    DetailAycEmitter emit,
  ) async {
    emit(const DeletingActoCondicion());
    final failureOrBool =
        await _deleteActoCondicionStorageUc(ev.actoCondicion.id);
    emit(CloseLoading());
    failureOrBool.fold(
      (l) => emit(FailureDeleteActoCondicion(
        error: 'Error al Eliminar',
        lastState: state,
      )),
      (success) => emit(const DeletedActoCondicion()),
    );
  }
}
