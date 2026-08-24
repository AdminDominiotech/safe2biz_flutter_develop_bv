import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safe2biz/app/global/core/core.dart';

class BtnSettings extends StatelessWidget {
  const BtnSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: S2BSpacing.md,
        top: S2BSpacing.xxl,
      ),
      child: Icon(
        FontAwesomeIcons.gear.data,
        color: S2BColors.silver.withOpacity(0.7),
      ),
    );
  }
}
