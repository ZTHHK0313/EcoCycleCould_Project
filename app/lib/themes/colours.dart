import 'package:flutter/material.dart'
    show MaterialColor, MaterialAccentColor, Color;

const int _ecoGreenPrimary = 0xff0bd677;

const MaterialColor ecoGreen = MaterialColor(_ecoGreenPrimary, <int, Color>{
  50: Color(0xffd8e5dd),
  100: Color(0xffb8e3c7),
  200: Color(0xff92e2b1),
  300: Color(0xff6bdf9a),
  400: Color(0xff45d987),
  500: Color(_ecoGreenPrimary),
  600: Color(0xff1ac36a),
  700: Color(0xff23ae5a),
  800: Color(0xff29964a),
  900: Color(0xff296e2d)
});

const int _ecoGreenAccentPrimary = 0xff00f990;

const MaterialAccentColor ecoGreenAccent =
    MaterialAccentColor(_ecoGreenAccentPrimary, <int, Color>{
  100: Color(0xff79f7aa),
  200: Color(0xff07fc8d),
  400: Color(_ecoGreenAccentPrimary),
  700: Color(0xff00e384)
});

abstract final class RecycleBinColor {
  static const Color plastic = Color(0xffe35c5c);
  static const Color metal = Color(0xfffffb00);
  static const Color paper = Color(0xff4ea1ff);

  const RecycleBinColor._();
}

abstract final class PointsRewardedColor {
  static const Color gain = Color(0xff00c05f);
  static const Color deduct = Color(0xffbe1d1d);

  const PointsRewardedColor._();
}
