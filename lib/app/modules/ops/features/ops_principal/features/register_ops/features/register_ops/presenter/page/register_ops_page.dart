import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/features/register_ops/presenter/bloc/register_ops_bloc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/features/register_ops/presenter/models/models.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/features/register_ops/presenter/page/register_ops_body.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

class TabRegisterOpsPage extends StatelessWidget {
  const TabRegisterOpsPage({
    Key? key,
    required this.pageArgs,
  }) : super(key: key);

  final RegisterOpsPageArgs pageArgs;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterOpsBloc(
        appController: GetIt.I<AppController>(),
        authController: GetIt.I<AuthController>(),
        getResultadosOpsLocalUc: GetIt.I<GetResultadosOpsLocalUcImpl>(),
        saveRegistrarResultadoStorageUc:
            GetIt.I<SaveRegistrarResultadoStorageUcImpl>(),
        updatePreguntasByRegistroGeneralOpsLocalUc:
            GetIt.I<UpdatePreguntasByRegistroGeneralOpsLocalUcImpl>(),
      )..add(
          InitEv(pageArgs),
        ),
      child: TabRegisterOpsBody(pageArgs: pageArgs),
    );
  }
}
