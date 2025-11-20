import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/acto_condicion.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/data/datasource/lista_verificacion_datasource.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/planes_accion/data/datasource/planes_accion_datasource.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/entities.dart';

abstract class ListaVerificacionApiDatasource
    extends ListaVerificacionDatasource {
  Future<bool> saveListaVerificacionApi(
    RegistroGeneral registroGeneral,
    String userId,
  );
  Future<bool> saveRegistrosGeneralesApi(
    RegistroGeneral registroGeneral,
    String userId,
    String idSede,
  );
  Future<bool> saveRegistrosResultadoApi(
    RegistroResultado registroResultado,
    String userId,
    String idSede,
  );
}
