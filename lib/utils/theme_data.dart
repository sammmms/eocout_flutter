import 'package:flutter/material.dart';

ColorScheme colorScheme = const ColorScheme(
  // Primary Color
  primary: Color(0xFF41b06e),
  onPrimary: Colors.white,

  // Primary Variant
  primaryContainer: Color(0xCC41b06e),
  onPrimaryContainer: Colors.white,

  // Secondary Color
  secondary: Color.fromRGBO(232, 232, 232, 0.2),
  onSecondary: Colors.black,

  // Secondary Variant
  secondaryContainer: Color(0xFF9F9F9F),
  onSecondaryContainer: Colors.white,

  // Tertiary Color
  tertiary: Color(0xFF141E46),
  onTertiary: Colors.white,

  // Tertiary Variant
  tertiaryContainer: Color(0x3E141E46),
  onTertiaryContainer: Colors.white,

  // Background Color
  background: Colors.white,
  onBackground: Colors.black,

  // Error Color
  onError: Colors.white,
  error: Colors.redAccent,

  // Surface Color
  surface: Colors.white,
  onSurface: Colors.black,

  // Variant
  brightness: Brightness.light,

  // Others
  shadow: Color.fromRGBO(0, 0, 0, 0.2),
  outline: Color(0xFFA7A7A7),
);

TextTheme textStyle = const TextTheme(
  // Body Text
  bodySmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ),

  // Headline Text
  headlineSmall: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  headlineMedium: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
  headlineLarge: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),

  // Title Text
  titleSmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  titleLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),

  // Label Text
  labelSmall: TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
  ),
  labelMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  ),
  labelLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),

  // Display Text
  displaySmall: TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
  ),
  displayMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  ),
  displayLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
).apply(
  bodyColor: colorScheme.onBackground,
  displayColor: colorScheme.onBackground,
);

ThemeData lightThemeData = ThemeData(
  fontFamily: 'Poppins',
  textTheme: textStyle,
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: colorScheme.onPrimary,
      backgroundColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      side: BorderSide(color: colorScheme.primary),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      errorMaxLines: 3,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.primary),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.shadow),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      labelStyle: textStyle.bodyLarge!.copyWith(
        color: colorScheme.outline,
      )),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        foregroundColor: colorScheme.onTertiary,
        backgroundColor: colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: BorderSide(color: colorScheme.tertiary)),
  ),
  cardTheme: CardTheme(
    color: colorScheme.tertiaryContainer,
    shadowColor: colorScheme.shadow,
    surfaceTintColor: Colors.transparent,
    margin: EdgeInsets.zero,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(colorScheme.onTertiary),
      backgroundColor: MaterialStateProperty.all(colorScheme.tertiary),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  ),
  scaffoldBackgroundColor: colorScheme.background,
  appBarTheme: AppBarTheme(
    backgroundColor: colorScheme.background,
    elevation: 0,
    iconTheme: IconThemeData(
      color: colorScheme.onBackground,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: colorScheme.primary,
    selectedItemColor: colorScheme.onPrimary,
    unselectedItemColor: colorScheme.onPrimary,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    surfaceTintColor: colorScheme.background,
    backgroundColor: colorScheme.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
  ),
  iconTheme: IconThemeData(
    color: colorScheme.onBackground,
  ),
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(colorScheme.primary),
    trackColor: MaterialStateProperty.all(colorScheme.secondary),
  ),
  dividerTheme: DividerThemeData(
    color: colorScheme.outline,
    thickness: 1,
    space: 0,
  ),
  colorScheme: colorScheme,
);
