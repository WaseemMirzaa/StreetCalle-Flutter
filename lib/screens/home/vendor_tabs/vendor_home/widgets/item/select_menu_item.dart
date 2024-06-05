import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/item_widget.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/generated/locale_keys.g.dart';
import 'package:street_calle/main.dart';

typedef GetItemTitle = Function(String? title);

class SelectMenuItem extends StatelessWidget {
  const SelectMenuItem({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final sharedPreferencesService = sl.get<SharedPreferencesService>();
    final itemService = sl.get<ItemService>();

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            LocaleKeys.selectMenuItem.tr(),
            style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
          ),
          titleSpacing: 0,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(AppAssets.backIcon, width: 20, height: 20,)
              ],
            ),
          ),
        ),
      body: FutureBuilder<List<Item>>(
        future: itemService.getMenuItems(sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_ID)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor,),
            );
          }
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data?[index];
                  if (item == null) {
                    return Center(
                      child: Text(
                        LocaleKeys.noDataFound.tr(),
                        style: context.currentTextTheme.displaySmall,
                      ),
                    );
                  }
                  return ItemWidget(
                    isFromItemTab: false,
                    item: item,
                    onUpdate: (){},
                    onDelete: (){},
                    onTap: (){
                      context.pop(item.translatedTitle?[LANGUAGE] as String? ?? '');
                    },
                  );
                },
              ),
            );
          }
          return Center(
            child: Text(
              LocaleKeys.noDataFound.tr(),
              style: context.currentTextTheme.displaySmall,
            ),
          );
        },
      ) 
    );
  }
}
