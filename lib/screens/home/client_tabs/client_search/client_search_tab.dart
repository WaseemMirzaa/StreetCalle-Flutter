import 'package:flutter/material.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/tabs/client_deal_tab.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/tabs/client_item_tab.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

class ClientSearchTab extends StatelessWidget {
  const ClientSearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(text: TempLanguage().lblItems),
              Tab(text: TempLanguage().lblDeals),
            ],
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: context.currentTextTheme.displaySmall,
            unselectedLabelStyle: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryFontColor),
          ),
          title: Text(
            TempLanguage().lblSearch,
            style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
          ),
        ),
        body: const TabBarView(
          children: [
            ClientItemTab(),
            ClientDealTab(),
          ],
        ),
      ),
    );
  }
}
