import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tasks/presentaion/widgets/app_size_boxes.dart';

import '../../application/config/design_system/app_colors.dart';
import '../../generated/locale_keys.g.dart';
import 'custom_elevated_button.dart';
import 'custom_empty_widget.dart';
import 'custom_text.dart';
import 'scaffold_pading.dart';

void showDropdownOptions<T>(
  BuildContext context,
  TextEditingController controller,
  String Function(T?) displayTextFunction, {
  Function(T)? onChange,
  required List<T> items,
  bool multiSelect = false,
  List<T>? selectedItems,
  Function(List<T>)? onDone,
}) {
  final List<T> initialSelected = selectedItems != null ? List<T>.from(selectedItems) : <T>[];
  List<T> tempSelected = List<T>.from(initialSelected);
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    constraints: const BoxConstraints(maxHeight: 500),
    backgroundColor: AppColors.scaffoldColor,
    builder: (BuildContext context) {
      if (items.isEmpty) {
        return const Center(child: EmptyWidget());
      }
      if (!multiSelect) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: items.length,
                shrinkWrap: true,
                padding: symmetricPadding(0, 10),
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  final text = displayTextFunction.call(item);
                  return GestureDetector(
                    onTap: () {
                      controller.text = text;
                      if (onChange != null) onChange(item);
                      Navigator.pop(context);
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: controller.text == text ? AppColors.primaryColor : AppColors.primaryWhite,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: symmetricPadding(10, 10),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [CustomText(text)]),
                      ),
                    ),
                  );
                },
              ),
            ),
            30.heightBox(),
          ],
        );
      } else {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    padding: symmetricPadding(0, 10),
                    itemBuilder: (BuildContext context, int index) {
                      final item = items[index];
                      final text = displayTextFunction.call(item);
                      final isSelected = tempSelected.contains(item);
                      return CheckboxListTile(
                        title: CustomText(text, style: Theme.of(context).textTheme.headlineMedium),
                        value: isSelected,
                        onChanged: (bool? checked) {
                          setState(() {
                            if (checked == true) {
                              tempSelected.add(item);
                            } else {
                              tempSelected.remove(item);
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppColors.primaryColor,
                        checkColor: AppColors.primaryWhite,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomElevatedButton(
                    onPressed: () {
                      controller.text = tempSelected.map((item) => displayTextFunction(item)).join(', ');
                      if (onDone != null) onDone(tempSelected);
                      Navigator.pop(context);
                    },
                    title: LocaleKeys.submit.tr(),
                  ),
                ),
              ],
            );
          },
        );
      }
    },
  );
}
