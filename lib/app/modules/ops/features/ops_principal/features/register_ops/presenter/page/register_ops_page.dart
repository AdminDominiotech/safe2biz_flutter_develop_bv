import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/bloc/tab_cuestionario/bloc.dart'
    as tab_questions_bloc;
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/bloc/tab_generales/bloc.dart'
    as tab_general_bloc;
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/models/models.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

import '../../../../domain/usecases/usecases.dart';
import 'register_ops_body.dart';

class RegisterOpsPage extends StatelessWidget {
  final int? ops_tipo_checklist_id;
  final int? ops_sub_tipo_id;
  RegisterOpsPage({
    Key? key,
    required this.pageArgs,
    this.ops_tipo_checklist_id,
    this.ops_sub_tipo_id
  }) : super(key: key);

  final RegisterOpsPrincipalPageArgs pageArgs;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => tab_questions_bloc.TabCuestionarioBloc(
          getCategoriasLocalOpsUc: GetIt.I<GetCategoriasOpsLocalUcImpl>(),
          getPreguntasLocalOpsUc: GetIt.I<GetPreguntasOpsLocalUcImpl>(),
          getSeccionesLocalOpsUc: GetIt.I<GetSeccionesOpsLocalUcImpl>(),
        )..add(tab_questions_bloc.InitEv(pageArgs.verificationId)),
      ),
      BlocProvider(
        create: (context) => tab_general_bloc.TabOpsBloc(
          getTurnosOpsLocalUc: GetIt.I<GetTurnosOpsLocalUcImpl>(),
          getAreasLocalUc: GetIt.I<GetAreasLocalUcImpl>(),
          getEmpresasEspLocalUc: GetIt.I<GetEmpresasEspLocalUcImpl>(),
          saveListaVerificacionStorageUc:
              GetIt.I<SaveListaVerificacionStorageUcImpl>(),
          updatePreguntasByRegistroGeneralOpsLocalUc:
              GetIt.I<UpdatePreguntasByRegistroGeneralOpsLocalUcImpl>(),
        )..add(tab_general_bloc.InitEv(pageArgs)),
      ),
    ], child: RegisterOpsBody(pageArgs: pageArgs, ops_tipo_checklist_id: ops_tipo_checklist_id, ops_sub_tipo_id: ops_sub_tipo_id));
  }
}
