import 'package:safe2biz/app/modules/actos_condiciones/data/datasource/actos_condiciones_datasource.dart';
import 'package:safe2biz/app/modules/actos_condiciones/data/models/acto_condicion_model.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/acto_condicion.dart';

abstract class ActosCondicionesLocalDatasource
    extends ActosCondicionesDatasource {
  Future<List<ActoCondicionModel>> getActosCondicionesFromStorage(String idSede);
  Future<ActoCondicionModel> getActoCondicionFromStorage(String id);
  Future<bool> editActoCondicionFromStorage(ActoCondicion actoCondicion);
  Future<bool> editStatusActoCondicionFromStorage(int id, String status);
  Future<bool> saveActoCondicionStorage(ActoCondicion actoCondicion);
  Future<bool> deleteAllActosCondicionesStorage();
  Future<bool> deleteActoCondicionStorage(int id);
}
