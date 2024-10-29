import 'package:eco_cycle_cloud/pages/home.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'themes/colours.dart';
import 'themes/states.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const EcoCycleCloudApp());
}

final class EcoCycleCloudApp extends StatelessWidget {
  const EcoCycleCloudApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    final TextTheme currentTxtTheme = currentTheme.textTheme;

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
                backgroundColor: ecoGreen[300], foregroundColor: ecoGreen[800]),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: ecoGreen[200], foregroundColor: ecoGreen[800]),
            drawerTheme: DrawerThemeData(backgroundColor: ecoGreen[200]),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    backgroundColor: ConstantWidgetStateProperties<Color>(
                        ecoGreen[200],
                        selecting: ecoGreen[500]!.withAlpha(0x7F)),
                        foregroundColor: ConstantWidgetStateProperties(ecoGreen[800], selecting: ecoGreen[100]) 
            )),
            useMaterial3: true),
        home: const HomePage());
  }
}
