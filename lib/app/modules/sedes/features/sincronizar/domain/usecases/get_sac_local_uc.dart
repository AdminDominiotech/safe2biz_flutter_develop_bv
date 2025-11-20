import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/planes_accion/domain/entities/plan_accion.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetSacLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetSacLocalUcImpl implements GetSacLocalUc<List<PlanAccion>, dynamic> {
  GetSacLocalUcImpl({required SincronizarLocalRepository repository})
      : _repository = repository;

  final SincronizarLocalRepository _repository;



  @override
  Future<Either<Failure, List<PlanAccion>>> call() async =>
      await _repository.getSacFromLocal();
}
