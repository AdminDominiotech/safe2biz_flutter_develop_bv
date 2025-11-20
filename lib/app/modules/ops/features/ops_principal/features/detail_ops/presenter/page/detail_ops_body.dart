import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/bloc/tab_generales/bloc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/models/page_arguments.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/page/tabs/cuestionario/tab.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/page/tabs/generales/tab.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/bloc/ops_main_bloc.dart'
    as mainBloc;
import 'package:safe2biz/app/ui/module_ui.dart';

class DetailOpsBody extends StatefulWidget {
  final int? ops_tipo_checklist_id;

  const DetailOpsBody({
    Key? key,
    required this.pageArgs,
    required this.registroGeneral,
    this.ops_tipo_checklist_id
  }) : super(key: key);

  final DetailOpsPrincipalPageArgs pageArgs;
  final RegistroGeneral registroGeneral;

  @override
  State<DetailOpsBody> createState() => _DetailOpsBodyState();
}

class _DetailOpsBodyState extends State<DetailOpsBody> {
  bool saveOK = false;
  List<RegistroResultado> _registrosResultados = [];
  @override
  void initState() {
    super.initState();
  }

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
          actions: [
            TextButton.icon(
              label: TextLabel.body(''),
              onPressed: () {
                if (widget.registroGeneral.estado == '0') {
                  _upload(context);
                } else {
                  _delete(context);
                }
              },
              icon: Icon(
                widget.registroGeneral.estado == '0'
                    ? FontAwesomeIcons.upload
                    : FontAwesomeIcons.trash,
                color: S2BColors.white,
                size: 18,
              ),
            ),
          ],
        ),
        body: BlocConsumer<TabGeneralDetailOpsBloc, TabGeneralDetailOpsState>(
          listener: (context, state) {
            if (state is Loaded) {
              _registrosResultados = state.registrosResultados;
            }
            if (state is Loading) {
              LoadingInfo.show(
                context: context,
                message: 'Cargando...',
              );
            }
            if (state is EditingListaVerificacion) {
              LoadingInfo.show(
                context: context,
                message: 'Guardando...',
              );
            }
            //if (state is Loaded) {Nav.back(context)},
            if (state is CloseLoading) {
              Nav.back(context);
            }
            if (state is EditedListaVerificacion) {
              Toast.show(
                description: 'Guardado exitosamente',
              );
              _refreshList(
                context,
              );
            }

            if (state is DeletingRegistrosGenerales) {
              LoadingInfo.show(
                context: context,
                message: 'Eliminando...',
              );
            }

            if (state is FailureDeleteRegistrosGenerales) {
              Toast.show(
                description: state.error,
                toastType: ToastType.error,
              );
            }
            if (state is FailureEditListaVerificacion) {
              Toast.show(
                description: state.error,
                toastType: ToastType.error,
              );
            }
            if (state is UploadingRegistrosGenerales) {
              return LoadingInfo.show(
                context: context,
                message: 'Subiendo...',
              );
            }
            if (state is FailureUploadRegistrosGenerales) {
              Toast.show(
                description: state.error,
                toastType: ToastType.error,
              );
            }
          },
          builder: (context, state) {
            if (state is UploadedRegistrosGenerales ||
                state is DeletedRegistrosGenerales) {
              _refreshList(context);
              final message = state is DeletedRegistrosGenerales
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
            return CustomTabBar(
              tabs: [
                'DATOS GENERALES',
                if (widget.registroGeneral.estado != '1') 'CUESTIONARIO',
              ],
              children: [
                TabGenerales(
                  registroGeneral: widget.registroGeneral,
                    ops_tipo_checklist_id: widget.ops_tipo_checklist_id
                ),
                if (widget.registroGeneral.estado != '1')
                  TabCuestionario(
                    pageArgs: widget.pageArgs,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _upload(BuildContext context) {
    final auth = GetIt.I<AuthController>();
    final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';
    context.read<TabGeneralDetailOpsBloc>().add(
          UploadRegistrosGeneralesEv(
            registroGeneral: widget.registroGeneral,
            registrosResultados: _registrosResultados,
            idSede: idSede,
            idUser: auth.getID,
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
        context.read<TabGeneralDetailOpsBloc>().add(
              DeleteRegistrosGeneralesEv(
                registroGeneral: widget.registroGeneral,
              ),
            );
        Nav.back(context);
      },
    );
  }

  void _refreshList(BuildContext context) {
    final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';
    context.read<mainBloc.OpsMainBloc>().add(
          mainBloc.InitEv(
            idSede: idSede,
            idListaVerificacion: widget.pageArgs.idVerificacion,
          ),
        );
  }
}
