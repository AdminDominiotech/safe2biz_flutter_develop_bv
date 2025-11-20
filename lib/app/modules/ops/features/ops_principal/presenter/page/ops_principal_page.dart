import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/usecases/get_lista_verificacion_storage_uc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/bloc/ops_main_bloc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/models/models.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/page/ops_principal_body.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

class OpsPrincipalPage extends StatelessWidget {
  final int? ops_tipo_checklist_id;

  final int? ops_sub_tipo_id;


  OpsPrincipalPage({
    Key? key,
    required this.pageArgs,
    this.ops_tipo_checklist_id,
    this.ops_sub_tipo_id

  }) : super(key: key);

  final OpsPrincipalPageArgs pageArgs;

  final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OpsMainBloc(
        updatePreguntasByRegistroGeneralOpsLocalUc:
            GetIt.I<UpdatePreguntasByRegistroGeneralOpsLocalUcImpl>(),
        getListaVerificacionStorageUc:
            GetIt.I<GetListaVerificacionStorageUcImpl>(),
        deleteRegistroGeneralStorageUc:
            GetIt.I<DeleteRegistroGeneralStorageUcImpl>(),
        deleteRegistroResultadoStorageUc:
            GetIt.I<DeleteRegistroResultadoStorageUcImpl>(),
      )..add(
          InitEv(
            idSede: idSede,
            idListaVerificacion: pageArgs.idVerificacionOps,
          ),
        ),
      child: OpsPrincialBody(pageArgs: pageArgs, ops_tipo_checklist_id: ops_tipo_checklist_id, ops_sub_tipo_id:ops_sub_tipo_id),
    );
  }
}
