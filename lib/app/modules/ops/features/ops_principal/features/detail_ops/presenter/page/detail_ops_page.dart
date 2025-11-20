import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/models/page_arguments.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/bloc/tab_cuestionario/bloc.dart'
    as tab_questions_bloc;
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/bloc/tab_generales/bloc.dart'
    as tab_general_bloc;
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/usecases/usecases.dart';
import 'detail_ops_body.dart';

class DetailOpsPage extends StatelessWidget {
  final int? ops_tipo_checklist_id;

  DetailOpsPage({
    Key? key,
    required this.pageArgs,
    required this.registroGeneral,
    this.ops_tipo_checklist_id

  }) : super(key: key);

  final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';

  final DetailOpsPrincipalPageArgs pageArgs;
  final RegistroGeneral registroGeneral;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => tab_questions_bloc.TabCuestionarioBloc(
            getCategoriasLocalOpsUc: GetIt.I<GetCategoriasOpsLocalUcImpl>(),
            getPreguntasLocalOpsUc: GetIt.I<GetPreguntasOpsLocalUcImpl>(),
            getSeccionesLocalOpsUc: GetIt.I<GetSeccionesOpsLocalUcImpl>(),
          )..add(tab_questions_bloc.InitEv(pageArgs.idVerificacion)),
        ),
        BlocProvider(
          create: (context) => tab_general_bloc.TabGeneralDetailOpsBloc(
            getTurnosOpsLocalUc: GetIt.I<GetTurnosOpsLocalUcImpl>(),
            getAreasLocalUc: GetIt.I<GetAreasLocalUcImpl>(),
            getEmpresasEspLocalUc: GetIt.I<GetEmpresasEspLocalUcImpl>(),
            editListaVerificacionStorageUc:
                GetIt.I<EditListaVerificacionStorageUcImpl>(),
            saveRegistrosGeneralesUc: GetIt.I<SaveRegistrosGeneralesUcImpl>(),
            saveRegistroResultadoUc: GetIt.I<SaveRegistroResultadoUcImpl>(),
            getRegistrarResultadoByIdGeneralStorageUc:
                GetIt.I<GetRegistrarResultadoByIdGeneralStorageUcImpl>(),
            editStatusRegistroGeneralStorageUc:
                GetIt.I<EditStatusRegistroGeneralStorageUcImpl>(),
            editStatusRegistroResultadoStorageUc:
                GetIt.I<EditStatusRegistroResultadoStorageUcImpl>(),
            deleteRegistroGeneralStorageUc:
                GetIt.I<DeleteRegistroGeneralStorageUcImpl>(),
            deleteRegistroResultadoStorageUc:
                GetIt.I<DeleteRegistroResultadoStorageUcImpl>(),
          )..add(
              tab_general_bloc.InitEv(pageArgs.idGeneral),
            ),
        ),
      ],
      child: DetailOpsBody(
        pageArgs: pageArgs,
        registroGeneral: registroGeneral,
          ops_tipo_checklist_id: ops_tipo_checklist_id
      ),
    );
  }
}
