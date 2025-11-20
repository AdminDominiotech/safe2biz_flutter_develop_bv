import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:safe2biz/app/modules/ops/presenter/bloc/ops_bloc.dart';
import 'package:safe2biz/app/modules/ops/presenter/page/ops_body.dart';
import 'package:safe2biz/app/modules/sedes/features/sincronizar/domain/usecases/usecases.dart';

class OpsPage extends StatefulWidget {

  final int? ops_tipo_checklist_id;

  const OpsPage({Key? key, this.ops_tipo_checklist_id}) : super(key: key);

  @override
  State<OpsPage> createState() => _OpsPageState();
}

class _OpsPageState extends State<OpsPage> {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OpsBloc(
          getVerificacionesLocalOpsUc:
              GetIt.I<GetVerificacionesOpsLocalUcImpl>())
        ..add(InitEv()),
      child: OpsBody(ops_tipo_checklist_id: widget.ops_tipo_checklist_id),
    );
  }
}


