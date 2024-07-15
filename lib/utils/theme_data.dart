import 'package:flutter/material.dart';

ColorScheme colorScheme = ColorScheme(
  // Primary Color
  primary: const Color(0xFF41B06E),
  onPrimary: Colors.white,

  // Primary Variant
  primaryContainer: const Color(0xFF009D7D),
  onPrimaryContainer: Colors.white,

  // Secondary Color
  secondary: Colors.grey.shade100,
  onSecondary: Colors.black,

  // Secondary Variant
  secondaryContainer: const Color(0xFF9F9F9F),
  onSecondaryContainer: Colors.white,

  // Tertiary Color
  tertiary: const Color(0xff2f4858),
  onTertiary: Colors.white,

  // Tertiary Variant
  tertiaryContainer: const Color(0xFF1c5d6f),
  onTertiaryContainer: Colors.white,

  // Error Color
  onError: Colors.white,
  error: Colors.redAccent,

  // Surface Color
  surface: Colors.white,
  onSurface: Colors.black,

  // Variant
  brightness: Brightness.light,

  // Others
  shadow: const Color.fromRGBO(0, 0, 0, 0.2),
  outline: const Color(0xFFA7A7A7),
);

TextTheme textTheme = const TextTheme(
  // Body Text
  bodySmall: TextStyle(
    fontSize: 12,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.normal,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.normal,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.normal,
  ),

  // Headline Text
  headlineSmall: TextStyle(
    fontSize: 18,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
  ),
  headlineMedium: TextStyle(
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
  ),
  headlineLarge: TextStyle(
    fontSize: 24,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
  ),

  // Title Text
  titleSmall: TextStyle(
    fontSize: 12,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
  ),
  titleMedium: TextStyle(
    fontSize: 14,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
  ),
  titleLarge: TextStyle(
    fontSize: 16,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
  ),

  // Label Text
  labelSmall: TextStyle(
    fontSize: 10,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.normal,
  ),
  labelMedium: TextStyle(
    fontSize: 12,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.normal,
  ),
  labelLarge: TextStyle(
    fontSize: 14,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.normal,
  ),

  // Display Text
  displaySmall: TextStyle(
    fontSize: 10,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
  ),
  displayMedium: TextStyle(
    fontSize: 12,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
  ),
  displayLarge: TextStyle(
    fontSize: 14,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
  ),
).apply(
  bodyColor: colorScheme.onSurface,
  displayColor: colorScheme.onSurface,
  fontFamily: 'Poppins',
);

ThemeData lightThemeData = ThemeData(
  fontFamily: 'Poppins',
  textTheme: textTheme,
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: colorScheme.onPrimary,
      backgroundColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      side: const BorderSide(color: Colors.transparent),
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
      labelStyle: textTheme.bodyLarge!.copyWith(
        color: colorScheme.outline,
      )),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: colorScheme.onTertiary,
      backgroundColor: colorScheme.tertiary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      side: const BorderSide(color: Colors.transparent),
    ),
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
      foregroundColor: WidgetStateProperty.all(colorScheme.onTertiary),
      backgroundColor: WidgetStateProperty.all(colorScheme.tertiary),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  ),
  scaffoldBackgroundColor: colorScheme.surface,
  appBarTheme: AppBarTheme(
    backgroundColor: colorScheme.surface,
    elevation: 0,
    titleTextStyle: textTheme.headlineSmall,
    iconTheme: IconThemeData(
      color: colorScheme.onSurface,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: colorScheme.primary,
    selectedItemColor: colorScheme.onPrimary,
    unselectedItemColor: colorScheme.onPrimary,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    surfaceTintColor: colorScheme.surface,
    backgroundColor: colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
  ),
  iconTheme: IconThemeData(
    color: colorScheme.onSurface,
  ),
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: WidgetStateProperty.all(colorScheme.primary),
    trackColor: WidgetStateProperty.all(colorScheme.secondary),
  ),
  dividerTheme: DividerThemeData(
    color: colorScheme.outline,
    thickness: 1,
    space: 0,
  ),
  colorScheme: colorScheme,
);
