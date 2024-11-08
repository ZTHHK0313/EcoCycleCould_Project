import 'package:eco_cycle_cloud/model/user_infos/user.dart';
import 'package:eco_cycle_cloud/pages/home.dart';
import 'package:eco_cycle_cloud/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'themes/colours.dart';
import 'themes/states.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const EcoCycleCloudApp()));
}

final class EcoCycleCloudApp extends StatelessWidget {
  const EcoCycleCloudApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    final TextTheme currentTxtTheme = currentTheme.textTheme;

    return ChangeNotifierProvider<CurrentUserManager>(
        create: (context) => CurrentUserManager(),
        builder: (context, _) {
          return MaterialApp(
              title: 'EcoCycleCloud',
              theme: ThemeData(
                  colorScheme: ColorScheme.light(
                      primary: ecoGreen[500]!,
                      primaryContainer: ecoGreen[50],
                      secondary: ecoGreen[200]!,
                      secondaryContainer: ecoGreen[100]),
                  textTheme: GoogleFonts.interTextTheme(currentTxtTheme).copyWith(
                      displayLarge: GoogleFonts.poppins(
                          textStyle: currentTxtTheme.displayLarge),
                      displayMedium: GoogleFonts.poppins(
                          textStyle: currentTxtTheme.displayMedium),
                      displaySmall: GoogleFonts.poppins(
                          textStyle: currentTxtTheme.displaySmall)),
                  appBarTheme: AppBarTheme(
                      backgroundColor: ecoGreen[300],
                      foregroundColor: ecoGreen[800]),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                      backgroundColor: ecoGreen[200],
                      foregroundColor: ecoGreen[800]),
                  drawerTheme: DrawerThemeData(backgroundColor: ecoGreen[200]),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ButtonStyle(
                          backgroundColor: ConstantWidgetStateProperties<Color>(
                              ecoGreen[200],
                              selecting: ecoGreen[500]!.withAlpha(0x7F)),
                          foregroundColor: ConstantWidgetStateProperties(
                              ecoGreen[800],
                              selecting: ecoGreen[100]))),
                  inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(borderSide: BorderSide(color: ecoGreen[900]!)),
                      errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent))),
                  useMaterial3: true),
              home: Consumer<CurrentUserManager>(builder: (context, usrMgr, _) {
                return usrMgr.hasCurrentUser ? HomePage() : const LoginPage();
              }));
        });
  }
}
