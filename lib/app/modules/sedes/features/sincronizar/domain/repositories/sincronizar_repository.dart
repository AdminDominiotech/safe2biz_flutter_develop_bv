import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';

abstract class SincronizarApiRepository {
  Future<Either<Failure, List<Empleado>>> getEmpleadosFromApi(String userId);
  Future<Either<Failure, List<Desviacion>>> getDesviacionesFromApi();
  Future<Either<Failure, List<Gerencia>>> getGerenciasFromApi();
  Future<Either<Failure, List<Area>>> getAreasFromApi();
  Future<Either<Failure, List<TipoEvento>>> getTipoEventoFromApi();
  Future<Either<Failure, List<NivelRiesgo>>> getNivelRiesgoFromApi();
  Future<Either<Failure, List<EmpresaEsp>>> getEmpresasEspecializadasFromApi();
  Future<Either<Failure, List<TipoReporte>>> getTiposReportesFromApi();
  Future<Either<Failure, List<SubTipoReporte>>> getSubTiposReportesFromApi();
  Future<Either<Failure, List<DetallePerdida>>> getDetallesPerdidasFromApi();
  Future<Either<Failure, List<PotencialPerdida>>>
      getPotencialesPerdidasFromApi();
  Future<Either<Failure, List<PlanAccion>>> getSacFromApi(
      String companyId, String userId);

  Future<Either<Failure, List<VerificacionOps>>> getVerificacionesOpsFromApi(
    String userLogin,
  );
  Future<Either<Failure, List<CategoriaOps>>> getCategoriasOpsFromApi(
    String userLogin,
  );
  Future<Either<Failure, List<SeccionOps>>> getSeccionesOpsFromApi(
    String userLogin,
  );
  Future<Either<Failure, List<PreguntaOps>>> getPreguntasOpsFromApi(
    String userLogin,
  );
  Future<Either<Failure, List<Turno>>> getTurnoOpsFromApi();
  Future<Either<Failure, List<ResultadoOps>>> getResultadoOpsFromApi();
}
