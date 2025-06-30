import 'package:easy_localization/easy_localization.dart';
import 'package:tasks/presentaion/widgets/scaffold_pading.dart';
import 'package:flutter/material.dart';

import '../../application/config/design_system/app_colors.dart';
import '../../application/config/design_system/app_style.dart';
import '../../application/core/utils/helpers/keyboard/keyboard_helper.dart';
import 'custom_text.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final bool filled;
  final VoidCallback? onPressed;
  final Color color;

  const CustomElevatedButton({
    super.key,
    required this.title,
    this.isEnabled = true,
    this.filled = true,
    this.onPressed,
    this.color = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context, {BorderRadius? borderRadius}) {
    return ElevatedButton(
      onPressed: isEnabled
          ? () {
              onPressed?.call();
              KeyboardHelper.hideKeyboard(context);
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: filled ? color : AppColors.primaryWhite,
        minimumSize: const Size(double.maxFinite, 50),
        padding: symmetricPadding(0, 30),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: !isEnabled
                  ? AppColors.primaryGrey
                  : filled
                      ? color
                      : AppColors.primaryGrey,
              width: 1),
          borderRadius: borderRadius ?? BorderRadius.circular(AppStyle.borderRadius),
        ),
      ),
      child: CustomText(
        title.tr(),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: filled
                ? isEnabled
                    ? AppColors.primaryWhite
                    : AppColors.primaryBlack
                : AppColors.primaryDarkGrey,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
