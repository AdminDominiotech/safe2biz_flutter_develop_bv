import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/incidente_accidente/features/detail_incidente_accidente/presenter/bloc/detail_inc_bloc.dart';
import 'package:safe2biz/app/modules/incidente_accidente/features/detail_incidente_accidente/presenter/page/detail_inc_body.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

class DetailINCPage extends StatelessWidget {
  const DetailINCPage({
    Key? key,
    required this.incidenteAccidente,
  }) : super(key: key);

  final IncidenteAccidente incidenteAccidente;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailINCBloc(
        appController: GetIt.I<AppController>(),
        authController: GetIt.I<AuthController>(),
        saveIncidenteAccidenteUc: GetIt.I<SaveIncidenteAccidenteUcImpl>(),
        getTipoReportesLocalUc: GetIt.I<GetTipoReportesLocalUcImpl>(),
        getSubTipoReportesLocalUc: GetIt.I<GetSubTipoReportesLocalUcImpl>(),
        getDetallesPerdidasLocalUc: GetIt.I<GetDetallesPerdidasLocalUcImpl>(),
        getPotencialesPerdidasLocalUc:
            GetIt.I<GetPotencialesPerdidasLocalUcImpl>(),
        getAreasLocalUc: GetIt.I<GetAreasLocalUcImpl>(),
        getGerenciasLocalUc: GetIt.I<GetGerenciasLocalUcImpl>(),
        editIncidenteAccidenteStorageUc:
            GetIt.I<EditIncidenteAccidenteStorageUcImpl>(),
        deleteIncidenteAccidenteStorageUc:
            GetIt.I<DeleteIncidenteAccidenteStorageUcImpl>(),
        editStatusIncidenteAccidenteStorageUc:
            GetIt.I<EditStatusIncidenteAccidenteStorageUcImpl>(),
      )..add(
          InitEv(incidenteAccidente: incidenteAccidente),
        ),
      child: DetailINCBody(incidenteAccidente: incidenteAccidente),
    );
  }
}
