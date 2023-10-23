import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

class PermissionDeniedDialog extends StatelessWidget {
  const PermissionDeniedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(TempLanguage().lblPermissionDenied),
      content: Text(TempLanguage().lblPermissionDeniedPermanently),
      actions: [
        TextButton(
          child: Text(TempLanguage().lblCancel),
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
        ),
        TextButton(
          child: Text(TempLanguage().lblOpenSettings),
          onPressed: () {
            openAppSettings();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}