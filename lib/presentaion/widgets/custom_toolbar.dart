import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../application/config/design_system/app_style.dart';
import 'custom_text.dart';
import 'scaffold_pading.dart';

class CustomToolbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Orientation? orientation;

  const CustomToolbarWidget({super.key, required this.title, required this.orientation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30), // Adjust the spacing between the back button and title
          Row(
            children: [
              if (Navigator.canPop(context))
                GestureDetector(
                    onTap: () {
                      context.router.pop();
                    },
                    child: Icon(Icons.arrow_back_ios)),
              const SizedBox(width: 8), // Adjust the spacing between the back button and title
              if (orientation == Orientation.landscape) ...[
                Expanded(
                  child: Text(
                    title ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                    // Center the text within the available space
                  ),
                ),
              ],
            ],
          ),
          if (orientation == Orientation.portrait)
            const SizedBox(height: 21), // Adjust the spacing between the back button and title
          if (orientation == Orientation.portrait)
            Text(
              title ?? '',
              style: Theme.of(context).textTheme.headlineLarge,
              // Customize the title text style
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(orientation == Orientation.portrait ? 105 : 60);
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? bottomChild; // Nullable child widget
  final double appBarHeight;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    this.bottomChild,
    this.appBarHeight = kToolbarHeight,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight + (bottomChild != null ? 100 : 0.0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      title: CustomText(
        title ?? '',
        style: AppStyle.meduim16,
      ),
      leading: leading,
      actions: actions,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      bottom: bottomChild != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Padding(
                padding: symmetricPadding(0, 20),
                child: bottomChild!,
              ),
            )
          : null,
    );
  }
}
