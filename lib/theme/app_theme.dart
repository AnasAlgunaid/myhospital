import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define the primary and secondary colors
  static const Color primaryColor = Color(0xFF254EDB); // Teal color
  static const Color secondaryColor =
      Color(0xFFF1F1F1); // Light gray background
  static const Color accentColor = Color(0xFF38B6FF); // Light blue accent
  static const Color whiteColor = Colors.white; // Pure white
  static const Color blackColor = Color(0xFF1B1B1B); // Dark black/gray for text
  static const Color grayColor =
      Color(0xFFB0B0B0); // Medium gray for placeholder
  static const Color secondaryFontColor =
      Color(0xFF3F3F46); // New secondary font color
  static const Color errorColor = Color(0xFFF04438); // Red error color
  static const Color gray200 = Color(0xFFE5E7EB); // Gray 100

  // Define text styles with Poppins
  static TextStyle headline1 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: blackColor,
  );

  static TextStyle headline2 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: blackColor,
  );
  static TextStyle headline3 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: blackColor,
  );
  static TextStyle headline4 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: blackColor,
  );

  static TextStyle bodyText1 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: blackColor,
  );

  static TextStyle bodyText2 = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: secondaryFontColor,
  );
  static TextStyle bodyText3 = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: grayColor,
  );

  static TextStyle buttonTextStyle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: whiteColor,
  );

  static TextStyle captionTextStyle = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: grayColor,
  );

  // Define input decoration theme
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: false, // Disable the filled background
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFFD2D6DB), // Add the border color
        width: 1, // Adjust border width as needed
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFFD2D6DB), // Add the border color for enabled state
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppTheme.primaryColor, // Use primary color when focused
        width: 1,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: errorColor, // Red color for error state
        width: 1,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: errorColor, // Red color for focused error state
        width: 1,
      ),
    ),
    errorStyle: bodyText3.copyWith(color: errorColor), // Style for error text
    hintStyle: bodyText3, // Use bodyText3 for placeholder text
    prefixStyle: bodyText2, // Use bodyText2 for prefix text
  );

  // Define elevated button theme
  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      foregroundColor: whiteColor,
      elevation: 0,
      splashFactory: NoSplash.splashFactory,
      textStyle: buttonTextStyle,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static TextButtonThemeData textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor,
      textStyle: buttonTextStyle,
      splashFactory: NoSplash.splashFactory,
      shadowColor: Colors.transparent,
    ),
  );

  static BottomNavigationBarThemeData bottomNavigationBarTheme =
      const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: whiteColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: secondaryFontColor,
    showUnselectedLabels: true,
  );
  static TabBarTheme tabBarTheme = TabBarTheme(
    indicatorColor: primaryColor,
    labelColor: primaryColor,
    unselectedLabelColor: Colors.grey,
    splashFactory: NoSplash.splashFactory,
    unselectedLabelStyle: headline3,
    labelStyle: headline3,
    overlayColor:
        WidgetStatePropertyAll(AppTheme.primaryColor.withOpacity(0.05)),
  );

  static CardTheme cardTheme = CardTheme(
    color: AppTheme.whiteColor,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(
        color: AppTheme.gray200,
        width: 1,
      ),
    ),
  );

  // Define app-wide theme
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: whiteColor,
    primaryColor: primaryColor,
    hintColor: accentColor,
    textTheme: TextTheme(
      displayLarge: headline1,
      displayMedium: headline2,
      bodyLarge: bodyText1,
      bodyMedium: bodyText2,
      labelLarge: buttonTextStyle,
      bodySmall: captionTextStyle,
    ),
    elevatedButtonTheme: elevatedButtonTheme,
    textButtonTheme: textButtonTheme,
    inputDecorationTheme: inputDecorationTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      shape: Border(
        bottom: BorderSide(color: secondaryColor),
      ),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: blackColor,
      ),
      iconTheme: IconThemeData(color: blackColor),
    ),
    bottomNavigationBarTheme: bottomNavigationBarTheme,
    tabBarTheme: tabBarTheme,
    cardTheme: cardTheme,
  );
}
