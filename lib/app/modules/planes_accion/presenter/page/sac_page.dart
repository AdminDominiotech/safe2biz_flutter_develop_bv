import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/planes_accion/presenter/bloc/sac_bloc.dart';
import 'package:safe2biz/app/modules/planes_accion/presenter/page/sac_body.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';

class SACPage extends StatelessWidget {
  SACPage({Key? key}) : super(key: key);

  final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SACBloc(
        getPlanesAccionStorageUc: GetIt.I<GetPlanesAccionStorageUcImpl>(),
        editStatusPlanAccionStorageUc:
            GetIt.I<EditStatusPlanAccionStorageUcImpl>(),
        deletePlanAccionStorageUc: GetIt.I<DeletePlanAccionStorageUcImpl>(),
        savePlanAccionUc: GetIt.I<SavePlanAccionUcImpl>(),
        authController: GetIt.I<AuthController>(),
      )..add(
          InitEv(idSede: idSede),
        ),
      child: const SACBody(),
    );
  }
}
