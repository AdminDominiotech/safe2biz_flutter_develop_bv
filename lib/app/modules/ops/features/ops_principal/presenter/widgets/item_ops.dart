import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/global/core/micro_services/dio_micro_services.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/external/api/lista_verificacion_api.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/bloc/tab_generales/bloc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/models/page_arguments.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/page/detail_ops_page.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/bloc/ops_main_bloc.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/models/models.dart';

import '../../../../../../global/controllers/auth_controller.dart';


class ItemOps extends StatefulWidget {
  final int? ops_tipo_checklist_id;

  const ItemOps({
    Key? key,
    required this.registroGeneral,
    required this.pageArgs,
    this.ops_tipo_checklist_id

  }) : super(key: key);

  final RegistroGeneral registroGeneral;
  final OpsPrincipalPageArgs pageArgs;

  @override
  State<ItemOps> createState() => _ItemOpsState();
}

final formKey = GlobalKey<FormState>();
enum EstadoItem { incompleto, completado, enviado }

class _ItemOpsState extends State<ItemOps> {

  late bool _esPendiente;

  EstadoItem _estado = EstadoItem.incompleto;


  @override
  void initState() {
    super.initState();
    _esPendiente = widget.registroGeneral.estado == '0'; // o 'null'
    // Si quieres basarte en la tabla resultado:
    _cargarEstadoDesdeLocal();
  }


  @override
  Widget build(BuildContext context) {
    final bool esPendiente = _esPendiente;

    final rg = widget.registroGeneral;
    final area    = (rg.fbAreaNombre ?? '').trim();
    final empresa = (rg.fbEmpresaEspecializadaNombre ?? '').trim();

    final etiqueta = area.isNotEmpty ? 'Área: ' : 'Empresa: ';
    final valor    = area.isNotEmpty ? area : (empresa.isNotEmpty ? empresa : '-');

    // Colores
    final Color colorPendiente = const Color(0xFFFEF16A); // amarillo pastel
    final Color textoPendiente = const Color(0xFF856404);
    final Color colorEnviado   = const Color(0xFFC8F7C5); // verde pastel
    final Color textoEnviado   = const Color(0xFF1B5E20);

    Color bgColor;
    Color textColor;
    String label;
    IconData iconRight;

    switch (_estado) {
      case EstadoItem.enviado:
        bgColor   = const Color(0xFFC8F7C5); // verde suave
        textColor = const Color(0xFF1B5E20);
        label     = 'Enviado';
        iconRight = FontAwesomeIcons.trash.data;
        break;
      case EstadoItem.completado:
        bgColor   = const Color(0xFFC8F7C5); // verde pastel
        textColor = const Color(0xFF1B5E20);
        label     = 'Completo';              // ← aquí
        iconRight = FontAwesomeIcons.check.data;  // o el que prefieras
        break;
      case EstadoItem.incompleto:
      default:
        bgColor   = const Color(0xFFFEF16A); // amarillo pastel
        textColor = const Color(0xFF856404);
        label     = 'Incompleto';
        iconRight = FontAwesomeIcons.upload.data;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: S2BSpacing.xs,
        vertical: S2BSpacing.sm,
      ).copyWith(top: S2BSpacing.zero),
      child: InkWell(
        onTap: () {
      context.read<OpsMainBloc>().add(
        UpdatePreguntasEv(
          idVerificacion: widget.pageArgs.idVerificacionOps,
          idGeneral: widget.registroGeneral.id.toString(),
        ),
      );
      Nav.go(
        context,
        BlocProvider.value(
          value: context.read<OpsMainBloc>(),
          child: DetailOpsPage(
            pageArgs: DetailOpsPrincipalPageArgs(
              title: widget.pageArgs.nombreOps,
              idResultadoOps: widget.pageArgs.idResultadoOps,
              idGeneral: widget.registroGeneral.id.toString(),
              idVerificacion: widget.pageArgs.idVerificacionOps,
            ),
            registroGeneral: widget.registroGeneral,
              ops_tipo_checklist_id: widget.ops_tipo_checklist_id
          ),
        ),
      );

        },
        splashColor: Colors.red,
        child: PhysicalModel(
          borderRadius: const BorderRadius.all(Radius.circular(S2BRadius.xs)),
          color: Colors.white,
          elevation: 2,
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Franja izquierda
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(S2BRadius.xs),
                      bottomLeft: Radius.circular(S2BRadius.xs),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                // Contenido
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: S2BSpacing.sm,
                      vertical: S2BSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.checklist_outlined,
                                size: 20, color: S2BColors.primaryColor),
                            const SizedBox(width: 10),

                    Expanded(
                      child: TextLabel.body(
                        widget.registroGeneral.OpsSubTipoInspeccionText,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.start,
                        color: S2BColors.primaryColor,
                        // Si tu TextLabel expone esto, déjalo; si no, quítalo.
                        maxLines: null, // permite varias líneas (suele bastar)


                              ),
                            )
                          ],
                        ),
                        const Divider(color: Colors.grey, height: 10),
                        const SizedBox(height: S2BSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    etiqueta,
                                    style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
                                  ),
                                  const SizedBox(width: 0),
                                  Expanded(
                                    child: TextLabel.labelText(
                                      valor, // Área o Empresa (o '-')
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextLabel.labelText(
                              rg.fechaOps ?? '',
                              fontWeight: FontWeight.w500,
                              color: Colors.indigo,

                            ),
                          ],
                        ),
                        const SizedBox(height: S2BSpacing.sm),

