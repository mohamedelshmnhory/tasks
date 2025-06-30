import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static final lightTheme = ThemeData(
    // fontFamily: FontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryLiteGrey,
      iconTheme: const IconThemeData(color: AppColors.primaryBlack),
    ),
    colorScheme:
        ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(secondary: AppColors.primaryColor),
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.scaffoldColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          minimumSize: WidgetStateProperty.all<Size>(const Size(0, 48)),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.primaryGrey; // Disabled background color
            }
            return AppColors.primaryColor; // Enabled background color
          }),
          shape: WidgetStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ))),
    ),
    iconTheme: const IconThemeData(color: AppColors.primaryColor),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.primaryGrey,
          width: 1,
        ),
      ),
      filled: true,
      fillColor: AppColors.primaryColor.withOpacity(0.05),
    ),
  );

  static final darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
