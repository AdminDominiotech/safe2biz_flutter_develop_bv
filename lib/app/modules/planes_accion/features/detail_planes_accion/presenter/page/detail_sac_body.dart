import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/planes_accion/features/detail_planes_accion/presenter/bloc/detail_sac_bloc.dart';
import 'package:safe2biz/app/modules/planes_accion/features/detail_planes_accion/presenter/widgets/widgets.dart';
import 'package:safe2biz/app/modules/planes_accion/presenter/bloc/sac_bloc.dart'
    as sacBloc;
import 'package:safe2biz/app/ui/module_ui.dart';

class DetailSACBody extends StatelessWidget {
  DetailSACBody({Key? key, required this.planAccion}) : super(key: key);
  final PlanAccion planAccion;
  bool saveOK = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(saveOK);
        return false;
      },
      child: Scaffold(
        backgroundColor: S2BColors.primaryColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Material(
            child: AppBarBack(
              LocalPreferences.prefs?.getString('current_sede') ?? '',
              showLogo: false,
              onPressed: () {
                Navigator.of(context).pop(saveOK);
              },
              actions: planAccion.estado != ""
                  ? <Widget>[
                TextButton.icon(
                  label: TextLabel.body(''),
                  onPressed: () {
                    if (planAccion.estado == '0') {
                      _upload(context);
                    } else {
                      _delete(context);
                    }
                  },
                  icon: Icon(
                    planAccion.estado == '0'
                        ? FontAwesomeIcons.upload
                        : FontAwesomeIcons.trash,
                    color: S2BColors.white,
                    size: 18,
                  ),
                ),
              ]
                  : <Widget>[],
            ),
          ),
        ),

        body: BlocListener<DetailSACBloc, DetailSACState>(
          listener: (context, state) {
            if (state is FailureUploadPlanAccion) {
              Toast.show(
                description: state.error,
                toastType: ToastType.error,
              );
            }

            if (state is FailureEditPlanAccion) {
              Toast.show(
                description: state.error,
                toastType: ToastType.error,
              );
            }

            if (state is FailureDeletePlanAccion) {
              Toast.show(
                description: state.error,
                toastType: ToastType.error,
              );
            }
          },
          child: BlocBuilder<DetailSACBloc, DetailSACState>(
            builder: (context, state) {
              if (state is UploadingPlanAccion) {
                return const LoadingContainer(
                  color: S2BColors.white,
                );
              }
              if (state is UploadedPlanAccion) {
                saveOK = true;
                _refreshList(context);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextLabel.h6(
                      'Subido exitosamente',
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

              if (state is EditingPlanAccion) {
                return const LoadingContainer(
                  color: S2BColors.white,
                );
              }

              if (state is DeletingPlanAccion) {
                return const LoadingContainer(
                  color: S2BColors.white,
                );
              }

              if (state is DeletedPlanAccion) {
                saveOK = true;
                _refreshList(context);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextLabel.h6(
                      'Eliminado exitosamente',
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

              if (state is EditedPlanAccion) {
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

              return FormDetailSAC(
                planAccion: planAccion,
              );
            },
          ),
        ),
      ),
    );
  }

  void _upload(BuildContext context) {
    context.read<DetailSACBloc>().add(
          UploadPlanAccionEv(
            planAccion: planAccion,
          ),
        );
  }

  void _delete(BuildContext context) {
    PopupMessage(
      context: context,
      title: 'Eliminar registro',
      bodyText: '¿Esta seguro que desea eliminar este registro?',
      isDismissible: false,
      onSucess: () async {
        context.read<DetailSACBloc>().add(
              DeletePlanAccionEv(
                planAccion: planAccion,
              ),
            );
        Nav.back(context);
      },
    );
  }

  void _refreshList(BuildContext context) {
    final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';
    context.read<sacBloc.SACBloc>().add(sacBloc.InitEv(idSede: idSede));
  }
}
