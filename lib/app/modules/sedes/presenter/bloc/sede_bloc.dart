import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/auth/features/login/data/models/models.dart';
import 'package:safe2biz/app/modules/auth/features/login/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/sedes/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/domain/usecases/usecases.dart';

part 'sede_event.dart';
part 'sede_state.dart';

typedef SedeEmitter = Emitter<SedeState>;

class SedeBloc extends Bloc<CompanyEvent, SedeState> {
  SedeBloc({
    required GetSedesUcImpl getSedesUc,
    required SaveSedesLocalUcImpl saveSedesStorageUc,
    required GetSedesLocalUcImpl getSedesStorageUc,
    required LoginCheckUcImpl loginCheckUc,
    required AuthController authController,
  })  : _getSedesUc = getSedesUc,
        _saveSedesStorageUc = saveSedesStorageUc,
        _getSedesStorageUc = getSedesStorageUc,
        _loginCheckUc = loginCheckUc,
        _authController = authController,
        super(CompanyInitial()) {
    on<InitEv>(_onInitEv);
    on<RefreshEv>(_onRefreshEv);
  }

  final GetSedesUcImpl _getSedesUc;
  final SaveSedesLocalUcImpl _saveSedesStorageUc;
  final GetSedesLocalUcImpl _getSedesStorageUc;
  final LoginCheckUcImpl _loginCheckUc;
  final AuthController _authController;

  Future<void> _onInitEv(InitEv ev, SedeEmitter emit) async {
    emit(Loading());

    var sedes = <Sede>[];
    final resultStorageCompany = await _getSedesStorageUc();
    resultStorageCompany.fold(
      (failure) {},
      (list) {
        if (list.isNotEmpty) {
          sedes = List<Sede>.from(list);
        }
      },
    );
    if (sedes.isNotEmpty) {
      emit(Successful(sedes: sedes));
      return;
    }

    final failureOrCompanies = await _getSedesUc(_authController.getID);

    final result = failureOrCompanies.fold(
      (failure) => failure,
      (companies) => companies,
    );

    if (result is Failure) {
      emit(
        FailureGetCompanies(
          error: result.message,
          lastState: state,
        ),
      );
      return;
    }
    sedes = result as List<Sede>;

    final failureOrStorage = await _saveSedesStorageUc(sedes);

    final resultStorage = failureOrStorage.fold(
      (failure) => failure,
      (value) => value,
    );

    if (resultStorage is Failure) {
      emit(
        FailureSaveCompanies(
          error: resultStorage.message,
          lastState: state,
        ),
      );
    }

    emit(Successful(sedes: sedes));
  }

  /// Refresca las sedes desde el servidor cuando el usuario presiona el boton
  /// de refresco (solo se llega aqui con internet, validado en la vista).
  ///
  /// 1. Re-consulta `pr_ws_sc_user_v2_movil` (como login_api.dart) para
  ///    refrescar la sesion y sus ACCESOS. Esto es lo que habilita los modulos
  ///    de una sede recien asignada al usuario.
  /// 2. Re-consulta `pr_ws_fb_uea` para traer la lista de sedes actualizada
  ///    (con nombre/codigo) y la guarda en almacenamiento local.
  Future<void> _onRefreshEv(RefreshEv ev, SedeEmitter emit) async {
    emit(Loading());

    // 1. Refrescar sesion + accesos via el mismo webservice del login.
    final currentUser = _authController.user.value;
    if (currentUser != null) {
      final failureOrUser = await _loginCheckUc(currentUser.userLogin);
      await failureOrUser.fold(
        (failure) async {},
        (user) async {
          // El servicio de login no devuelve la contrasena; conservamos la
          // que ya estaba guardada en la sesion actual.
          final refreshed = UserModel.castEntity(user)
              .copyWith(password: currentUser.password);
          await _authController.login(refreshed);
        },
      );
    }

    // 2. Refrescar la lista de sedes (nombres) desde pr_ws_fb_uea.
    final failureOrCompanies = await _getSedesUc(_authController.getID);

    final result = failureOrCompanies.fold(
      (failure) => failure,
      (companies) => companies,
    );

    if (result is Failure) {
      emit(
        FailureGetCompanies(
          error: result.message,
          lastState: state,
        ),
      );
      return;
    }

    final sedes = result as List<Sede>;

    final failureOrStorage = await _saveSedesStorageUc(sedes);

    final resultStorage = failureOrStorage.fold(
      (failure) => failure,
      (value) => value,
    );

    if (resultStorage is Failure) {
      emit(
        FailureSaveCompanies(
          error: resultStorage.message,
          lastState: state,
        ),
      );
    }

    emit(Successful(sedes: sedes));
  }
}
