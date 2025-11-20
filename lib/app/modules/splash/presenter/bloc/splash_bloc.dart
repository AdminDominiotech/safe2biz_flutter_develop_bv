import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/controllers/settings_controller.dart';
import 'package:safe2biz/app/modules/auth/features/login/domain/entities/entities.dart';
part 'splash_event.dart';
part 'splash_state.dart';

typedef SplashEmitter = Emitter<SplashState>;

class SplashBloc extends Bloc<SplashEvent, SplashState> {



  SplashBloc({
    required AuthController authController,
    required SettingsController settingsController,
  })  : _auth = authController,
        _settings = settingsController,
        super(Init()) {


    on<InitEv>(_onInitEv);
  }
  final AuthController _auth;
  final SettingsController _settings;
  // final HasSessionUcImpl _hasSessionUc;

  Future<void> _onInitEv(InitEv ev, SplashEmitter emit) async {

    //Splash AutoSync S2B

    emit(Loading());




    final settingResult = await _settings.getSettingFromStorage();

    /*
    if (settingResult == null) {
      emit(
        FailureNotHaveSetting(
          error: 'Primero debes configurar la conexión al servidor',
          lastState: state,
        ),
      );
      return;
    }
    */


    final userResult = await _auth.hasSession();

    if (userResult != null) {
      emit(Successful(user: userResult));
    } else {
      emit(
        FailureHasSession(
          error: 'Usuario no tiene sessión',
          lastState: state,
        ),
      );
    }
  }
}
