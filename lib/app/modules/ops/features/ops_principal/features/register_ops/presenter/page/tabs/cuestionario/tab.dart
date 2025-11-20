import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/features/register_ops/presenter/models/models.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/features/register_ops/presenter/page/register_ops_page.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/bloc/tab_cuestionario/bloc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/bloc/ops_main_bloc.dart' as mainBloc;

class TabCuestionario extends StatefulWidget {
  const TabCuestionario({
    Key? key,
    required this.title,
    required this.opsRegistroGeneralesId,
    required this.idResultadoOps,
    required this.idVerificacion,
  }) : super(key: key);

  final String title;
  final String opsRegistroGeneralesId;
  final String idResultadoOps;
  final String idVerificacion;

  @override
  State<TabCuestionario> createState() => _TabCuestionarioState();
}

class _TabCuestionarioState extends State<TabCuestionario>
    with AutomaticKeepAliveClientMixin {

  Set<String> answeredIds = {};

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  void asyncMethod() async{
    await _loadAnsweredIds();
  }
  Future<void> _loadAnsweredIds() async {
    final db = await LocalSqlite().database;
    final rows = await db.rawQuery(
      '''
      SELECT DISTINCT ops_lista_verif_pregunta_id AS pid
        FROM ${LocalSqlite.TABLE_OPS_REGISTRO_RESULTADO}
       WHERE ops_registro_generales_id = ?
      ''',
      [widget.opsRegistroGeneralesId],
    );
    setState(() {
      answeredIds = rows.map((r) => r['pid'] as String).toSet();
    });
  }

  /*
  Future<void> _loadAnsweredIds() async {
    final db = await LocalSqlite().database;
    final rows = await db.rawQuery(
      '''
    SELECT DISTINCT ops_lista_verif_pregunta_id AS pid
      FROM ${LocalSqlite.TABLE_OPS_REGISTRO_RESULTADO}
     WHERE ops_registro_generales_id = ?
    ''',
      [widget.opsRegistroGeneralesId],
    );

    // Para depurar, imprime qué devuelve la consulta:
    print('🏷️ rows from DB: $rows');

    final ids = rows
        .map((r) => r['pid']?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toSet();

    print('✅ answeredIds cargadas: $ids');

    setState(() {
      answeredIds = ids;
    });
  }
  }
   */
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
                          FontAwesomeIcons.caretDown,
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
                                  FontAwesomeIcons.caretDown,
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
                                          Nav.go(
                                            context,
                                            BlocProvider.value(
                                                value: context.read<
                                                    mainBloc.OpsMainBloc>(),
                                                child: BlocProvider.value(
                                                  value: context.read<
                                                      TabCuestionarioBloc>(),
                                                  child: TabRegisterOpsPage(
                                                    pageArgs:
                                                        RegisterOpsPageArgs(
                                                      title: widget.title,
                                                      subTitle: s.nombre,
                                                      subTitleQuestion:
                                                          p.nombre,
                                                      idResultadoOps:
                                                          widget.idResultadoOps,
                                                      idVerificacion:
                                                          widget.idVerificacion,
                                                      opsRegistroGeneralesId: widget
                                                          .opsRegistroGeneralesId,
                                                      opsListaVerifCategoriaId:
                                                          '${e.id}',
                                                      opsListaVerifSeccionId:
                                                          '${s.id}',
                                                      opsListaVerifPreguntaId:
                                                          '${p.id}',
                                                    ),
                                                  ),
                                                )),
                                          ).then((_) {
                                            // ≤–– cuando vuelvas, recargamos los contestados
                                            _loadAnsweredIds();
                                            });


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
                                          fontWeight: FontWeight.w400,
                                        ),
                                        trailing: Icon(
                                          FontAwesomeIcons.caretRight,
                                          color: S2BColors.silver,
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
  Color showColors(String code) {
    // si code no está vacío, devolvemos verde, si no, transparente:
    return code.trim().isNotEmpty
        ? Colors.green
        : Colors.transparent;
  }


  @override
  bool get wantKeepAlive => true;
}