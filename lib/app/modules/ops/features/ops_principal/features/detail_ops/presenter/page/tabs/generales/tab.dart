import 'package:flutter/material.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/detail_ops/presenter/page/tabs/generales/widgets/form_ops.dart';

class TabGenerales extends StatefulWidget {
  final int? ops_tipo_checklist_id;
  const TabGenerales({
    Key? key,
    required this.registroGeneral,
    this.ops_tipo_checklist_id
  }) : super(key: key);

  final RegistroGeneral registroGeneral;

  @override
  State<TabGenerales> createState() => _TabGeneralesState();
}

class _TabGeneralesState extends State<TabGenerales>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(
              top: S2BSpacing.xs,
            ),
            decoration: const BoxDecoration(
              color: S2BColors.white,
            ),
            child: FormOPS(
              registroGeneral: widget.registroGeneral,
                ops_tipo_checklist_id : widget.ops_tipo_checklist_id
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
