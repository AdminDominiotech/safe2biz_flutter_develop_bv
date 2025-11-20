import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/features/detail_ops/presenter/bloc/detail_ops_bloc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/features/detail_ops/presenter/models/page_arguments.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/features/detail_ops/presenter/page/detail_ops_body.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

class TabDetailOpsPage extends StatelessWidget {
  const TabDetailOpsPage({
    Key? key,
    required this.pageArgs,
  }) : super(key: key);

  final DetailOpsPageArgs pageArgs;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailOpsBloc(
        appController: GetIt.I<AppController>(),
        authController: GetIt.I<AuthController>(),
        getResultadosOpsLocalUc: GetIt.I<GetResultadosOpsLocalUcImpl>(),
        saveRegistrarResultadoStorageUc:
            GetIt.I<SaveRegistrarResultadoStorageUcImpl>(),
        getRegistrarResultadoStorageUc:
            GetIt.I<GetRegistrarResultadoStorageUcImpl>(),
        editRegistrarResultadoStorageUc:
            GetIt.I<EditRegistrarResultadoStorageUcImpl>(),
        updatePreguntasByRegistroGeneralOpsLocalUc:
            GetIt.I<UpdatePreguntasByRegistroGeneralOpsLocalUcImpl>(),
      )..add(
          InitEv(pageArgs),
        ),
      child: TabDetailOpsBody(pageArgs: pageArgs),
    );
  }
}
