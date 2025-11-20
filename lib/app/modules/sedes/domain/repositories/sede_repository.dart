import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';
import 'package:safe2biz/app/modules/sedes/domain/entities/entities.dart';

abstract class SedeApiRepository {
  Future<Either<Failure, List<Sede>>> getSedesFromApi(
    String userId,
  );
}
