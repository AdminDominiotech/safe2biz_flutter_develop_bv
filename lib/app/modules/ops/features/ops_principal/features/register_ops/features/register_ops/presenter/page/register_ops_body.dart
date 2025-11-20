import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/features/register_ops/presenter/bloc/register_ops_bloc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/features/register_ops/presenter/models/models.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/features/register_ops/presenter/widgets/form_register.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/bloc/tab_cuestionario/bloc.dart'
    as tabCuestionario;
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/bloc/ops_main_bloc.dart'
    as mainBloc;
import 'package:safe2biz/app/ui/module_ui.dart';

class TabRegisterOpsBody extends StatefulWidget {
  TabRegisterOpsBody({Key? key, required this.pageArgs}) : super(key: key);
  final RegisterOpsPageArgs pageArgs;
  @override
  State<TabRegisterOpsBody> createState() => _TabRegisterOpsBodyState();
}

class _TabRegisterOpsBodyState extends State<TabRegisterOpsBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(widget.pageArgs.title),
      body: BlocConsumer<RegisterOpsBloc, RegisterOpsState>(
        listener: (context, state) {
          if (state is Init || state is Loading) {
            LoadingInfo.show(
              context: context,
              message: 'Cargando...',
            );
          }
          if (state is SavingRegistroResultado) {
            LoadingInfo.show(
              context: context,
              message: 'Guardando...',
            );
          }
          if (state is FailureSaveRegistroResultado) {
            Toast.show(
              description: state.error,
              toastType: ToastType.error,
            );
          }
          if (state is CloseLoading) {
            Nav.back(context);
          }
        },
        builder: (context, state) {
          if (state is SavedRegistroResultado) {
            _refreshList(
              context,
            );

            return Container(
              color: S2BColors.primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextLabel.h6(
                    'Guardado exitosamente',
                    color: S2BColors.white,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: S2BSpacing.lg,
                  ),
                  Center(
                    child: BtnDefault(
                      UiValues.volver,
                      color: S2BColors.white,
                      colorText: S2BColors.primaryColor,
                      onTap: () {
                        Nav.back(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: S2BSpacing.xs,
                  ),
                  decoration: const BoxDecoration(
                    color: S2BColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                        S2BRadius.lg,
                      ),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: S2BSpacing.md,
                    ).copyWith(
                      bottom: S2BSpacing.zero,
                    ),
                    children: [
                      FormRegister(
                        title: widget.pageArgs.subTitle,
                        subTitle: widget.pageArgs.subTitleQuestion,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _refreshList(BuildContext context) {
    print("😂 Llegue aqui");
    final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';
    context.read<mainBloc.OpsMainBloc>().add(mainBloc.InitEv(
        idSede: idSede, idListaVerificacion: widget.pageArgs.idVerificacion));

    context
        .read<tabCuestionario.TabCuestionarioBloc>()
        .add(tabCuestionario.InitEv(widget.pageArgs.idVerificacion));
  }
}
