import 'dart:ui';

abstract class AppColors {
  static const Color blueR2 = Color(0xFF013386);

  static const Color blueR1 = Color(0xFF0249C1);

  static const Color blue = Color(0xFF025FFB);

  static const Color blue1 = Color(0xFF3A83FD);

  static const Color blue2 = Color(0xFF75A8FE);

  static const Color pinkR2 = Color(0xFFFC1CB6);

  static const Color pinkR1 = Color(0xFFFC42C3);

  static const Color pink = Color(0xFFFD69CF);

  static const Color pink1 = Color(0xFFFE90DB);

  static const Color pink2 = Color(0xFFFEB6E8);

  static const Color lightBlueR3 = Color(0xFF85B2FF);

  static const Color lightBlueR2 = Color(0xFF9EC2FF);

  static const Color lightBlueR1 = Color(0xFFB8D2FF);

  static const Color lightBlue = Color(0xFFD1E2FF);

  static const Color lightBlue1 = Color(0xFFEBF2FF);

  static const Color whiteR4 = Color(0xFF969696);

  static const Color whiteR3 = Color(0xFFB6B6B6);

  static const Color whiteR2 = Color(0xFFD6D6D6);

  static const Color whiteR1 = Color(0xFFEBEBEB);

  static const Color white = Color(0xFFFFFFFF);

  static const Color lagoonBlack = Color(0xFF081B3A);

  static const Color lagoonBlack1 = Color(0xFF0D2B5C);

  static const Color lagoonBlack2 = Color(0xFF123B7F);

  static const Color lagoonBlack3 = Color(0xFF164BA1);

  static const Color lagoonBlack4 = Color(0xFF1B5BC4);

  static const Color redR2 = Color(0xFFD40250);

  static const Color redR1 = Color(0xFFE80258);

  static const Color red = Color(0xFFFB025F);

  static const Color red1 = Color(0xFFFD2777);

  static const Color red2 = Color(0xFFFE4E90);

  static const Color orangeR2 = Color(0xFFD48602);

  static const Color orangeR1 = Color(0xFFE89202);

  static const Color orange = Color(0xFFFB9E02);

  static const Color orange1 = Color(0xFFFDAD27);

  static const Color orange2 = Color(0xFFFEBC4E);

  static const Color limeR2 = Color(0xFF469715);

  static const Color limeR1 = Color(0xFF51AE18);

  static const Color lime = Color(0xFF5BC41B);

  static const Color lime1 = Color(0xFF65DA1E);

  static const Color lime2 = Color(0xFF73E230);

  static const List<Color> _accentColors = [
    pink,
    red,
    orange,
    lime,
    pink1,
    red1,
    orange1,
    lime1,
    pink2,
    red2,
    orange2,
    lime2,
    pinkR2,
    redR2,
    orangeR2,
    limeR2,
    pinkR1,
    redR1,
    orangeR1,
    limeR1,
  ];

  static Color accentColorFromIndex(int index) {
    return _accentColors[index % _accentColors.length];
  }
}
