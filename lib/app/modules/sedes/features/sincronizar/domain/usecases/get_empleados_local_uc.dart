import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';

abstract class GetEmpleadosLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call();
}

class GetEmpleadosLocalUcImpl
    implements GetEmpleadosLocalUc<List<Empleado>, dynamic> {
  GetEmpleadosLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, List<Empleado>>> call() async =>
      await _local.getEmpleadosFromLocal();
}
