import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart' as el;

import '../../application/config/design_system/app_colors.dart';
import '../../application/config/design_system/app_style.dart';

typedef Validator = String? Function(String?);
typedef OnChanged = void Function(String);
typedef OnTap = void Function();

class CustomFormField extends StatelessWidget {
  final bool isMandatory;
  final bool roundedBorder;
  final Key? currentKey;
  final String? initialValue;
  final String? fieldName;
  final String? hint;
  final Validator? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool hideText;
  final bool enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? minLines;
  final OnTap? onTap;
  final InputDecoration? decoration;
  final OnChanged? onChanged;
  final double borderRadius;

  const CustomFormField(
      {super.key,
      this.isMandatory = false,
      this.roundedBorder = true,
      this.currentKey,
      this.initialValue,
      this.fieldName,
      this.hint,
      this.validator,
      this.controller,
      this.keyboardType,
      this.hideText = false,
      this.enabled = true,
      this.suffixIcon,
      this.prefixIcon,
      this.inputFormatters = const [],
      this.maxLength,
      this.minLines,
      this.onTap,
      this.decoration,
      this.borderRadius = AppStyle.borderRadius,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: fieldName != null ? const EdgeInsets.only(top: 16, right: 10, left: 10) : const EdgeInsets.all(0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  spreadRadius: .1,
                  blurRadius: borderRadius,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextFormField(
              minLines: minLines,
              maxLines: minLines == null ? 1 : 6,
              key: currentKey,
              enabled: enabled,
              inputFormatters: inputFormatters,
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              obscureText: hideText,
              onChanged: onChanged,
              initialValue: initialValue,
              decoration: decoration ??
                  InputDecoration(
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon,
                    fillColor: AppColors.primaryLiteGrey,
                    hintText: hint,
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 50,
                      minHeight: 30,
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 50,
                      minHeight: 30,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    errorBorder: inputBorder,
                    focusedBorder: inputBorder,
                    disabledBorder: inputBorder,
                    focusedErrorBorder: inputBorder,
                    isDense: true,
                  ),
            ),
          ),
        ),
        if (fieldName != null) FieldName(fieldName: fieldName?.tr(), isMandatory: isMandatory),
      ],
    );
  }

  InputBorder get inputBorder {
    return roundedBorder
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
          )
        : const UnderlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          );
  }
}

class FieldName extends StatelessWidget {
  const FieldName({
    super.key,
    required this.fieldName,
    required this.isMandatory,
  });

  final String? fieldName;
  final bool isMandatory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            spreadRadius: .1,
            blurRadius: AppStyle.borderRadius,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: fieldName ?? '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (isMandatory)
              const TextSpan(
                text: '*',
                style: TextStyle(
                  color: AppColors.primaryRed,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CountryCodePicker extends StatelessWidget {
  final String countryCode;
  final String flagPath;

  const CountryCodePicker({super.key, required this.countryCode, required this.flagPath});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 8),
        SvgPicture.asset(flagPath),
        const SizedBox(width: 8),
        Text(
          countryCode,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 8),
        Text(
          "|",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
