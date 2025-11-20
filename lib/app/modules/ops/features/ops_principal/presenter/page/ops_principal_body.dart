import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/models/models.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/page/register_ops_page.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/bloc/ops_main_bloc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/models/models.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/widgets/widgets.dart';

class OpsPrincialBody extends StatelessWidget{
  final int? ops_tipo_checklist_id;

  final int? ops_sub_tipo_id;
  const OpsPrincialBody({
    Key? key,
    required this.pageArgs,
    this.ops_tipo_checklist_id,

    this.ops_sub_tipo_id

  }) : super(key: key);

  final OpsPrincipalPageArgs pageArgs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<OpsMainBloc, OpsMainState>(
      listener: (context, state) {
        if (state is FailureGetListaVerificacion) {
          Toast.show(
            description: state.error,
            toastType: ToastType.error,
          );
        }
        /*if (state is UploadedActosCondiciones) {
             Toast.show(
               description: state.message,
               toastType: ToastType.success,
             );
           }
           if (state is FailureDeleteActoCondicion) {
             Toast.show(
               description: state.error,
               toastType: ToastType.success,
             );
           }
           if (state is FailureUploadActosCondiciones) {
             Toast.show(
               description: state.error,
               toastType: ToastType.error,
             );
           }*/
      },
      child: BlocBuilder<OpsMainBloc, OpsMainState>(
        builder: (context, state) {
          if (state is Loading) {
            return const Scaffold(body: LoadingContainer());
          }
          /*if (state is UploadingActosCondiciones) {
             return const Scaffold(body: LoadingContainer());
           }*/
          print('ok: ${state.model.registroGeneral.length}');
          return Scaffold(
            backgroundColor: S2BColors.background,
            body: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: SliverBarBack(
                    maxExtended: size.height * .195,
                    minExtended: kToolbarHeight,
                    size: size,
                    title:
                        LocalPreferences.prefs?.getString('current_sede') ?? '',
                    label: pageArgs.nombreOps,
                    onFloatingTap: () async {
                      await Nav.go(
                        context,
                        BlocProvider.value(
                          value: context.read<OpsMainBloc>(),
                          child: RegisterOpsPage(
                            // verificationId: '1',
                            pageArgs: RegisterOpsPrincipalPageArgs(
                              title: pageArgs.nombreOps,
                              idResultadoOps: pageArgs.idResultadoOps,
                              verificationId: pageArgs.idVerificacionOps,
                            ),
                            ops_tipo_checklist_id: ops_tipo_checklist_id,
                              ops_sub_tipo_id: ops_sub_tipo_id
                          ),
                        ),
                      );
                    },
                  ),
                ),
                state.model.registroGeneral.isEmpty
                    ? SliverToBoxAdapter(
                        child: SizedBox(
                          width: size.width,
                          height: size.height,
                          child: const EmptyData(),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int i) {
                            final registroGeneral = state.model.registroGeneral;
                            return ItemOps(
                              registroGeneral: registroGeneral[i],
                              pageArgs: pageArgs,
                              ops_tipo_checklist_id: ops_tipo_checklist_id,

                            );
                          },
                          childCount: state.model.registroGeneral.length,
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
