import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kCardColor = Colors.white;
bool obscureText = true;

const kLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Color.fromARGB(255, 83, 76, 76),
);

// ignore: non_constant_identifier_names
ThemeData KTextTheme = ThemeData(
  textTheme: GoogleFonts.robotoTextTheme(),
  fontFamily: 'Roboto',
  useMaterial3: true,
);

InputDecoration inputDec(IconData? icon, String text, [String? labelText]) {
  return InputDecoration(
      border: const UnderlineInputBorder(
        borderSide: BorderSide(),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 175, 173, 173),
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      hintText: text,
      prefixIcon: icon != null ? Icon(icon) : null,
      labelText: labelText);
}

class LightColors {
  static const Color kLuedkeBrown = Color.fromARGB(255, 175, 164, 160);

  static const Color kLightYellow = Color(0xFFFFF9EC);
  static const Color kLightYellow2 = Color(0xFFFFE4C7);
  static const Color kDarkYellow = Color(0xFFF9BE7C);
  static const Color kPalePink = Color(0xFFFED4D6);

  static const Color kRed = Color(0xFFE46472);
  static const Color kLavender = Color(0xFFD5E4FE);
  static const Color kBlue = Color(0xFF6488E4);
  static const Color kLightGreen = Color(0xFFD9E6DC);
  static const Color kGreen = Color(0xFF309397);

  static const Color kDarkBlue = Color(0xFF0D253F);
}

ThemeData KDateTimePickerTheme = ThemeData.light().copyWith(
  colorScheme: const ColorScheme.light(
    primary:
        Color.fromARGB(255, 175, 164, 160), // Cor do cabeçalho do TimePicker
    onPrimary: Color.fromARGB(
        255, 255, 255, 255), // Cor do texto do cabeçalho do TimePicker
    onSurface:
        Color.fromARGB(255, 99, 99, 99), // Cor do texto do horário selecionado
  ),
  dialogBackgroundColor: Colors.white, // Cor de fundo do TimePicker
);
