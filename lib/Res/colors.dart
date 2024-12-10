import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

// const primaryColor = Color(0xFF7093E5);
const primaryColor = Color(0xFF1872c5);
Color appPrimaryColor = primaryColor;

// const appSecondaryColor = Color(0xFFF68685);
const appSecondaryColor = Color(0xFFFD5722);
const primaryDarkColor = Color(0xff0a0909);

const borderColor = Color(0xFFEBEBEB);
const cardColor = Color(0xFFFFFFFF);

const textPrimaryDarkColor = Color(0xFFFFFFFF);
const textSecondaryWhiteColor = Color(0xFFc7daeb);

const textPrimaryLightColor = Color(0xFF000000);
const textSecondaryLightColor = Color(0xFF575454);

const scaffoldColorLight = Color(0xFFEDF4FF);

const scaffoldColorDark = Color(0xFF0E1116);
const scaffoldSecondaryDark = Color(0xFF1C1F26);

const cardSelectedColor = Color(0xff3e3b3b);
const iconColor = Color(0xFF6E7990);

Color selectedColor = getColorFromHex('#e6ecfa');
const secondaryTxtColor = Color(0xFF6E7990);

//Error Color
const errorBackGroundColor = Color(0xFFFFCDD2);
const errorTextColor = Colors.red;

//Error Color
const successBackGroundColor = Color(0xFFDCEDC8);
const successTextColor = Colors.green;

// Dark Mode Colors

//Light Mode Colors

const Map<int, Color> color = {
  50: Color(0xFFFD5722),
  100: Color(0xFFFD5722),
  200: Color(0xFFFD5722),
  300: Color(0xFFFD5722),
  400: Color(0xFFFD5722),
  500: Color(0xFFFD5722),
  600: Color(0xFFFD5722),
  700: Color(0xFFFD5722),
  800: Color(0xFFFD5722),
  900: Color(0xFFFD5722),
};
const AppPrimaryColor = MaterialColor(0xFF1872c5, color);
const AppGradientColor = LinearGradient(colors: [
  AppPrimaryColor,
  AppPrimaryColor,
]);

final BackgroundColor = Colors.grey.shade200;
