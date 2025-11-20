import 'package:flutter/material.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/models/models.dart';
import 'package:safe2biz/app/modules/ops/features/ops_principal/features/register_ops/presenter/page/tabs/generales/widgets/widgets.dart';

class TabGenerales extends StatefulWidget {
  const TabGenerales({Key? key, required this.pageArgs, this.ops_tipo_checklist_id, this.ops_sub_tipo_id
  }) : super(key: key);
  final int? ops_tipo_checklist_id;
  final int? ops_sub_tipo_id;
  final RegisterOpsPrincipalPageArgs pageArgs;


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
              pageArgs: widget.pageArgs,
                ops_tipo_checklist_id : widget.ops_tipo_checklist_id,
                ops_sub_tipo_id: widget.ops_sub_tipo_id
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
