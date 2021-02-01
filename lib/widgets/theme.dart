import 'package:flutter/material.dart';

class ThemeStyle {
  static final lightTheme = ThemeData.light().copyWith(
    tabBarTheme: TabBarTheme(labelColor: const Color(0xFF000000)),
    backgroundColor: const Color(0xFFFFFFFF),
    cardColor: const Color(0xFFFFFFFF),
    bottomAppBarColor: const Color.fromRGBO(45, 45, 48, 1),
    primaryColorLight: const Color(0xFFF5F5F5),
    primaryColorDark: const Color(0xFFEEEEEE),
  );
  static final darkTheme = ThemeData.dark().copyWith(
      tabBarTheme: TabBarTheme(labelColor: const Color(0xFFFFFFFF)),
      backgroundColor: const Color(0xFF303030),
      bottomAppBarColor: const Color(0xFF191919),
      cardColor: const Color(0xFF333333),
      primaryColorLight: const Color(0xFF505050),
      primaryColorDark: const Color(0xFF404040));
  static MediaQueryData _mediaQuery;
  static ThemeData theme;
  static ThemeData getTheme(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    theme = _mediaQuery.platformBrightness == Brightness.light
        ? lightTheme
        : darkTheme;
    return theme;
  }
}

const COLOR_BLACK = Color.fromRGBO(48, 47, 48, 1.0);
const COLOR_GREY = Color.fromRGBO(141, 141, 141, 1.0);

const COLOR_WHITE = Colors.white;
const COLOR_DARK_BLUE = Color.fromRGBO(20, 25, 45, 1.0);

const TextTheme TEXT_THEME_DEFAULT = TextTheme(
    headline1: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 26),
    headline2: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 22),
    headline3: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 20),
    headline4: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 16),
    headline5: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 14),
    headline6: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 12),
    bodyText1: TextStyle(
        color: COLOR_BLACK,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5),
    bodyText2: TextStyle(
        color: COLOR_GREY,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5),
    subtitle1: TextStyle(
        color: COLOR_BLACK, fontSize: 12, fontWeight: FontWeight.w400),
    subtitle2: TextStyle(
        color: COLOR_GREY, fontSize: 12, fontWeight: FontWeight.w400));

const TextTheme TEXT_THEME_SMALL = TextTheme(
    headline1: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 22),
    headline2: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 20),
    headline3: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 18),
    headline4: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 14),
    headline5: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 12),
    headline6: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 10),
    bodyText1: TextStyle(
        color: COLOR_BLACK,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5),
    bodyText2: TextStyle(
        color: COLOR_GREY,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5),
    subtitle1: TextStyle(
        color: COLOR_BLACK, fontSize: 10, fontWeight: FontWeight.w400),
    subtitle2: TextStyle(
        color: COLOR_GREY, fontSize: 10, fontWeight: FontWeight.w400));

const buttonTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
);

const chartLabelsTextStyle = TextStyle(
  color: Colors.grey,
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
);

const tabTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
);

// Colors
const kTextColor = Color(0xFF0D1333);
const kBlueColor = Color(0xFF6E8AFA);
const kBestSellerColor = Color(0xFFFFD073);
const kGreenColor = Color(0xFF49CC96);

// My Text Styles
const kHeadingextStyle = TextStyle(
  fontSize: 28,
  color: kTextColor,
  fontWeight: FontWeight.bold,
);
const kSubheadingextStyle = TextStyle(
  fontSize: 24,
  color: Color(0xFF61688B),
  height: 2,
);

const kTitleTextStyle = TextStyle(
  fontSize: 20,
  color: kTextColor,
  fontWeight: FontWeight.bold,
);

const kSubtitleTextSyule = TextStyle(
  fontSize: 18,
  color: kTextColor,
  // fontWeight: FontWeight.bold,
);
