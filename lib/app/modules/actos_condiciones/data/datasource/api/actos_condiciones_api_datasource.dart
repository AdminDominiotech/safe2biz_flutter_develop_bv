import 'package:safe2biz/app/modules/actos_condiciones/data/datasource/actos_condiciones_datasource.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/acto_condicion.dart';

abstract class ActosCondicionesApiDatasource
    extends ActosCondicionesDatasource {
  Future<bool> saveActoCondicionApi(ActoCondicion actoCondicion);
}
