import 'package:flutter/material.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Function onConfirm; // Callback function to execute when the user confirms deletion

  DeleteConfirmationDialog({super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Item?'),
      content: const Text('Are you sure you want to delete this item?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel', style: TextStyle(color: AppColors.redColor),),
        ),
        TextButton(
          onPressed: () {
            onConfirm(); // Execute the delete action
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}