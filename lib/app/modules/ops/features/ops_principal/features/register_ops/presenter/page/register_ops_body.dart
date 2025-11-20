import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/bloc/tab_generales/bloc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/models/models.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/page/tabs/cuestionario/tab.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/page/tabs/generales/tab.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/bloc/ops_main_bloc.dart'
    as mainBloc;

class RegisterOpsBody extends StatefulWidget {
  final int? ops_tipo_checklist_id;
  final int? ops_sub_tipo_id;

  const RegisterOpsBody({
    Key? key,
    required this.pageArgs,
    this.ops_tipo_checklist_id,
    this.ops_sub_tipo_id

  }) : super(key: key);

  final RegisterOpsPrincipalPageArgs pageArgs;

  @override
  State<RegisterOpsBody> createState() => _RegisterOpsBodyState();
}

class _RegisterOpsBodyState extends State<RegisterOpsBody> {
  bool saveOK = false;
  String idGeneral = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(saveOK);
        return false;
      },
      child: Scaffold(
        backgroundColor: S2BColors.primaryColor,
        appBar: AppBarBack(
          LocalPreferences.prefs?.getString('current_sede') ?? '',
          showLogo: false,
          // onPressed: () {
          //   // Navigator.of(context).pop(saveOK);
          // },
        ),
        body: BlocConsumer<TabOpsBloc, TabOpsState>(
          listener: (context, state) {
            if (state is Loading) {
              LoadingInfo.show(
                context: context,
                message: 'Cargando...',
              );
            }
            if (state is SavingListaVerificacion) {
              LoadingInfo.show(
                context: context,
                message: 'Guardando...',
              );
            }
            //if (state is Loaded) {Nav.back(context)},
            if (state is CloseLoading) {
              Nav.back(context);
            }
            if (state is SavedListaVerificacion) {
              _refreshList(context, widget.pageArgs.verificationId);
              idGeneral = state.idGeneral;
              Toast.show(
                description: 'Guardado exitosamente',
              );
            }
            if (state is FailureSaveListaVerificacion) {
              Toast.show(
                description: state.error,
                toastType: ToastType.error,
              );
            }
          },
          builder: (context, state) {
            return CustomTabBar(
              initTab: idGeneral.isNotEmpty ? 1 : 0,
              tabs: [
                'DATOS GENERALES',
                if (idGeneral.isNotEmpty) 'CUESTIONARIO',
              ],
              children: [
                TabGenerales(
                  pageArgs: widget.pageArgs,
                    ops_tipo_checklist_id: widget.ops_tipo_checklist_id,
                    ops_sub_tipo_id: widget.ops_sub_tipo_id

                ),
                if (idGeneral.isNotEmpty)
                  TabCuestionario(
                    title: widget.pageArgs.title,
                    idResultadoOps: widget.pageArgs.idResultadoOps,
                    opsRegistroGeneralesId: idGeneral,
                    idVerificacion: widget.pageArgs.verificationId,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void _refreshList(BuildContext context, String _idListaVerificacion) {
  final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';
  context.read<mainBloc.OpsMainBloc>().add(mainBloc.InitEv(
      idSede: idSede, idListaVerificacion: _idListaVerificacion));
}
