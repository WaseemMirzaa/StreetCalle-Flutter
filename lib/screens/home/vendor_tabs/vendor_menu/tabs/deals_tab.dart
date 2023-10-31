import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/deal_widget.dart';
import 'package:street_calle/services/deal_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/delete_confirmation_dialog.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/shared_preferences_service.dart';

class DealsTab extends StatelessWidget {
  const DealsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sharedPreferencesService = sl.get<SharedPreferencesService>();
    final dealService = sl.get<DealService>();
    final userId = sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_ID);

    return StreamBuilder<List<Deal>>(
      stream: dealService.getDeals(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor,),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                TempLanguage().lblNoDataFound,
                style: context.currentTextTheme.displaySmall,
              ),
            );
          }
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
                return DealWidget(
                  deal: deal,
                  onTap: ()=> _goToDealDetail(context, deal),
                  onDelete: ()=> _showDeleteConfirmationDialog(context, deal, dealService),
                  onUpdate: ()=> _onUpdate(context, deal),
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
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Deal deal, DealService dealService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          title: TempLanguage().lblDeleteDeal,
          body: TempLanguage().lblAreYouSureYouWantToDeleteDeal,
          onConfirm: () async {
            final result = await dealService.deleteDeal(deal);
            if (result) {
              if (context.mounted) {
                showToast(context, TempLanguage().lblDealDeletedSuccessfully);
              }
            } else {
              if (context.mounted) {
                showToast(context, TempLanguage().lblSomethingWentWrong);
              }
            }
          },
        );
      },
    );
  }

  void _onUpdate(BuildContext context, Deal deal) {
    final imageCubit =  context.read<ImageCubit>();
    final dealCubit = context.read<AddDealCubit>();
    final foodTypeExpandedCubit = context.read<FoodTypeExpandedCubit>();
    final foodTypeCubit = context.read<FoodTypeCubit>();

    foodTypeCubit.loadFromFirebase();
    dealCubit.titleController.text = deal.title ?? '';
    dealCubit.descriptionController.text = deal.description ?? '';
    dealCubit.foodTypeController.text = deal.foodType ?? '';
    dealCubit.actualPriceController.text = deal.actualPrice.toString() ?? '';
    dealCubit.discountedPriceController.text = deal.discountedPrice.toString() ?? '';
    dealCubit.id = deal.id ?? '';
    dealCubit.createdAt = deal.createdAt ?? Timestamp.now();

    if (dealCubit.foodTypeController.text.isNotEmpty) {
      foodTypeExpandedCubit.expand();
      foodTypeCubit.addString(dealCubit.foodTypeController.text);
      foodTypeCubit.defaultValue = dealCubit.foodTypeController.text;
    } else {
      foodTypeExpandedCubit.collapse();
      foodTypeCubit.defaultValue = TempLanguage().lblSelect;
    }

    imageCubit.resetForUpdateImage(deal.image ?? '',);
    context.pushNamed(AppRoutingName.addDeal, pathParameters: {IS_UPDATE: true.toString(), IS_FROM_DETAIL: true.toString()});
  }

  void _goToDealDetail(BuildContext context, Deal deal) {
    context.pushNamed(AppRoutingName.dealDetail, extra: deal, pathParameters: {IS_CLIENT: false.toString()});
  }
}
