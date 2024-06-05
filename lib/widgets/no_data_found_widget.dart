import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        LocaleKeys.noDataFound.tr(),
        style: context.currentTextTheme.displaySmall,
      ),
    );
  }
}