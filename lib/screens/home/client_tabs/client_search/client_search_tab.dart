import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/tabs/client_deal_tab.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/tabs/client_item_tab.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/widgets/search_filter_bottom_sheet.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/filter_cubit.dart';

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
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => LocalItemsStorage(),
            ),
            BlocProvider(
              create: (_) => LocalDealsStorage(),
            ),
            BlocProvider(
              create: (_) => NavPositionCubit(),
            ),
          ],
          child: const TabBarView(
            children: [
              ClientItemTab(),
              ClientDealTab(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _filterBottomSheet(context);
          },
          mini: true,
          backgroundColor: AppColors.primaryLightColor,
          child: Image.asset(AppAssets.filterIcon, width: 18, height: 18,),
        ),
      ),
    );
  }

  void _filterBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return const SearchFilterBottomSheet();
      },
    );
  }
}
