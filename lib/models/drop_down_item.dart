import 'package:flutter/cupertino.dart';

class DropDownItem {
  final String title;
  final String translatedTitle;
  final Widget icon;
  final String? url;

  DropDownItem({required this.title, required this.translatedTitle, required this.icon, this.url});
}