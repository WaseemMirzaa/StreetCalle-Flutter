import 'package:flutter/material.dart';
import 'package:street_calle/models/drop_down_item.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class LanguageDropDownWidget extends StatelessWidget {
  final List<DropDownItem> items;
  final DropDownItem? initialValue;
  final Function(DropDownItem?) onChanged;

  const LanguageDropDownWidget({
    Key? key,
    required this.items,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 100,
      child: DropdownButtonFormField<DropDownItem>(
        icon: const Icon(Icons.keyboard_arrow_down),
        iconEnabledColor: AppColors.primaryColor,
        value: initialValue,
        onChanged: onChanged,
        selectedItemBuilder: (BuildContext context) {
          return items.map<Widget>((DropDownItem item) {
            return Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(4),
                  child: item.icon,
                ),
                const SizedBox(width: 10),
                FittedBox(child: Text(item.title)),
              ],
            );
          }).toList();
        },
        borderRadius: BorderRadius.circular(40),
        items: items.map((item) {
          return DropdownMenuItem<DropDownItem>(
            value: item,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: item.icon,
                ),
                const SizedBox(width: 10),
                FittedBox(child: Text(item.title)),
              ],
            ),
          );
        }).toList(),
        style: context.currentTextTheme.labelSmall
            ?.copyWith(
            fontSize: 18,
            color: AppColors.primaryFontColor),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          filled: true,
          fillColor: AppColors.whiteColor,
          border: vendorSelectionBorder,
          enabledBorder: vendorSelectionBorder,
          focusedBorder: vendorSelectionBorder,
          disabledBorder: vendorSelectionBorder,
        ),
      ),
    );
  }
}