import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
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
    required AuthController authController,
  })  : _getSedesUc = getSedesUc,
        _saveSedesStorageUc = saveSedesStorageUc,
        _getSedesStorageUc = getSedesStorageUc,
        _authController = authController,
        super(CompanyInitial()) {
    on<InitEv>(_onInitEv);
  }

  final GetSedesUcImpl _getSedesUc;
  final SaveSedesLocalUcImpl _saveSedesStorageUc;
  final GetSedesLocalUcImpl _getSedesStorageUc;
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
}
