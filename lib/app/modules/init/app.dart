import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_safe2bizapp_core/mobile_safe2bizapp_core.dart';
import 'package:safe2biz/app/global/controllers/settings_controller.dart';
import 'package:safe2biz/app/modules/splash/presenter/page/splash_page.dart';
import 'package:safe2biz/app/global/core/theme/theme.dart';
import 'package:safe2biz/app/ui/module_ui.dart';

class Safe2BizApp extends StatelessWidget {
  const Safe2BizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(systemUILight);
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('es', 'ES'),
      ],
      debugShowCheckedModeBanner: false,
      darkTheme: themeData,
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
      builder: BotToastInit(),
      title: UiValues.safe2BizName,
      home: const SplashPage(),
    );
  }
}
