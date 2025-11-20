import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/ops/presenter/widgets/widgets.dart';
import 'package:safe2biz/app/modules/ops/presenter/bloc/ops_bloc.dart';

class OpsBody extends StatelessWidget {
  final int? ops_tipo_checklist_id;
  const OpsBody({Key? key, this.ops_tipo_checklist_id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        LocalPreferences.prefs?.getString('current_sede') ?? '',
        showLogo: false,
      ),
      body: BlocBuilder<OpsBloc, OpsState>(
        builder: (context, state) {
          if (state is Loading) {
            return const Center(child: LoadingContainer());
          }
          if (state is Loaded) {
            // 1) Debug: longitud original y parámetro
            print('🔎 Total verificaciones = ${state.verifications.length}');
            print('🔎 Filtrar por ops_tipo_checklist_id = $ops_tipo_checklist_id');

            // 2) Debug: imprime cada uno
            for (var v in state.verifications) {
              print('   • id=${v.id}, tipoChecklist=${v.opsTipoChecklistId}');
            }

            final listaFiltrada = state.verifications.where((v) {
              // 1) Asegurar que v.opsTipoChecklistId sea int
              final tipo = v.opsTipoChecklistId is String
                  ? int.tryParse(v.opsTipoChecklistId) ?? 0
                  : v.opsTipoChecklistId as int;

              // 2) Comparar con el parámetro (que ya es int)
              return tipo == ops_tipo_checklist_id;
            }).toList();

            // 4) Debug: resultado del filter
            print('✅ Después de filtrar = ${listaFiltrada.length} items');

            return listaFiltrada.isEmpty
                ? Center(child: Text('No hay items para el tipo $ops_tipo_checklist_id'))
                : ListView.builder(
              itemCount: listaFiltrada.length,
              padding: EdgeInsets.zero,
              itemBuilder: (ctx, i) => ItemOps(
                verificacionOps: listaFiltrada[i],
                ops_tipo_checklist_id: ops_tipo_checklist_id,

              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
