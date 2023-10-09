import 'package:flutter/material.dart';
import 'package:street_calle/main.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/deal_widget.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

class DealsTab extends StatelessWidget {
  const DealsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_ID);

    return StreamBuilder<List<Deal>>(
      stream: dealService.getDeals(userId),
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
                final deal = snapshot.data?[index];
                if (deal == null) {
                  return Center(
                    child: Text(
                      TempLanguage().lblNoDataFound,
                      style: context.currentTextTheme.displaySmall,
                    ),
                  );
                }
                return DealWidget(deal: deal);
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
