import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/incidente_accidente/features/register_incidente_accidente/presenter/bloc/bloc.dart';
import 'package:safe2biz/app/modules/incidente_accidente/features/register_incidente_accidente/presenter/widgets/widgets.dart';
import 'package:safe2biz/app/modules/incidente_accidente/presenter/bloc/inc_bloc.dart'
    as incBloc;

import 'package:safe2biz/app/ui/module_ui.dart';

class RegisterINCBody extends StatelessWidget {
  RegisterINCBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: S2BColors.primaryColor,
      appBar: AppBarBack(
        LocalPreferences.prefs?.getString('current_sede') ?? '',
        showLogo: false,
      ),
      body: BlocListener<RegisterINCBloc, RegisterINCState>(
        listener: (context, state) {
          if (state is Init || state is Loading) {
            return LoadingInfo.show(
              context: context,
              message: 'Cargando...',
            );
          }
          if (state is Loaded) {
            Nav.back(context);
          }

          if (state is SavingIncidenteAccidente) {
            return LoadingInfo.show(
              context: context,
              message: 'Guardando...',
            );
          }
          if (state is SavedIncidenteAccidente) {
            Nav.back(context);
          }

          if (state is FailureSaveIncidenteAccidente) {
            Nav.back(context);
            Toast.show(
              description: state.error,
              toastType: ToastType.error,
            );
          }
        },
        child: BlocBuilder<RegisterINCBloc, RegisterINCState>(
          builder: (context, state) {
            if (state is SavedIncidenteAccidente) {
              _refreshList(context);
              return Column(
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
                      onTap: () => Nav.back(context),
                    ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(S2BSpacing.lg),
                  child: TextLabel.body(
                    'Incidentes y Accidentes',
                    color: S2BColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                        FormINC(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _refreshList(BuildContext context) {
    final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';
    context.read<incBloc.INCBloc>().add(incBloc.InitEv(idSede: idSede));
  }
}
