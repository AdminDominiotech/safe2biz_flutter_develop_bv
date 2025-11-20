// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/global/controllers/auth_controller.dart';
import 'package:safe2biz/app/global/core/routing/routing.dart';
import 'package:safe2biz/app/modules/auth/features/login/presenter/page/login_page.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/sedes/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/presenter/bloc/bloc.dart';
import 'package:safe2biz/app/modules/sedes/presenter/widgets/widgets.dart';

class SedeBody extends StatelessWidget {
  SedeBody({Key? key}) : super(key: key);

  List<Sede> _sedes = <Sede>[];

  @override
  Widget build(BuildContext context) {
    return BlocListener<SedeBloc, SedeState>(
      listener: (context, state) {
        if (state is FailureGetCompanies) {
          Toast.show(
            description: state.error,
            toastType: ToastType.error,
          );
        }
      },
      child: BlocBuilder<SedeBloc, SedeState>(
        builder: (context, state) {
          if (state is Loading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is Successful) {
            _sedes = state.sedes;
          }

          return Scaffold(
            appBar: AppBarBack(
              '  SEDES',
              showLogo: false,
              btnBack: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: S2BColors.white),
                  onPressed: () => _logout(context),
                )
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(S2BSpacing.sm),
              children: [
                ..._sedes.map(
                  (sede) {
                    return ItemSede(
                      sede: sede,
                    );
                  },
                ).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _logout(BuildContext context) {
    PopupMessage(
      context: context,
      title: 'Cerrar Sesión',
      bodyText: '¿Esta seguro que desea cerrar la sesión?',
      isDismissible: false,
      onSucess: () async {
        final auth = GetIt.I<AuthController>();

        final result = await auth.logout();
        if (result) {
          await Navigator.pushAndRemoveUntil(
            context,
            FadePageRoute(newPage: LoginPage()),
            (route) => false,
          );
        } else {
          Toast.show(
            description: 'Hubo un error',
            toastType: ToastType.error,
          );
        }
      },
    );
  }
}
