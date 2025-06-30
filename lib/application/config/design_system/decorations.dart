import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../presentaion/widgets/scaffold_pading.dart';
import 'app_colors.dart';
import 'app_style.dart';

class AppDecorations {
  static InputDecoration inputTextDecoration({
    String? hint,
    String? label,
    Widget? suffixIcon,
    Widget? suffix,
    Widget? prefix,
    Widget? prefixIcon,
    Color? fillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    bool? isDense,
  }) =>
      InputDecoration(
        prefixIconConstraints: const BoxConstraints(minHeight: 16, minWidth: 46),
        prefixIcon: prefixIcon,
        suffix: suffix,
        prefix: prefix,
        contentPadding: isDense == null
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 18)
            : symmetricPadding(12, 12),
        suffixIcon: suffixIcon,
        focusedBorder: outlineInputBorder(focusedBorderColor),
        enabledBorder: outlineInputBorder(borderColor),
        disabledBorder: outlineInputBorder(borderColor),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.primaryRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.primaryRed),
        ),
        errorStyle: const TextStyle(
          color: AppColors.primaryRed,
          fontWeight: FontWeight.w400,
          height: 1.0,
          fontSize: 14.0,
        ),
        hintText: hint?.tr(),
        labelText: label,
        hintStyle: AppStyle.meduim16.copyWith(
          color: AppColors.primaryDarkGrey.withOpacity(0.5),
        ),
        fillColor: fillColor ?? AppColors.primaryWhite,
        // focusColor: AppColors.brownishGrey,
        filled: true,
        alignLabelWithHint: true,
        isDense: isDense,
        suffixStyle: AppStyle.meduim12.copyWith(
          color: AppColors.primaryDarkGrey.withOpacity(0.5),
        ),
        prefixStyle: AppStyle.meduim12.copyWith(
          color: AppColors.primaryDarkGrey.withOpacity(0.5),
        ),
        helperStyle: AppStyle.meduim12.copyWith(
          height: 0,
        ),
      );

  static Icon get buildArrowIcon => const Icon(Icons.keyboard_arrow_down);

  static OutlineInputBorder outlineInputBorder(Color? focusedBorderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(
        width: .5,
        color: focusedBorderColor ?? Colors.transparent,
      ),
    );
  }
}
