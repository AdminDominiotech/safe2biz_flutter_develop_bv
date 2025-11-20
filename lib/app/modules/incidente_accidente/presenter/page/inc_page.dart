import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/modules/incidente_accidente/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/incidente_accidente/presenter/bloc/inc_bloc.dart';
import 'package:safe2biz/app/modules/incidente_accidente/presenter/page/inc_body.dart';

class INCPage extends StatelessWidget {
  INCPage({Key? key}) : super(key: key);

  final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => INCBloc(
        getIncidentesAccidentesStorageUc:
            GetIt.I<GetIncidentesAccidentesStorageUcImpl>(),
        saveIncidenteAccidenteUc: GetIt.I<SaveIncidenteAccidenteUcImpl>(),
        editStatusIncidenteAccidenteStorageUc:


            GetIt.I<EditStatusIncidenteAccidenteStorageUcImpl>(),

        deleteIncidenteAccidenteStorageUc:
            GetIt.I<DeleteIncidenteAccidenteStorageUcImpl>(),
      )..add(
          InitEv(idSede: idSede),
        ),
      child: const INCBody(),
    );
  }
}
