import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Function onConfirm; // Callback function to execute when the user confirms deletion
  final String title;
  final String body;

  DeleteConfirmationDialog({super.key,
    required this.onConfirm,
    required this.title,
    required this.body
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(LocaleKeys.cancel.tr(), style: const TextStyle(color: AppColors.redColor),),
        ),
        TextButton(
          onPressed: () {
            onConfirm(); // Execute the delete action
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(LocaleKeys.delete.tr()),
        ),
      ],
    );
  }
}