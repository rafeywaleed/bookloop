import 'package:flutter/material.dart';

TextTheme textTheme = TextTheme(
  displayLarge: TextStyle(
    fontSize: 32,
    color: Colors.black87,
    fontWeight: FontWeight.bold,
    fontFamily: 'Source Serif Pro', 
  ),
  displayMedium: TextStyle(
    fontSize: 20,
    color: Colors.black87,
    fontWeight: FontWeight.w800,
    fontFamily: 'Source Serif Pro', // Specify the font family if you have it in your assets
  ),
  displaySmall: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
    fontFamily: 'Source Serif Pro', // Specify the font family if you have it in your assets
  ),
  headlineMedium: TextStyle(
    fontSize: 16,
    color: Colors.black87,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins', // Specify the font family if you have it in your assets
  ),
  headlineSmall: TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins', // Specify the font family if you have it in your assets
  ),
);

class AppColors {
  static Color lightBlue = const Color(0xffCFEDEF);
  static Color black = Colors.black87;
}

List<Color> boxColors = const [
  Color(0xffCEEDEF),
  Color(0xffBFBFBF),
  Color(0xffEBECF1),
  Color(0xffFDF7DD),
  Color(0xffF9CFE3),
  Color(0xffFBEBC7),
  Color(0xffE9E8E6)
];