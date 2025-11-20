// ignore_for_file: must_be_immutable

import 'package:safe2biz/app/library/assets.dart';
import 'package:safe2biz/app/modules/sedes/features/company/domain/entities/item_module.dart';

//==MODULOS

class ItemModuleModel extends ItemModule {
  ItemModuleModel({
    required String id,
    required String name,
    required Module prefix,
    required String icon,
  }) : super(
    id: id,
    prefix: prefix,
    name: name,
    icon: icon,
  );

  ItemModule copyWith({
    String? id,
    Module? prefix,
    String? name,
    String? icon,
  }) =>
      ItemModuleModel(
        id: id ?? this.id,
        prefix: prefix ?? this.prefix,
        name: name ?? this.name,
        icon: icon ?? this.icon,
      );
}

final resultModules = <ItemModule>[
  ItemModuleModel(
    id: '1',
    prefix: Module.INC,
    name: 'Incidentes / Accidentes',
    icon: AppAssets.iconAdvertencia,
  ),
  ItemModuleModel(
    id: '2',
    prefix: Module.AYC,
    name: 'Actos y Condiciones Inseguras',
    icon: AppAssets.iconActos,
  ),
  ItemModuleModel(
    id: '3',
    prefix: Module.PLAN_ACCION,
    name: 'Planes de Acción',
    icon: AppAssets.iconTablero,
  ),

  ItemModuleModel(
    id: '12',
    prefix: Module.LIST_VERIFI,
    name: 'Inspección',
    icon: AppAssets.iconTablero,
  ),

  //FIXME: ACTUALIZAR PLUGIN
  ItemModuleModel(
    id: '4',
    prefix: Module.GRAF_INC,
    name: 'Gráficos de Incidentes',
    icon: AppAssets.iconGrafico,
  ),
  ItemModuleModel(
    id: '5',
    prefix: Module.GRAF_RENDIMIENTO,
    name: 'Gráficos de rendimiento',
    icon: AppAssets.iconGrafico,
  ),
  ItemModuleModel(
    id: '6',
    prefix: Module.REPORT_INC,
    name: 'Reporte de incidentes',
    icon: AppAssets.iconDocumento,
  ),
  ItemModuleModel(
    id: '7',
    prefix: Module.REPORT_PLAN_ACCION,
    name: 'Reporte de Planes de Acción',
    icon: AppAssets.iconDocumento,
  ),
  ItemModuleModel(
    id: '8',
    prefix: Module.ENTREGA_EPP,
    name: 'Entrega EPP',
    icon: AppAssets.iconEpp,
  ),
  ItemModuleModel(
    id: '11',
    prefix: Module.AYC_BOT,
    name: 'Actos y Condiciones - BOT',
    icon: AppAssets.iconActos,
  ),
  ItemModuleModel(
    id: '13',
    prefix: Module.ESTAD_SEG,
    name: 'Estadisticas de Seguridad',
    icon: AppAssets.iconGrafico,
  ),
  ItemModuleModel(
    id: '14',
    prefix: Module.INDIC_SEG,
    name: 'Indicadores de Seguridad',
    icon: AppAssets.iconGrafico,
  ),
  ItemModuleModel(
    id: '15',
    prefix: Module.CAP,
    name: 'Capacitación',
    icon: AppAssets.iconActos,
  ),

  ItemModuleModel(
    id: '17',
    prefix: Module.SST,
    name: 'Acreditación del Trabajador',
    icon: AppAssets.iconActos,
  ),

  ItemModuleModel(
    id: '18',
    prefix: Module.DAT,
    name: 'Datos del Trabajador',
    icon: AppAssets.iconActos,
  ),

  ItemModuleModel(
    id: '19',
    prefix: Module.AUD,
    name: 'Auditoria',
    icon: AppAssets.iconTablero,
  )



];

