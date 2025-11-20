// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/modules/sedes/features/company/presenter/page/company_page.dart';
import 'package:safe2biz/app/modules/sedes/presenter/page/sede_page.dart';
import 'package:safe2biz/app/ui/module_ui.dart';

import '../../../../modules/InformacionSST/presenter/page/MiInformacion.dart';

class AppBarBack extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBack(
    this.title, {
    Key? key,
    this.btnBack,
    this.withTitle = true,
    this.titleListenable,
    this.showLogo = false,
    this.onPressed,
    this.actions,
    this.centerTitle,
  })  : preferredSize = const Size.fromHeight(55.0),
        super(key: key);

  final String title;
  final bool? btnBack;
  final bool withTitle;
  final bool showLogo;
  final ValueListenable<String>? titleListenable;
  final VoidCallback? onPressed;
  final List<Widget>? actions;
  final bool? centerTitle;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: S2BColors.primaryColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarDividerColor: Colors.orange,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      elevation: 0,
      automaticallyImplyLeading: true,
      centerTitle: centerTitle,
      title: Column(
        children: [
          if (showLogo)
            Image.asset(
              UiValues.safe2BizLogoPng,
              fit: BoxFit.cover,
              height: 20,
            ),
          if (withTitle) const SizedBox(height: 5),
          if (withTitle)
            titleListenable == null
                ? TextLabel.body(
                    title,
                    color: S2BColors.white,
                    fontWeight: FontWeight.w700,
                  )
                : ValueListenableBuilder<String>(
                    valueListenable: titleListenable!,
                    builder: (_, value, __) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                        ) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Text(
                          value,
                          key: Key(value),
                          style: const TextStyle(
                            color: S2BColors.black,
                            fontSize: 17,
                          ),
                        ),
                      );
                    },
                  ),
          const SizedBox(height: 5),
        ],
      ),
      actions: actions,
      leading: (btnBack ?? true)
          ? BackButton(
        color: Colors.white,
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          await Future<void>.delayed(const Duration(milliseconds: 40));
          final nav = Navigator.of(context);
          if (nav.canPop()) {
            nav.maybePop();
          } else {
            // Ruta raíz: vuelve a la pantalla segura
            nav.pushReplacement(
              MaterialPageRoute(builder: (_) => const CompanyPage()),
            );
          }
        },

      )
          : null,

    );
  }
}

Future<void> _closeIme() async {
  FocusManager.instance.primaryFocus?.unfocus();
  // fuerza cierre del IME
  await SystemChannels.textInput.invokeMethod('TextInput.hide');
  // da tiempo a terminar la animación del teclado (Android 13/14 es quisquilloso)
  await Future<void>.delayed(const Duration(milliseconds: 150));
}
