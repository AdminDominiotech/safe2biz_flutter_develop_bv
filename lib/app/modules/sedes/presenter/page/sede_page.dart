import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';
import 'package:safe2biz/app/modules/auth/features/login/domain/usecases/usecases.dart';
import 'package:safe2biz/app/modules/sedes/presenter/bloc/bloc.dart';
import 'package:safe2biz/app/modules/sedes/presenter/page/sede_body.dart';
import 'package:safe2biz/app/modules/sedes/domain/usecases/usecases.dart';

class SedePage extends StatelessWidget {
  const SedePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SedeBloc(
        getSedesUc: GetIt.I<GetSedesUcImpl>(),
        getSedesStorageUc: GetIt.I<GetSedesLocalUcImpl>(),
        saveSedesStorageUc: GetIt.I<SaveSedesLocalUcImpl>(),
        loginCheckUc: GetIt.I<LoginCheckUcImpl>(),
        authController: GetIt.I<AuthController>(),
      )..add(InitEv()),
      child: SedeBody(),
    );
  }
}
