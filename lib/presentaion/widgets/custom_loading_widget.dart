import 'package:flutter/material.dart';

import '../../application/config/design_system/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color = AppColors.primaryColor});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      color: color,
    ));
  }
}


class LoadingStackWidget extends StatelessWidget {
  const LoadingStackWidget({super.key, this.color = AppColors.primaryColor});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.transparent,
        child: const LoadingWidget(),
      ),
    );
  }
}