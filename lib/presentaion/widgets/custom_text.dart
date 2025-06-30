import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  const CustomText(this.text, {super.key, this.style, this.textAlign, this.maxLines, this.textDirection});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr(),
      style: style ?? Theme.of(context).textTheme.titleMedium,
      textAlign: textAlign,
      maxLines: maxLines,
      textDirection:
          textDirection ?? (context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr),
      overflow: TextOverflow.ellipsis,
    );
  }
}
