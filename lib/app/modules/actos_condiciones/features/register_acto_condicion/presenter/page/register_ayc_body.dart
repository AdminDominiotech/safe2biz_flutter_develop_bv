import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/register_acto_condicion/presenter/bloc/register_ayc_bloc.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/register_acto_condicion/presenter/widgets/widgets.dart';
import 'package:safe2biz/app/modules/actos_condiciones/presenter/bloc/ayc_bloc.dart'
    as aycBloc;
import 'package:safe2biz/app/ui/module_ui.dart';

class RegisterAyCBody extends StatelessWidget {
  RegisterAyCBody({Key? key}) : super(key: key);

  bool saveOK = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Nav.back(context, saveOK);
        return false;
      },
      child: Scaffold(
        backgroundColor: S2BColors.primaryColor,
        appBar: AppBarBack(
          LocalPreferences.prefs?.getString('current_sede') ?? '',
          showLogo: false,
          onPressed: () {
            Nav.back(context, saveOK);
          },
        ),
        body: BlocListener<RegisterAyCBloc, RegisterAyCState>(
          listener: (context, state) {
            if (state is Loading) {
              LoadingInfo.show(
                context: context,
                message: 'Cargando...',
              );
            }
            if (state is CloseLoading) {
              Nav.back(context);
            }

            if (state is SavingActoCondicion) {
              LoadingInfo.show(
                context: context,
                message: 'Guardando...',
              );
            }

            if (state is FailureSaveActoCondicion) {
              Toast.show(
                description: state.error,
                toastType: ToastType.error,
              );
            }
          },
          child: BlocBuilder<RegisterAyCBloc, RegisterAyCState>(
            buildWhen: (previous, current) => current != previous,
            builder: (context, state) {
              if (state is SavedActoCondicion) {
                saveOK = true;

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

                        // paddingH: S2BSpacing.xxsl,
                        onTap: () => Navigator.of(context).pop(saveOK),
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
                      'ACTOS Y CONDICIONES INSEGURAS',
                      color: S2BColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  FormAyC(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _refreshList(BuildContext context) {
    final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';
    context.read<aycBloc.AyCBloc>().add(aycBloc.InitEv(idSede: idSede));
  }
}
