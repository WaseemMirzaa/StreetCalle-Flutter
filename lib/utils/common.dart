import 'package:flutter/material.dart';

void showToast(BuildContext context, String title) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(title),
      action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

/// has match return bool for pattern matching
bool hasMatch(String? s, String p) {
  return (s == null) ? false : RegExp(p).hasMatch(s);
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent user from dismissing the dialog
    builder: (BuildContext context) {
      return const AlertDialog(
        content: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircularProgressIndicator(color: Colors.black,),
              SizedBox(width: 16),
              Text('Please wait...'),
            ],
          ),
        ),
      );
    },
  );
}