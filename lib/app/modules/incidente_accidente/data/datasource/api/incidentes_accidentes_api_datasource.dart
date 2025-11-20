import 'package:safe2biz/app/modules/actos_condiciones/data/datasource/actos_condiciones_datasource.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';

abstract class IncidentesAccidentesApiDatasource {
  Future<bool> saveIncidenteAccidenteApi(IncidenteAccidente incidenteAccidente);
}
