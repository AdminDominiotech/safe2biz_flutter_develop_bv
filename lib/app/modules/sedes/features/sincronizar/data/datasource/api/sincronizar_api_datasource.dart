import 'package:safe2biz/app/modules/planes_accion/data/models/plan_accion_model.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/models.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/sac_model.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/turno_model.dart';

abstract class SincronizarApiDatasource extends SincronizarDatasource {
  Future<List<EmpleadoModel>> getEmpleadosFromApi(String userId);
  Future<List<DesviacionModel>> getDesviacionesFromApi();
  Future<List<GerenciaModel>> getGerenciasFromApi();
  Future<List<AreaModel>> getAreasFromApi();
  Future<List<TipoEventoModel>> getTipoEventoFromApi();
  Future<List<NivelRiesgoModel>> getNivelRiesgoFromApi();
  Future<List<EmpresaEspModel>> getEmpresasEspecializadasFromApi();
  Future<List<TipoReporteModel>> getTiposReportesFromApi();
  Future<List<SubTipoReporteModel>> getSubTiposReportesFromApi();
  Future<List<DetallePerdidaModel>> getDetallesPerdidasFromApi();
  Future<List<PotencialPerdidaModel>> getPotencialesPerdidasFromApi();
  Future<List<PlanesAccionModel>> getSacFromApi(String companyId, String userId);
  Future<List<VerificacionOpsModel>> getVerificacionesOpsFromApi(
    String userLogin,
  );
  Future<List<CategoriaOpsModel>> getCategoriasOpsFromApi(String userLogin);
  Future<List<SeccionOpsModel>> getSeccionesOpsFromApi(String userLogin);
  Future<List<PreguntaOpsModel>> getPreguntasOpsFromApi(String userLogin);
  Future<List<TurnoModel>> getTurnoOpsFromApi();
  Future<List<ResultadoOpsModel>> getResultadoOpsFromApi();
}
