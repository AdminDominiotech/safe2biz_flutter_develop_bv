import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/entities.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/detail_acto_condicion/presenter/bloc/detail_ayc_bloc.dart';
import 'package:safe2biz/app/modules/actos_condiciones/features/detail_acto_condicion/presenter/widgets/form_detail_ayc.dart';
import 'package:safe2biz/app/ui/module_ui.dart';
import 'package:safe2biz/app/modules/actos_condiciones/presenter/bloc/ayc_bloc.dart'
    as aycBloc;

class DetailAyCBody extends StatelessWidget {
  DetailAyCBody({Key? key, required this.actoCondicion}) : super(key: key);
  final ActoCondicion actoCondicion;
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
        appBar: AppBarBack(
          LocalPreferences.prefs?.getString('current_sede') ?? '',
          showLogo: false,
          onPressed: () {
            Navigator.of(context).pop(saveOK);
          },
          actions: [
            TextButton.icon(
              label: TextLabel.body(''),
              onPressed: () {
                if (actoCondicion.estado == '0') {
                  _upload(context);
                } else {
                  _delete(context);
                }
              },
              icon: Icon(
                actoCondicion.estado == '0'
                    ? FontAwesomeIcons.upload.data
                    : FontAwesomeIcons.trash.data,
                color: S2BColors.white,
                size: 18,
              ),
            ),
          ],
        ),
        body: BlocListener<DetailAycBloc, DetailAycState>(
          listener: (context, state) {
            if (state is Init || state is Loading) {
              LoadingInfo.show(
                context: context,
                message: 'Cargando...',
              );
            }
            if (state is CloseLoading) {
              Nav.back(context);
            }
            if (state is UploadingActoCondicion) {
              LoadingInfo.show(
                context: context,
                message: 'Subiendo...',
              );
            }
            if (state is EditingActoCondicion) {
              LoadingInfo.show(
                context: context,
                message: 'Editando...',
              );
            }

            if (state is DeletingActoCondicion) {
              LoadingInfo.show(
                context: context,
                message: 'Eliminando...',
              );
            }

            if (state is FailureUploadActoCondicion) {
              Toast.show(
                description: state.error,
                toastType: ToastType.error,
              );
            }

            if (state is FailureEditActoCondicion) {
              Toast.show(
                description: state.error,
                toastType: ToastType.error,
              );
            }

            if (state is FailureDeleteActoCondicion) {
              Toast.show(
                description: state.error,
                toastType: ToastType.error,
              );
            }
          },
          child: BlocBuilder<DetailAycBloc, DetailAycState>(
            buildWhen: (previous, current) => current != previous,
            builder: (context, state) {
              if (state is UploadedActoCondicion ||
                  state is DeletedActoCondicion ||
                  state is EditedActoCondicion) {
                String msg = state is EditedActoCondicion
                    ? 'Editado exitosamente'
                    : state is UploadedActoCondicion
                        ? 'Editado exitosamente'
                        : 'Eliminado exitosamente';

                _refreshList(context);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextLabel.h6(
                      msg,
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
                        onTap: () => Navigator.of(context).pop(saveOK),
                      ),
                    ),
                  ],
                );
              }

              return FormDetailAyC(
                actoCondicion: actoCondicion,
              );
            },
          ),
        ),
      ),
    );
  }

  void _upload(BuildContext context) {
    context.read<DetailAycBloc>().add(
          UploadActoCondicionEv(
            actoCondicion: actoCondicion,
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
        context.read<DetailAycBloc>().add(
              DeleteActoCondicionEv(
                actoCondicion: actoCondicion,
              ),
            );
        Nav.back(context);
      },
    );
  }

  void _refreshList(BuildContext context) {
    final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';
    context.read<aycBloc.AyCBloc>().add(aycBloc.InitEv(idSede: idSede));
  }
}
