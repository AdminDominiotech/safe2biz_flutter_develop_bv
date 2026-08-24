import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/incidente_accidente/features/detail_incidente_accidente/presenter/bloc/detail_inc_bloc.dart';
import 'package:safe2biz/app/modules/incidente_accidente/features/detail_incidente_accidente/presenter/widgets/widgets.dart';
import 'package:safe2biz/app/modules/incidente_accidente/presenter/bloc/inc_bloc.dart' as incBloc;
import 'package:safe2biz/app/ui/module_ui.dart';

class DetailINCBody extends StatelessWidget {
  DetailINCBody({Key? key, required this.incidenteAccidente}) : super(key: key);
  final IncidenteAccidente incidenteAccidente;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: S2BColors.primaryColor,
      appBar: AppBarBack(
        LocalPreferences.prefs?.getString('current_sede') ?? '',
        showLogo: false,
        onPressed: () {
          Nav.back(context);
        },
        actions: [
          TextButton.icon(
            label: TextLabel.body(''),
            onPressed: () {
              if (incidenteAccidente.estado == '0') {
                _upload(context);
              } else {
                _delete(context);
              }
            },
            icon: Icon(
              incidenteAccidente.estado == '0'
                  ? FontAwesomeIcons.upload.data
                  : FontAwesomeIcons.trash.data,
              color: S2BColors.white,
              size: 18,
            ),
          ),
        ],
      ),
      body: BlocListener<DetailINCBloc, DetailINCState>(
        listener: (context, state) {
          if (state is Init || state is Loading) {
            return LoadingInfo.show(
              context: context,
              message: 'Cargando...',
            );
          }
          if (state is EditingIncidenteAccidente) {
            return LoadingInfo.show(
              context: context,
              message: 'Editando...',
            );
          }
          if (state is DeletingIncidenteAccidente) {
            return LoadingInfo.show(
              context: context,
              message: 'Eliminando...',
            );
          }
          if (state is UploadingIncidenteAccidente) {
            return LoadingInfo.show(
              context: context,
              message: 'Subiendo...',
            );
          }

          if (state is CloseLoading) {
            Nav.back(context);
          }

          if (state is FailureUploadIncidenteAccidente) {
            Toast.show(
              description: state.error,
              toastType: ToastType.error,
            );
          }

          if (state is FailureEditIncidenteAccidente) {
            Toast.show(
              description: state.error,
              toastType: ToastType.error,
            );
          }

          if (state is FailureDeleteIncidenteAccidente) {
            Toast.show(
              description: state.error,
              toastType: ToastType.error,
            );
          }
        },
        child: BlocBuilder<DetailINCBloc, DetailINCState>(
          builder: (context, state) {
            if (state is UploadedIncidenteAccidente ||
                state is EditedIncidenteAccidente ||
                state is DeletedIncidenteAccidente) {
              _refreshList(context);
              final message = state is EditedIncidenteAccidente
                  ? 'Guardado exitosamente'
                  : state is DeletedIncidenteAccidente
                      ? 'Eliminado exitosamente'
                      : 'Subido exitosamente';
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextLabel.h6(
                    message,
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
                      onTap: () => Navigator.of(context).pop(),
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
                        FormDetailINC(incidenteAccidente: incidenteAccidente),
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

  void _upload(BuildContext context) {
    context.read<DetailINCBloc>().add(
      UploadIncidenteAccidenteEv(
        incidenteAccidente: incidenteAccidente,
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
        context.read<DetailINCBloc>().add(
              DeleteIncidenteAccidenteEv(
                incidenteAccidente: incidenteAccidente,
              ),
            );
        Nav.back(context);
      },
    );
  }

  void _refreshList(BuildContext context) {
    final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';
    context.read<incBloc.INCBloc>().add(incBloc.InitEv(idSede: idSede));
  }
}
