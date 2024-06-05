import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/tabs/deals_tab.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/tabs/items_tab.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class VendorMenuTab extends StatelessWidget {
  const VendorMenuTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(text: LocaleKeys.items.tr()),
              Tab(text: LocaleKeys.deals.tr()),
            ],
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: context.currentTextTheme.displaySmall,
            unselectedLabelStyle: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryFontColor),
          ),
          title: Text(
            LocaleKeys.menu.tr(),
            style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
          ),
        ),
        body: const TabBarView(
          children: [
            ItemsTab(),
            DealsTab(),
          ],
        ),
      ),
    );
  }
}