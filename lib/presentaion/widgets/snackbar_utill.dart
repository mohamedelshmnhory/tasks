import 'package:flutter/material.dart';

import '../../application/config/design_system/app_colors.dart';
import 'custom_text.dart';

extension SnackBarExtension on BuildContext {
  void showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent, // Set background color to transparent
        elevation: 0.0,
        content: Builder(
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                color: isError ? AppColors.primaryRed : AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isError
                      ? const Icon(
                          Icons.info_outline,
                          color: Colors.white, // Change the icon color
                        )
                      : const Icon(
                          Icons.check_circle_sharp,
                          color: Colors.white, // Change the icon color
                        ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: CustomText(
                      message,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primaryWhite,
                          ), // Change the text color
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
