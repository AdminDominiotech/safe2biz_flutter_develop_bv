import 'package:safe2biz/app/modules/ops/features/ops_principal/data/datasource/lista_verificacion_datasource.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';

abstract class ListaVerificacionLocalDatasource
    extends ListaVerificacionDatasource {
  Future<List<RegistroGeneral>> getListaVerificacionFromStorage(
      String sedeId, String idListaVerificacion);
  Future<RegistroResultado> getRegistroResultadoFromStorage(
    String idGenerales,
    String idCategoria,
    String idSeccion,
    String idPregunta,
  );
  Future<List<RegistroResultado>> getRegistroResultadoByIdGeneralFromStorage(
    String idGenerales,
  );
  Future<bool> editRegistroResultadoFromStorage(
      RegistroResultado registroResultado);
  Future<bool> editListaVerificacionFromStorage(
    RegistroGeneral registroGeneral,
  );
  Future<bool> editStatusListaVerificacionFromStorage(String id, String status);
  Future<bool> deleteListaVerificacionStorage(String id);
  Future<bool> deleteAllListaVerificacionStorage();
  Future<int> saveListaVerificacionStorage(RegistroGeneral registroGeneral);
  Future<bool> saveRegistroResultadoStorage(
    RegistroResultado registroResultado,
  );
  Future<bool> editStatusRegistroGeneralesFromStorage(
    int id,
    String status,
  );
  Future<bool> editStatusRegistroResultadoFromStorage(
    int id,
    String status,
  );
  Future<bool> deleteRegistroGeneralFromStorage(int id);
  Future<bool> deleteRegistroResultadoFromStorage(String id);
}
