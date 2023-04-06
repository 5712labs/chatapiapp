import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color darkGrey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  // static const String fontName = 'WorkSans';
  // static const String fontName = 'ibmPlexSansKr';
  static const String fontName = '';

  static const Color kDarkGreenColor = Color(0xFF184A2C);
  static const Color kGinColor = Color(0xFFE5F0EA);
  static const Color kSpiritedGreen = Color(0xFFC1DFCB);
  static const Color kFoamColor = Color(0xFFEBFDF2);
  static Color kGreyColor = Colors.grey.shade600;
  static Color knearlyGrey = Colors.grey.shade400;

  // static const TextStyle signForm = TextStyle(
  //   color: kDarkGreenColor,
  //   fontWeight: FontWeight.w600,
  //   fontSize: 15.0,
  // );

  static final TextStyle inButton = GoogleFonts.ibmPlexSansKr(
    color: white,
    fontSize: 16.0,
  );

  static final TextStyle signForm = GoogleFonts.ibmPlexSansKr(
    color: kDarkGreenColor,
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
  );

  static final TextStyle signError = GoogleFonts.ibmPlexSansKr(
    color: Colors.red,
    // fontSize: 15.0,
    fontSize: 16.0,
  );

  static final TextStyle menu = GoogleFonts.ibmPlexSansKr(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
    // letterSpacing: 0.4,
    // height: 0.9,
  );

  static final TextStyle appbarHead = GoogleFonts.ibmPlexSansKr(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static final TextStyle appbarAction = GoogleFonts.ibmPlexSansKr(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: kDarkGreenColor,
  );

  static final TextStyle headline = GoogleFonts.ibmPlexSansKr(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: kDarkGreenColor,
  );

  static final TextStyle caption = GoogleFonts.ibmPlexSansKr(
    color: kGreyColor,
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
  );

  static final TextStyle marker = GoogleFonts.ibmPlexSansKr(
    color: white,
    fontSize: 32.0,
    // fontWeight: FontWeight.normal,
  );

  static final TextStyle addForm = GoogleFonts.ibmPlexSansKr(
    color: knearlyGrey,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle viewHead = GoogleFonts.notoSansNKo(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: kDarkGreenColor,
  );

  static final TextStyle viewCaption = GoogleFonts.notoSansNKo(
    color: nearlyBlack, //kGreyColor,
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
  );

  static final TextStyle viewPrice = GoogleFonts.notoSansNKo(
    color: Colors.green.shade600,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle mapControlRefresh = GoogleFonts.openSans(
    color: nearlyBlack,
    fontWeight: FontWeight.normal,
    fontSize: 13.0,
  );

  static final TextStyle mapControlList = GoogleFonts.openSans(
    color: nearlyBlack, //kGreyColor,
    fontWeight: FontWeight.w600,
    fontSize: 15.0,
  );

  static final TextStyle mapFilterList = GoogleFonts.openSans(
    color: nearlyBlack, //kGreyColor,
    fontWeight: FontWeight.normal,
    fontSize: 15.0,
  );

  static final TextStyle listTitle = GoogleFonts.openSans(
    color: Colors.black,
    // fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );
  static final TextStyle listSubtitle = GoogleFonts.notoSansNKo(
    color: grey,
    // fontWeight: FontWeight.normal,
    fontSize: 14.0,
  );
  static final TextStyle listPrice = GoogleFonts.notoSansNKo(
    color: Colors.green.shade600,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle gptUserTableBody = GoogleFonts.notoSansNKo(
    color: nearlyBlack,
    fontWeight: FontWeight.normal,
    fontSize: 14.0,
  );

  static final TextStyle gptAITableBody = GoogleFonts.notoSansNKo(
    color: nearlyWhite,
    fontWeight: FontWeight.normal,
    fontSize: 14.0,
  );

  static final TextStyle gptAIP = GoogleFonts.ibmPlexSansKr(
    color: nearlyWhite,
    fontSize: 16.0,
  );

  static final TextStyle gptUserP = GoogleFonts.ibmPlexSansKr(
    color: nearlyBlack,
    fontSize: 16.0,
  );

  /*
  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );
  */
}
