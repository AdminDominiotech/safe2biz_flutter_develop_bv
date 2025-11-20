import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/planes_accion/presenter/bloc/sac_bloc.dart';
import 'package:safe2biz/app/modules/planes_accion/presenter/widgets/widgets.dart';
import 'package:safe2biz/app/global/core/core.dart';

class SACBody extends StatelessWidget {
  const SACBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<SACBloc, SACState>(
      listener: (context, state) {
        if (state is FailureGetPlanesAccion) {
          Toast.show(
            description: state.error,
            toastType: ToastType.error,
          );
        }
      },
      child: BlocBuilder<SACBloc, SACState>(
        builder: (context, state) {
          if (state is Loading) {
            return const Scaffold(body: LoadingContainer());
          }
          /*if (state is UploadingActosCondiciones) {
            return const Scaffold(body: LoadingContainer());
          }*/

          return Scaffold(
            backgroundColor: S2BColors.background,
            body: CustomScrollView(
              clipBehavior: Clip.none,
              slivers: [
                SliverPersistentHeader(
                  delegate: SliverBarBack(
                    maxExtended: size.height * .190,
                    minExtended: kToolbarHeight,
                    size: size,
                    title:
                        LocalPreferences.prefs?.getString('current_sede') ?? '',
                    label: 'Planes de Acción',
                    showAction: state.model.planesAccion.isNotEmpty,
                    onTapAction: state.model.planesAccion.isEmpty
                        ? null
                        : () {
                            context.read<SACBloc>().add(
                                  UploadPlanesAccionEv(
                                      planesAccion: state.model.planesAccion),
                                );
                          },
                    showFloating: false,
                  ),
                ),
                state.model.planesAccion.isEmpty
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
                      final planAccion = state.model.planesAccion[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: ItemSAC(planAccion: planAccion), // sin margin interno
                      );
                    },
                    childCount: state.model.planesAccion.length,
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


