import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/global/controllers/settings_controller.dart';
import 'package:safe2biz/app/global/core/env/env.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:safe2biz/app/modules/auth/features/settings/data/models/models.dart';
import 'package:safe2biz/app/modules/auth/features/settings/domain/entities/entities.dart';

part 'settings_event.dart';
part 'settings_state.dart';

typedef SettingsEmitter = Emitter<SettingsState>;

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required SettingsController settingsController})
      : _settingsController = settingsController,
        super(Init()) {
    on<InitEv>(_onInitEv);
    on<SaveSettingEv>(_onSaveSettingEv);
  }

  final SettingsController _settingsController;

  Future<void> _onInitEv(InitEv ev, SettingsEmitter emit) async {
    emit(Loading());
    final setting = await _settingsController.getSettingFromStorage();
    emit(Loaded(setting));
  }

  Future<void> _onSaveSettingEv(SaveSettingEv ev, SettingsEmitter emit) async {
    emit(SavingSetting());

    _settingsController.setValues(
      ev.setting.ip,
      ev.setting.nameCompany,
      ev.setting.arroba,
    );

    final result = await _settingsController.save();

    if (result) {
      // 🔥 Cargar el nuevo host desde la tabla actualizada
      await Env.loadHost(_settingsController.sqlite);

      // 🔥 Reconstruir Dio con el nuevo baseUrl
      GetIt.I<DioMicroServices>().rebuildClient();

      emit(SavedSetting());
    } else {
      emit(FailureSaveSetting(
        error: 'No se pudo guardar la configuración',
        lastState: state,
      ));
    }
  }



}
