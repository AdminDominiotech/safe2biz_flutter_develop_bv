import 'package:safe2biz/app/modules/planes_accion/domain/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/datasource/datasource.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/data/models/models.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';

abstract class SincronizarLocalDatasource extends SincronizarDatasource {
  Future<List<EmpleadoModel>> getEmpleadosFromLocal();
  Future<List<DesviacionModel>> getDesviacionesFromLocal();
  Future<List<GerenciaModel>> getGerenciasFromLocal();
  Future<List<AreaModel>> getAreasFromLocal();
  Future<List<PlanAccion>> getSacFromLocal();
  Future<List<TipoEventoModel>> getTiposEventosFromLocal();
  Future<List<NivelRiesgoModel>> getNivelesRiesgosFromLocal();
  Future<List<EmpresaEspModel>> getEmpresasEspecializadasFromLocal();
  Future<List<TipoReporte>> getTiposReportesFromLocal();
  Future<List<SubTipoReporte>> getSubTiposReportesFromLocal();
  Future<List<DetallePerdida>> getDetallesPerdidasFromLocal();
  Future<List<PotencialPerdida>> getPotencialesPerdidasFromLocal();
  Future<List<VerificacionOps>> getVerificacionesOpsFromLocal();
  Future<List<CategoriaOps>> getCategoriasOpsFromLocal();
  Future<List<SeccionOps>> getSeccionesOpsFromLocal();
  Future<List<PreguntaOps>> getPreguntasOpsFromLocal();
  Future<int> updatePreguntasByRegistroGeneralOpsFromLocal(
      String idGeneral, String idVerificacion);
  Future<List<Turno>> getTurnosOpsFromLocal();
  Future<List<ResultadoOps>> getResultadoOpsFromLocal();

  Future<bool> saveEmpleadosToLocal(List<Empleado> empleados);
  Future<bool> saveSacToLocal(List<PlanAccion> sac, String companyId);
  Future<bool> saveDesviacionesToLocal(List<Desviacion> desviaciones);
  Future<bool> saveGerenciasToLocal(List<Gerencia> gerencias);
  Future<bool> saveAreasToLocal(List<Area> areas);
  Future<bool> saveTipoEventoToLocal(List<TipoEvento> tipoEventos);
  Future<bool> saveNivelRiesgoToLocal(List<NivelRiesgo> nivelRiesgos);
  Future<bool> saveEmpresasEspecializadasToLocal(List<EmpresaEsp> empresaEsps);
  Future<bool> saveTiposReportesToLocal(List<TipoReporte> tipoReportes);
  Future<bool> saveSubTiposReportesToLocal(
    List<SubTipoReporte> subTipoReportes,
  );
  Future<bool> saveDetallesPerdidasToLocal(
    List<DetallePerdida> detallesPerdidas,
  );
  Future<bool> savePotencialesPerdidasToLocal(
    List<PotencialPerdida> potencialPerdida,
  );
  Future<bool> saveVerificacionesOpsToLocal(
      List<VerificacionOps> verificacionOps);
  Future<bool> saveCategoriasOpsToLocal(List<CategoriaOps> categoriaOps);
  Future<bool> saveSeccionesOpsToLocal(List<SeccionOps> seccionOps);
  Future<bool> savePreguntasOpsToLocal(List<PreguntaOps> preguntaOps);
  Future<bool> saveTurnoOpsToLocal(List<Turno> turnoOps);
  Future<bool> saveResultadoOpsToLocal(List<ResultadoOps> resultadoOps);
}
