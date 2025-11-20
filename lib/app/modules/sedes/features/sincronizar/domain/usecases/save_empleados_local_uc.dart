import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/repositories/repositories.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class SaveEmpleadosLocalUc<Output, Input> {
  Future<Either<Failure, Output>> call(List<Empleado> empleados);
}

class SaveEmpleadosLocalUcImpl implements SaveEmpleadosLocalUc<bool, dynamic> {
  SaveEmpleadosLocalUcImpl({required SincronizarLocalRepository local})
      : _local = local;

  final SincronizarLocalRepository _local;

  @override
  Future<Either<Failure, bool>> call(List<Empleado> empleados) async =>
      await _local.saveEmpleadosToLocal(empleados);
}
