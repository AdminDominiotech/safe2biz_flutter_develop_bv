import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/planes_accion/features/detail_planes_accion/presenter/bloc/detail_sac_bloc.dart';
import 'package:safe2biz/app/modules/planes_accion/features/detail_planes_accion/presenter/page/detail_sac_body.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';

class DetailSACPage extends StatelessWidget {
  const DetailSACPage({
    Key? key,
    required this.planAccion,
  }) : super(key: key);

  final PlanAccion planAccion;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailSACBloc(
        appController: GetIt.I<AppController>(),
        editPlanAccionStorageUc: GetIt.I<EditPlanAccionStorageUcImpl>(),
        editStatusPlanAccionStorageUc:
            GetIt.I<EditStatusPlanAccionStorageUcImpl>(),
        deletePlanAccionStorageUc: GetIt.I<DeletePlanAccionStorageUcImpl>(),
        savePlanAccionUc: GetIt.I<SavePlanAccionUcImpl>(),
        authController: GetIt.I<AuthController>(),
      )..add(
          InitEv(planAccion: planAccion),
        ),
      child: DetailSACBody(planAccion: planAccion),
    );
  }
}
