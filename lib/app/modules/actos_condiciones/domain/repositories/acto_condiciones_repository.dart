import 'package:dartz/dartz.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/entities/entities.dart';
import 'package:safe2biz/app/global/core/errors/errors.dart';

abstract class ActosCondicionesApiRepository {
  Future<Either<Failure, bool>> saveActosCondiciones(
    ActoCondicion actoCondicion,
  );
}
