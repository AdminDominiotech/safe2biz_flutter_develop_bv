import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/global/controllers/settings_controller.dart';
import 'package:safe2biz/app/global/core/env/env.dart';
import 'package:safe2biz/app/modules/splash/presenter/bloc/splash_bloc.dart';
import 'package:safe2biz/app/modules/splash/presenter/page/splash_body.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    _initSettingsAndBloc();
  }

  Future<void> _initSettingsAndBloc() async {
    final settingsController = GetIt.instance.get<SettingsController>();

    final existing = await settingsController.getSettingFromStorage();
    if (existing == null) {
      await settingsController.save();
      await Env.loadHost(settingsController.sqlite);
    }


  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(
        authController: GetIt.I<AuthController>(),
        settingsController: GetIt.I<SettingsController>(),
      ),
      child: Builder(
        builder: (context) {
          // Ejecutar después del primer frame, cuando ya existe el BlocProvider
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<SplashBloc>().add(InitEv());
          });

          return const SplashBody();
        },
      ),
    );
  }

}



