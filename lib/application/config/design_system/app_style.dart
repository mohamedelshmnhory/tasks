import 'package:flutter/material.dart';

import '../../core/utils/constants/app_constants.dart';
import 'app_colors.dart';

class AppStyle {
  static TextStyle bold18 =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryBlack);
  static TextStyle bold14 =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryBlack);
  static TextStyle bold15 =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryBlack);
  static TextStyle bold16 =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryBlack);

  static TextStyle bold10 = const TextStyle(fontWeight: FontWeight.bold, fontSize: 10);
  static TextStyle bold12 = const TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
  static TextStyle bold22 =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.primaryBlack);

  static TextStyle bold20 =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primaryBlack);
  static TextStyle bold24 = const TextStyle(fontWeight: FontWeight.bold, fontSize: 24);
  static TextStyle meduim18 =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 18, color: AppColors.primaryBlack);

  static TextStyle meduim16 =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: AppColors.primaryBlack);
  static TextStyle meduim20 =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: AppColors.primaryBlack);
  static TextStyle meduim22 =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 22, color: AppColors.primaryBlack);
  static TextStyle meduim12 =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: AppColors.primaryBlack);
  static TextStyle meduim8 =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 8, color: AppColors.primaryBlack);
  static TextStyle meduim10 =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 10, color: AppColors.primaryBlack);
  static TextStyle meduim14 =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: AppColors.primaryBlack);

  static BoxDecoration buttonShadow({Color? color}) => BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color ?? Colors.grey,
            blurRadius: 5,
            offset: const Offset(2, 4),
          ),
        ],
      );

  static TextStyle generalTextStyle({double? fontSize, Color? color, FontWeight? fontWeight}) => TextStyle(
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? Colors.black,
        fontSize: fontSize ?? 18,
        fontFamily: FontFamily,
      );
  static const TextStyle bigTitle = TextStyle(
    color: AppColors.primaryBlack,
    fontWeight: FontWeight.bold,
    fontSize: 30,
  );

  static const TextStyle smallTitle = TextStyle(
    color: AppColors.primaryBlack,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  static const TextStyle normalTitle = TextStyle(
    color: AppColors.primaryBlack,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  static const double suffixIconSize = 20.0;

  static const double borderRadius = 10.0;
}
