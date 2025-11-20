import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

part 'ops_event.dart';
part 'ops_state.dart';

typedef OpsEmitter = Emitter<OpsState>;

class OpsBloc extends Bloc<OpsEvent, OpsState> {
  OpsBloc({
    required GetVerificacionesOpsLocalUcImpl getVerificacionesLocalOpsUc,
  })  : _getVerificacionesLocalOpsUc = getVerificacionesLocalOpsUc,
        super(Init()) {
    on<InitEv>(_onInitEv);
  }

  final GetVerificacionesOpsLocalUcImpl _getVerificacionesLocalOpsUc;

  Future<void> _onInitEv(InitEv ev, OpsEmitter emit) async {
    emit(Loading());
    final failureOrVerifications = await _getVerificacionesLocalOpsUc();

    failureOrVerifications.fold(
      (l) => emit(FailureGetVerifications(error: l.message, lastState: state)),
      (verifications) => emit(
        Loaded(verifications),
      ),
    );
  }
}
