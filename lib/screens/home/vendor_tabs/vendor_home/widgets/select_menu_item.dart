import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/main.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/item_widget.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/shared_preferences_service.dart';

typedef GetItemTitle = Function(String? title);

class SelectMenuItem extends StatelessWidget {
  const SelectMenuItem({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final sharedPreferencesService = sl.get<SharedPreferencesService>();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            TempLanguage().lblSelectMenuItem,
            style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryFontColor, fontSize: 24),
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
                        TempLanguage().lblNoDataFound,
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
                      context.pop(item.title);
                    },
                  );
                },
              ),
            );
          }
          return Center(
            child: Text(
              TempLanguage().lblNoDataFound,
              style: context.currentTextTheme.displaySmall,
            ),
          );
        },
      ) 
    );
  }
}
