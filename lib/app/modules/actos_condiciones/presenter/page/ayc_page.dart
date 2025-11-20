import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/modules/actos_condiciones/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/actos_condiciones/presenter/bloc/ayc_bloc.dart';
import 'package:safe2biz/app/modules/actos_condiciones/presenter/page/ayc_body.dart';

class AyCPage extends StatelessWidget {
  AyCPage({Key? key}) : super(key: key);

  final idSede = LocalPreferences.prefs?.getString('current_sede_id') ?? '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AyCBloc(
        getActosCondicionesStorageUc:


            GetIt.I<GetActosCondicionesStorageUcImpl>(),
        saveActoCondicionUc: GetIt.I<SaveActoCondicionUcImpl>(),
        editStatusActoCondicionStorageUc:

            GetIt.I<EditStatusActoCondicionStorageUcImpl>(),
        deleteActoCondicionStorageUc:


            GetIt.I<DeleteActoCondicionStorageUcImpl>(),
      )..add(
          InitEv(idSede: idSede),
        ),
      child: const AyCBody(),
    );
  }
}
