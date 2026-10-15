import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe2biz/app/global/core/core.dart';

// Los AppBar de la app usan fondos azul oscuro: título e iconos en blanco.
// (Antes esto venía de un parche local al SDK de Flutter.)
const AppBarTheme s2bAppBarTheme = AppBarTheme(foregroundColor: Colors.white);

// Texto e iconos blancos para los ElevatedButton que no definen su propio color.
ElevatedButtonThemeData get s2bElevatedButtonTheme => ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
    );

ThemeData get themeData => ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: S2BColors.primaryColor,
      //cursorColor: S2BColors.primaryColor,
      hintColor: S2BColors.black,

      //-----------------------
      iconTheme: const IconThemeData(color: S2BColors.primaryColor),
      fontFamily: S2BTypography.roboto,
      canvasColor: S2BColors.background, //backgroundColor BottomNavigationBar
      scaffoldBackgroundColor: S2BColors.background, //backgroundColor pages
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: S2BColors.primaryColor,
      ),
      appBarTheme: s2bAppBarTheme,
      elevatedButtonTheme: s2bElevatedButtonTheme
      // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      //   //==========PROPETIES==============
      //   showSelectedLabels: true,
      //   showUnselectedLabels: true,
      //   type: BottomNavigationBarType.shifting,
      //   elevation: 0,
      //   //==========NOT SELECT TAB==============
      //   unselectedItemColor: S2BColors.secundary,
      //   unselectedIconTheme: IconThemeData(color: S2BColors.secundary, size: 20),
      //   unselectedLabelStyle: TextStyles.txtDefaultOrange,
      //   //==========SELECT TAB==============
      //   // selectedItemColor: Colors.white,
      //   selectedItemColor: CColors.secundary,
      //   selectedIconTheme: IconThemeData(color: CColors.secundary, size: 30),
      //   // selectedLabelStyle: TextStyles.txtDefaultWhite,
      //   selectedLabelStyle: TextStyles.txtDefaultBlue,
      // ),
      ,
    );

SystemUiOverlayStyle get systemUILight => SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.light,
    );

SystemUiOverlayStyle get systemUIDark => SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: S2BColors.primaryColor,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: S2BColors.black,
      systemNavigationBarDividerColor: S2BColors.white,
      systemNavigationBarIconBrightness: Brightness.light,
    );
