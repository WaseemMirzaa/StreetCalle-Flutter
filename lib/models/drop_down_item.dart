import 'package:flutter/cupertino.dart';

class DropDownItem {
  final String title;
  final Widget icon;
  final String? url;

  DropDownItem({required this.title, required this.icon, this.url});
}