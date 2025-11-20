import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/features/detail_ops/presenter/bloc/detail_ops_bloc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/features/detail_ops/presenter/models/page_arguments.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/features/detail_ops/presenter/widgets/form_detail.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/bloc/tab_cuestionario/bloc.dart'
    as tabCuestionario;
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/bloc/ops_main_bloc.dart'
    as mainBloc;
import 'package:safe2biz/app/ui/module_ui.dart';

class TabDetailOpsBody extends StatefulWidget {
  TabDetailOpsBody({
    Key? key,
    required this.pageArgs,
  }) : super(key: key);

  final DetailOpsPageArgs pageArgs;

  @override
  State<TabDetailOpsBody> createState() => _TabDetailOpsBodyState();
}

class _TabDetailOpsBodyState extends State<TabDetailOpsBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        widget.pageArgs.title,
      ),
      body: BlocConsumer<DetailOpsBloc, DetailOpsState>(
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
          if (state is EditingRegistroResultado) {
            LoadingInfo.show(
              context: context,
              message: 'Editando...',
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
          if (state is SavedRegistroResultado ||
              state is EditedRegistroResultado) {
            _refreshList(
              context,
            );

            return Container(
              color: S2BColors.primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextLabel.h6(
                    state is EditedRegistroResultado
                        ? 'Editado exitosamente'
                        : 'Guardado exitosamente',
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
                      FormDetail(
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
    final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';
    context.read<mainBloc.OpsMainBloc>().add(mainBloc.InitEv(
        idSede: idSede, idListaVerificacion: widget.pageArgs.idVerificacion));

    context
        .read<tabCuestionario.TabCuestionarioBloc>()
        .add(tabCuestionario.InitEv(widget.pageArgs.idVerificacion));
  }
}