                        const Divider(color: Colors.grey, height: 12),
                        const SizedBox(height: 2),
                        // Estado + icono derecha
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: InkWell(
                                onTap: () {
                                  switch (_estado) {
                                    case EstadoItem.completado:
                                    // Solo si está completado permitimos subir
                                      _upload(context);
                                      break;
                                    case EstadoItem.incompleto:
                                    // Si está incompleto, mostramos alerta
                                      Toast.show(
                                        description: 'Debe responder todas las preguntas',
                                        toastType: ToastType.warning,
                                      );
                                      break;
                                    case EstadoItem.enviado:
                                    // Si ya se envió, eliminamos
                                      _delete(context);
                                      break;
                                  }
                                },
                                child: Icon(
                                  _estado == EstadoItem.enviado
                                      ? FontAwesomeIcons.trash.data
                                      : FontAwesomeIcons.upload.data,
                                  color: _estado == EstadoItem.enviado
                                      ? S2BColors.dangerColor
                                      : S2BColors.primaryColor,
                                  size: 15,
                                ),
                              ),
                            ),


                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
        context.read<OpsMainBloc>().add(
              DeleteListaVerificacionEv(
                registroGeneral: widget.registroGeneral,
              ),
            );
        Nav.back(context);
      },
    );
  }

  Future<void> _upload(BuildContext context) async {
    final auth   = GetIt.I<AuthController>();
    final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';
    final api    = ListaVerificacionApi(dioMicroServices: GetIt.I<DioMicroServices>());

    LoadingInfo.show(context: context, message: 'Subiendo...');
    try {
      await api.uploadRegistroCompleto(
        widget.registroGeneral,
        [],
        auth.getID,
        idSede,
      );

      if (!mounted) return;
      // ← Aquí: recarga la lógica de estado
      await _cargarEstadoDesdeLocal();

      Nav.back(context);
      Toast.show(description: 'Subido exitosamente');
    } catch (e) {
      Nav.back(context);
      Toast.show(description: e.toString(), toastType: ToastType.error);
    }
  }



  Future<void> _cargarEstadoDesdeLocal() async {
    final db    = await LocalSqlite().database;
    final idGen = widget.registroGeneral.id.toString();
    final idVer = widget.pageArgs.idVerificacionOps;

    // 1) ¿Ya se subió? Si existe un resultado con estado = 1 → Enviado
    final enviadoRes = await db.rawQuery(
      '''
      SELECT 1 AS enviado
      FROM ${LocalSqlite.TABLE_OPS_REGISTRO_RESULTADO}
      WHERE ops_registro_generales_id = ?
        AND estado = 1
      LIMIT 1
      ''',
      [idGen],
    );
    if (enviadoRes.isNotEmpty) {
      setState(() => _estado = EstadoItem.enviado);
      print('✅ Estado: Enviado');
      return;
    }

    // 2) ¿Todas respondidas? Contamos preguntas vs respuestas
    final preguntasRes = await db.rawQuery(
      '''
      SELECT COUNT(*) AS cnt
      FROM ${LocalSqlite.TABLE_OPS_LISTA_VERIF_PREGUNTA}
      WHERE ops_lista_verificacion_id = ?
      ''',
      [idVer],
    );
    final totalPreguntas = preguntasRes.first['cnt'] as int? ?? 0;

    final respuestasRes = await db.rawQuery(
      '''
      SELECT COUNT(DISTINCT ops_lista_verif_pregunta_id) AS cnt
      FROM ${LocalSqlite.TABLE_OPS_REGISTRO_RESULTADO}
      WHERE ops_registro_generales_id = ?
      ''',
      [idGen],
    );
    final totalRespondidas = respuestasRes.first['cnt'] as int? ?? 0;

    final completado = totalPreguntas > 0 && totalRespondidas >= totalPreguntas;

    setState(() => _estado = completado
        ? EstadoItem.completado
        : EstadoItem.incompleto
    );

    print('📋 Verif $idVer → preguntas=$totalPreguntas, respondidas=$totalRespondidas');
    print(completado
        ? '✅ Estado: Completado'
        : '⚠️ Estado: Incompleto');
  }



}




