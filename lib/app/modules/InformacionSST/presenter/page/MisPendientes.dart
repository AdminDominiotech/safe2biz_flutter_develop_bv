import 'package:flutter/material.dart';
import 'package:safe2biz/app/global/core/shared_widgets/layout/app_bar_back.dart';

class MisPendientes extends StatelessWidget {
  const MisPendientes({Key? key, this.sede, this.fb_empleado_id}) : super(key: key);
  final String? sede, fb_empleado_id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarBack('Mis Pendientes'),
        body: SingleChildScrollView(
          child: Column(
            children: [

              Text('Mis pendientes')

            ],
          ),
        )
    );
  }
}
