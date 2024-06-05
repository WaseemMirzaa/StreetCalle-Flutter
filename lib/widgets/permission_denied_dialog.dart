import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:street_calle/generated/locale_keys.g.dart';


class PermissionDeniedDialog extends StatelessWidget {
  const PermissionDeniedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.permissionDenied.tr()),
      content: Text(LocaleKeys.permissionDeniedPermanently.tr()),
      actions: [
        TextButton(
          child: Text(LocaleKeys.cancel.tr()),
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
        ),
        TextButton(
          child: Text(LocaleKeys.openSettings.tr()),
          onPressed: () {
            openAppSettings();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}