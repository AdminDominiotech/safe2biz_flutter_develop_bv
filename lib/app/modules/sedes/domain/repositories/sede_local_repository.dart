import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/domain/entities/entities.dart';

abstract class SedeLocalRepository {
  Future<Either<Failure, List<Sede>>> getSedesFromStorage();
  Future<Either<Failure, bool>> saveSedesStorage(
    List<Sede> sedes,
  );
}
