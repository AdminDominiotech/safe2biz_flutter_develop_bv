import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/library/assets.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/models/page_arguments.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/presenter/page/ops_principal_page.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/verificacion_ops.dart';

class ItemOps extends StatelessWidget {
  final int? ops_tipo_checklist_id;
  const ItemOps({
    Key? key,
    required this.verificacionOps,
    this.ops_tipo_checklist_id
  }) : super(key: key);

  final VerificacionOps verificacionOps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(S2BSpacing.sm),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(S2BRadius.xs),
        color: S2BColors.white,
        elevation: 5,
        child: ListTile(
          horizontalTitleGap: S2BSpacing.xs,
          onTap: () async{
           // final subTipoId = await _findSubTipoIdFromCodigo(verificacionOps.codigo);
            Nav.go(
              context,
              OpsPrincipalPage(
                pageArgs: OpsPrincipalPageArgs(
                  idResultadoOps: verificacionOps.opsTipoResultadoId,
                  idVerificacionOps: verificacionOps.id,
                  nombreOps: verificacionOps.nombre,

                ),
                ops_tipo_checklist_id: ops_tipo_checklist_id,
                ops_sub_tipo_id: int.tryParse(verificacionOps.opsSubTipoChecklistId) ?? 0,

              ),
            );
          },
          leading: Padding(
            padding: const EdgeInsets.only(
              left: S2BSpacing.xxs,
              top: S2BSpacing.xxs,
              right: S2BSpacing.xxs,
            ),
            child: SizedBox(
              width: 30.0,
              child: ImageIcon(
                AssetImage(
                  AppAssets.iconTablero,
                ),
                color: S2BColors.orange,
                size: 24,
              ),
              height: 40.0,
            ),
          ),
          title: TextLabel.body(
            verificacionOps.nombre,
            fontWeight: FontWeight.w500,
          ),

          subtitle: TextLabel.small(
            verificacionOps.codigo,
            fontWeight: FontWeight.w400,
          ),
          trailing: Icon(
            FontAwesomeIcons.caretRight.data,
            color: S2BColors.primaryColor,
          ),
        ),
      ),
    );
  }
  /*
  Future<String> _findSubTipoIdFromCodigo(String codigo) async {
    try {
      final code = codigo.trim();
      if (code.isEmpty) return '0';
      final codeEsc = code.replaceAll("'", "''");

      final sql = '''
      SELECT ops_sub_tipo_id, nombre
      FROM ${LocalSqlite.TABLE_OPS_SUB_TIPO}
      WHERE
        INSTR(LOWER(TRIM(nombre)), LOWER('$codeEsc')) > 0
        OR INSTR(LOWER('$codeEsc'), LOWER(TRIM(nombre))) > 0
      ORDER BY
        (LOWER(TRIM(nombre)) = LOWER('$codeEsc')) DESC,
        ABS(LENGTH(TRIM(nombre)) - LENGTH('$codeEsc')) ASC
      LIMIT 1;
    ''';

      final rows = await LocalSqlite().readData(sql);
      if (rows.isNotEmpty) {
        final id  = (rows.first['ops_sub_tipo_id'] ?? '').toString().trim();
        final nom = (rows.first['nombre'] ?? '').toString().trim();
        debugPrint('[ItemOps] match subtipo → id=$id, nombre="$nom", codigo="$codigo"');
        if (id.isNotEmpty) return id;
        debugPrint('[ItemOps] advertencia: id vacío para nombre="$nom"');
      } else {
        debugPrint('[ItemOps] sin coincidencias (bidireccional) para codigo="$codigo"');
      }
    } catch (e) {
      debugPrint('[ItemOps] _findSubTipoIdFromCodigo error: $e');
    }
    return '0';
  }

   */



}
