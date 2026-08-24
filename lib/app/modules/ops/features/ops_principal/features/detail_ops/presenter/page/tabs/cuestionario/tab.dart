import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/features/detail_ops/presenter/models/page_arguments.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/features/detail_ops/presenter/page/detail_ops_page.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/bloc/tab_cuestionario/bloc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/models/models.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/bloc/ops_main_bloc.dart'
as mainBloc;

class TabCuestionario extends StatefulWidget {
  const TabCuestionario({
    Key? key,
    required this.pageArgs,
  }) : super(key: key);

  final DetailOpsPrincipalPageArgs pageArgs;

  @override
  State<TabCuestionario> createState() => _TabCuestionarioState();
}

class _TabCuestionarioState extends State<TabCuestionario>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<TabCuestionarioBloc, TabCuestionarioState>(
      listener: (context, state) {},
      child: BlocBuilder<TabCuestionarioBloc, TabCuestionarioState>(
        builder: (context, state) {
          if (state is Loading) {
            return Center(
              child: LoadingContainer(),
            );
          }
          if (state is Loaded) {
            return Container(
              color: S2BColors.white,
              child: ListView(
                children: [
                  ...state.model.categories.map(
                        (e) {
                      final listSec = state.model.sections
                          .where((element) => element.idReference == e.id)
                          .toList();
                      return ExpansionTile(
                        initiallyExpanded: true,
                        leading: Icon(
                          FontAwesomeIcons.caretDown.data,
                          // color: S2BColors.dangerColor,
                        ),
                        collapsedIconColor: S2BColors.silver,
                        iconColor: S2BColors.primaryColor,
                        trailing: const SizedBox.shrink(),
                        title: TextLabel.h6(
                          e.nombre,
                          color: S2BColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          ...listSec.map(
                                (s) {
                              final listPre = state.model.questions
                                  .where(
                                    (e) => e.idReference == s.id,
                              )
                                  .toList();
                              return ExpansionTile(
                                initiallyExpanded: true,
                                leading: Icon(
                                  FontAwesomeIcons.caretDown.data,
                                ),
                                collapsedIconColor: S2BColors.silver,
                                iconColor: S2BColors.primaryColor,
                                trailing: const SizedBox.shrink(),
                                title: TextLabel.body(
                                  s.nombre,
                                  color: S2BColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  ...listPre.map(
                                        (p) {
                                      return ListTile(
                                        onTap: () {
                                          print(s.nombre);
                                          Nav.go(
                                            context,
                                            BlocProvider.value(
                                              value: context
                                                  .read<mainBloc.OpsMainBloc>(),
                                              child: BlocProvider.value(
                                                value: context.read<
                                                    TabCuestionarioBloc>(),
                                                child: TabDetailOpsPage(
                                                  pageArgs: DetailOpsPageArgs(
                                                    title:
                                                    widget.pageArgs.title,
                                                    subTitleQuestion: p.nombre,
                                                    subTitle: s.nombre,
                                                    idVerificacion: widget
                                                        .pageArgs
                                                        .idVerificacion,
                                                    idResultadoOps: widget
                                                        .pageArgs
                                                        .idResultadoOps,
                                                    opsRegistroGeneralesId:
                                                    widget
                                                        .pageArgs.idGeneral,
                                                    opsListaVerifCategoriaId:
                                                    '${e.id}',
                                                    opsListaVerifSeccionId:
                                                    '${s.id}',
                                                    opsListaVerifPreguntaId:
                                                    '${p.id}',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },

                                        leading: Padding(
                                          padding: const EdgeInsets.only(
                                            left: S2BSpacing.xs,
                                            top: S2BSpacing.xs,
                                          ),
                                          child: CircleAvatar(
                                            backgroundColor: showColors(p.tag),
                                            maxRadius: 8,
                                          ),
                                        ),
                                        title: TextLabel.labelText(
                                          p.nombre,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        trailing: Icon(
                                          FontAwesomeIcons.caretRight.data,
                                          color: S2BColors.graySecondary,

                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  //Colores Cuestionario - Lista Preguntas

  Color showColors(String code) {
    // si code no está vacío, devolvemos verde, si no, transparente:
    return code.trim().isNotEmpty
        ? Colors.green
        : Colors.transparent;
  }


  @override
  bool get wantKeepAlive => true;
}