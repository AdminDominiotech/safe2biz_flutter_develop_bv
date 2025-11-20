import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/register_acto_condicion/presenter/page/register_ayc_page.dart';
import 'package:safe2biz/app/modules/actos_condiciones/presenter/bloc/ayc_bloc.dart';
import 'package:safe2biz/app/modules/actos_condiciones/presenter/widgets/widgets.dart';
import 'package:safe2biz/app/global/core/core.dart';

class AyCBody extends StatelessWidget {
  const AyCBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<AyCBloc, AyCState>(
      listener: (context, state) {
        if (state is FailureGetActosCondiciones) {
          Toast.show(
            description: state.error,
            toastType: ToastType.error,
          );
        }
        if (state is UploadedActosCondiciones) {
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
        }
      },
      child: BlocBuilder<AyCBloc, AyCState>(
        builder: (context, state) {
          if (state is Loading) {
            return const Scaffold(body: LoadingContainer());
          }
          if (state is UploadingActosCondiciones) {
            return const Scaffold(body: LoadingContainer());
          }

          return Scaffold(
            backgroundColor: S2BColors.background,
            body: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: SliverBarBack(
                    maxExtended: size.height * .190,
                    minExtended: kToolbarHeight,
                    size: size,
                    title:
                        LocalPreferences.prefs?.getString('current_sede') ?? '',
                    label: 'Actos y Condiciones Inseguras',

                    showAction: state.model.actosCondiciones.any((ayc) => ayc.estado == '0'),
                    onTapAction: !state.model.actosCondiciones.any((ayc) => ayc.estado == '0')
                        ? null
                        : () {
                      // Filtra solo los incidentes con estado '0' para la carga
                      final actoCondicionPorSubir = state.model.actosCondiciones
                          .where((ayc) => ayc.estado == '0')
                          .toList();

                      context.read<AyCBloc>().add(
                        UploadActosCondicionesEv(
                          actosCondiciones: actoCondicionPorSubir,
                        ),
                      );
                    },
                    onFloatingTap: () async {
                      //if (await AppLocationPermission.checkPermission()) {
                      await Nav.go(
                        context,
                        BlocProvider.value(
                          value: context.read<AyCBloc>(),
                          child: RegisterAyCPage(),
                        ),
                      );
                      /*} else {
                        Nav.go(
                          context,
                          const LocationPermissionPage(),
                        );
                      }*/
                    },
                  ),
                ),
                state.model.actosCondiciones.isEmpty
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
                            final actosCondiciones =
                                state.model.actosCondiciones;
                            return ItemAyC(
                              actoCondicion: actosCondiciones[i],
                            );
                          },
                          childCount: state.model.actosCondiciones.length,
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
