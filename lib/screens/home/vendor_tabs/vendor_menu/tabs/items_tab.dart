import 'package:flutter/material.dart';
import 'package:street_calle/main.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/item_widget.dart';

class ItemsTab extends StatelessWidget {
  const ItemsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_ID);

    return StreamBuilder<List<Item>>(
      stream: itemService.getItems(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor,),
          );
        }
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                return ItemWidget(item: item);
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
    );
  }
}
