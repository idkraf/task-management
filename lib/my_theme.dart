import 'package:flutter/material.dart';

class MyTheme {

  static const Color bg = Color.fromRGBO(249, 250, 251, 1.0);
  static const Color text_color_1 = Color.fromRGBO(17, 24, 39, 1);
  static const Color text_color_2 = Color.fromRGBO(55, 65, 81, 1);
  static const Color text_color_3 = Color.fromRGBO(107, 114, 128, 1);
  static const Color text_color_4 = Color.fromRGBO(117, 142, 196, 1);
  static const Color text_color_5 = Color.fromRGBO(156, 163, 175, 1);

  static const Color text_color_6 = Color.fromRGBO(209, 213, 219, 1.0);

  static const Color polo_blue = Color.fromRGBO(241, 248, 249, 1);
  static const Color gigas = Color.fromRGBO(243, 241, 249, 1);
  static const Color cruise = Color.fromRGBO(241, 244, 249, 1);

  static const Color blue_chill = Color.fromRGBO(71, 148, 147, 1);
  static const Color brick_red = Color.fromRGBO(191, 25, 49, 1);
  static const Color brick_red_medium = Color.fromRGBO(204, 111, 125, 1.0);
  static const Color cinnabar = Color.fromRGBO(226, 88, 62, 1);


  static LinearGradient buildLinearGradient1() {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [MyTheme.gigas, MyTheme.gigas],
    );
  }

  static LinearGradient buildLinearGradient2() {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [MyTheme.polo_blue, MyTheme.polo_blue],
    );
  }

  static LinearGradient buildLinearGradient3() {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [MyTheme.cruise, MyTheme.cruise],
    );
  }
}