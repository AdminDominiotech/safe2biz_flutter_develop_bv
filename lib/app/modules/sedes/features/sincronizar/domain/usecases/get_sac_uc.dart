import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class GetSacUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    String companyId,
    String userId,
  );
}

class GetSacUcImpl implements GetSacUc<List<PlanAccion>, dynamic> {
  GetSacUcImpl({required SincronizarApiRepository repository})
      : _repository = repository;

  final SincronizarApiRepository _repository;

  @override
  Future<Either<Failure, List<PlanAccion>>> call(
    String companyId,
    String userId,
  ) async =>
      await _repository.getSacFromApi(companyId, userId);
}
