import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class GetEmpleadosUc<Output, Input> {
  Future<Either<Failure, Output>> call(
    String userId,
  );
}

class GetEmpleadosUcImpl implements GetEmpleadosUc<List<Empleado>, dynamic> {
  GetEmpleadosUcImpl({required SincronizarApiRepository repository})
      : _repository = repository;

  final SincronizarApiRepository _repository;

  @override
  Future<Either<Failure, List<Empleado>>> call(
    String userId,
  ) async =>
      await _repository.getEmpleadosFromApi(userId);
}
