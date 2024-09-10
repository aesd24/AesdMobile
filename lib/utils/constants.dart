import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kPrimaryColor = Color(0xFF92c800);
const kYellowColor = Color(0xFFF56960);
const kWhiteColor = Color(0xFFF4F6F7);
const scaffold = Color(0xFFF0F2F5);
const kBlackBoldColor = Color(0xFF1E1E1D);
const inputColor = Color(0xFF4A5568);
const inputBgColor = Color(0xFFEdF2F7);
const kGreyColor = Color(0XFFA3A3A3);
const kPrimaryColor2 = Color(0xFF1C36D3);
const kGreenColor = Color(0xFF22AF46);
const kGreendackColor = Color(0xFF64B8A6);
const kOrangeColor = Color(0xFFFF4500);
const kSecondaryColor = Color(0xFFF56960);
const kDangerColor = Color(0xFFCD201F);
const kFacebookColor = Color(0xFF3B5999);
const kTwitterColor = Color(0xFF55aCEE);
const kYoutubeColor = Color(0xFFCD201F);
const kLinkedinInColor = Color(0xFF0077B5);
const kShadowColor = Color(0xFFDADFF0);
const kNoticeBadgeColor = Color(0xFFEE376E);
const kBgDarkColor = Color(0xFFEBEDFA);
const kGrayColor = Color(0xFF8793B2);
const kTitleTextColor = Color(0xFF30384D);
const kTextColor = Color(0xFF4D5875);
const kHeaderColor = Color(0xFF92c800);

/*
const kPrimaryColor = Color(0xFF366CF6);
const kSecondaryColor = Color(0xFFF5F6FC);
const kBgLightColor = Color(0xFFF2F4FC);
const kBgDarkColor = Color(0xFFEBEDFA);
const kGrayColor = Color(0xFF8793B2);
const kTitleTextColor = Color(0xFF30384D);
const kTextColor = Color(0xFF4D5875);
*/

const kDefaultNoticeCardPadding = 18.0;

class Styles {
  static const buttonTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );

  static const chartLabelsTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  static const tabTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );
}

var sAppBarText = GoogleFonts.inter(
    textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w500));

var sTitleStyle = GoogleFonts.inter(
    textStyle: const TextStyle(fontSize: 18.0, color: kSecondaryColor));

var sMallStyle = const TextStyle(
    fontSize: 12.0, fontWeight: FontWeight.w500, color: kSecondaryColor);

var sDateStyle = GoogleFonts.inter(
    textStyle: const TextStyle(
        fontSize: 11.0, fontWeight: FontWeight.w500, color: kFacebookColor));

var sSubStyle = GoogleFonts.inter(
    textStyle: const TextStyle(
        fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.black));

var sTitleLightStyle = GoogleFonts.inter(
    textStyle: const TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: kSecondaryColor));

var sTitleResetStyle = GoogleFonts.inter(
    textStyle: const TextStyle(
        fontSize: 13.0, fontWeight: FontWeight.bold, color: kSecondaryColor));

var sAuthStyle = const TextStyle(
    fontSize: 16.0, fontWeight: FontWeight.bold, color: kBlackBoldColor);

var sDetailsTitleStyle = const TextStyle(
    fontSize: 17.0, fontWeight: FontWeight.w600, color: kBlackBoldColor);

var ssAppTitleStyle = GoogleFonts.inter(
    textStyle: const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w900, color: kBlackBoldColor));

var sTextMenuStyle = GoogleFonts.inter(
    textStyle: const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w700, color: kBlackBoldColor));

var sHourStyle = GoogleFonts.inter(
    textStyle: const TextStyle(
        fontSize: 13.0, fontWeight: FontWeight.w600, color: kYellowColor));

var sNameStyle = GoogleFonts.inter(
    textStyle: const TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.w500, color: kBlackBoldColor));

var sLogoHead_1 = GoogleFonts.inter(
    textStyle: const TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.0,
        color: kPrimaryColor));

var sLogoHead_2 = GoogleFonts.inter(
    textStyle: const TextStyle(
        fontSize: 30.0, fontWeight: FontWeight.w900, color: kYellowColor));

var sTitleBoldStyle = GoogleFonts.inter(
    textStyle: const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: kSecondaryColor));

var sGrandTitleStyle = GoogleFonts.quicksand(
  textStyle: const TextStyle(
      fontSize: 34.0, fontWeight: FontWeight.bold, color: kBlackBoldColor),
);

var sGrandTitleYellowStyle = GoogleFonts.quicksand(
    textStyle: const TextStyle(
        fontSize: 34.0, fontWeight: FontWeight.bold, color: kYellowColor));

var sNoItemStyle = GoogleFonts.inter(
    textStyle: const TextStyle(fontSize: 13.0, color: Colors.black45));

var sErrorHeaderStyle = GoogleFonts.inter(
    textStyle: TextStyle(fontSize: 30.0, color: scaffold.withOpacity(0.8)));

var sErrorTextStyle = GoogleFonts.inter(
    textStyle: TextStyle(fontSize: 11.0, color: scaffold.withOpacity(0.8)));

const kGrey1 = Color(0xFF9F9F9F);
const kGrey2 = Color(0xFF6D6D6D);
const kGrey3 = Color(0xFFEAEAEA);
const kBlack = Color(0xFF1C1C1C);

var kNonActiveTabStyle = GoogleFonts.roboto(
  textStyle: const TextStyle(fontSize: 14.0, color: kGrey1),
);

var kActiveTabStyle = GoogleFonts.roboto(
  textStyle: const TextStyle(
    fontSize: 16.0,
    color: kBlack,
    fontWeight: FontWeight.bold,
  ),
);

var kCategoryTitle = GoogleFonts.roboto(
  textStyle: const TextStyle(
    fontSize: 14.0,
    color: kGrey2,
    fontWeight: FontWeight.bold,
  ),
);

var kDetailContent = GoogleFonts.roboto(
  textStyle: const TextStyle(
    fontSize: 14.0,
    color: kGrey2,
  ),
);

var kTitleCard = GoogleFonts.roboto(
  textStyle: const TextStyle(
    fontSize: 18.0,
    color: kBlack,
    fontWeight: FontWeight.bold,
  ),
);

var descriptionStyle = GoogleFonts.roboto(
    textStyle: const TextStyle(
  fontSize: 15.0,
  height: 2.0,
));

const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;
