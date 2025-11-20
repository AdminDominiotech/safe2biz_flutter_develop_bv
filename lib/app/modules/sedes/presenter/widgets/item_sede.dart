import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/library/assets.dart';
import 'package:safe2biz/app/modules/sedes/domain/entities/entities.dart';
import 'package:safe2biz/app/modules/sedes/features/company/presenter/page/company_page.dart';
import 'package:safe2biz/app/global/controllers/controllers.dart';

class ItemSede extends StatelessWidget {
  const ItemSede({
    Key? key,
    required this.sede,
    this.onTap,
  }) : super(key: key);

  final Sede sede;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: InkWell(
        onTap: () async {
          LocalPreferences.prefs?.setString('current_sede', sede.name);
          LocalPreferences.prefs?.setString('current_sede_id', sede.id);

          final auth = GetIt.I<AuthController>();
          await auth.getModulosFromLocal(sede.id);

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CompanyPage()),
          );
        },
        child: PhysicalModel(
          borderRadius: BorderRadius.circular(S2BRadius.xs),
          color: S2BColors.white,
          elevation: 5,
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 40.0,
                  /*child: Icon(
                    FontAwesomeIcons.building,
                    color: S2BColors.orange,
                  ),*/
                  child: ImageIcon(
                    AssetImage(AppAssets.iconEdificio),
                    color: S2BColors.orange,
                    size: 24,
                  ),
                  height: 40.0,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextLabel.body(
                    sede.name,
                    fontWeight: FontWeight.w500,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
