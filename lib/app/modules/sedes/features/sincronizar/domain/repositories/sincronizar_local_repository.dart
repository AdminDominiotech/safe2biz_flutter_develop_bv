import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';

abstract class SincronizarLocalRepository {
  Future<Either<Failure, List<Empleado>>> getEmpleadosFromLocal();
  Future<Either<Failure, List<Desviacion>>> getDesviacionesFromLocal();
  Future<Either<Failure, List<Gerencia>>> getGerenciasFromLocal();
  Future<Either<Failure, List<PlanAccion>>> getSacFromLocal();
  Future<Either<Failure, List<Area>>> getAreasFromLocal();
  Future<Either<Failure, List<TipoEvento>>> getTiposEventosFromLocal();
  Future<Either<Failure, List<NivelRiesgo>>> getNivelesRiesgosFromLocal();
  Future<Either<Failure, List<EmpresaEsp>>>
      getEmpresasEspecializadasFromLocal();

  Future<Either<Failure, List<TipoReporte>>> getTiposReportesFromLocal();
  Future<Either<Failure, List<SubTipoReporte>>> getSubTiposReportesFromLocal();
  Future<Either<Failure, List<DetallePerdida>>> getDetallesPerdidasFromLocal();
  Future<Either<Failure, List<PotencialPerdida>>>
      getPotencialesPerdidasFromLocal();

  Future<Either<Failure, List<VerificacionOps>>>
      getVerificacionesOpsFromLocal();
  Future<Either<Failure, List<CategoriaOps>>> getCategoriasOpsFromLocal();
  Future<Either<Failure, List<SeccionOps>>> getSeccionesOpsFromLocal();
  Future<Either<Failure, List<PreguntaOps>>> getPreguntasOpsFromLocal();
  Future<Either<Failure, List<Turno>>> getTurnosOpsFromLocal();
  Future<Either<Failure, List<ResultadoOps>>> getResultadoOpsFromLocal();

  Future<Either<Failure, bool>> saveEmpleadosToLocal(List<Empleado> empleados);
  Future<Either<Failure, bool>> saveDesviacionesToLocal(
    List<Desviacion> desviaciones,
  );
  Future<Either<Failure, bool>> saveGerenciasToLocal(List<Gerencia> gerencias);
  Future<Either<Failure, bool>> saveAreasToLocal(List<Area> areas);
  Future<Either<Failure, bool>> saveSacToLocal(List<PlanAccion> sac, String companyId);
  Future<Either<Failure, bool>> saveTipoEventoToLocal(
    List<TipoEvento> tipoEventos,
  );
  Future<Either<Failure, bool>> saveNivelRiesgoToLocal(
    List<NivelRiesgo> nivelRiesgos,
  );
  Future<Either<Failure, bool>> saveEmpresasEspecializadasToLocal(
    List<EmpresaEsp> empresaEsps,
  );
  Future<Either<Failure, bool>> saveTiposReportesToLocal(
    List<TipoReporte> tipoReportes,
  );
  Future<Either<Failure, bool>> saveSubTiposReportesToLocal(
    List<SubTipoReporte> subTipoReportes,
  );
  Future<Either<Failure, bool>> saveDetallesPerdidasToLocal(
    List<DetallePerdida> detallesPerdidas,
  );
  Future<Either<Failure, bool>> savePotencialesPerdidasToLocal(
    List<PotencialPerdida> potencialPerdida,
  );

  Future<Either<Failure, bool>> saveVerificacionesOpsToLocal(
    List<VerificacionOps> verificacionOps,
  );
  Future<Either<Failure, bool>> saveCategoriasOpsToLocal(
    List<CategoriaOps> categoriaOps,
  );
  Future<Either<Failure, bool>> saveSeccionesOpsToLocal(
    List<SeccionOps> seccionOps,
  );
  Future<Either<Failure, bool>> savePreguntasOpsToLocal(
    List<PreguntaOps> preguntaOps,
  );
  Future<Either<Failure, bool>> saveTurnosOpsToLocal(
    List<Turno> turnos,
  );

  Future<Either<Failure, bool>> saveResultadoOpsToLocal(
    List<ResultadoOps> resultadoOps,
  );

  Future<Either<Failure, int>> updatePreguntasByRegistroGeneralOpsFromLocal(
    String idGeneral,
    String idVerificacion,
  );
}
