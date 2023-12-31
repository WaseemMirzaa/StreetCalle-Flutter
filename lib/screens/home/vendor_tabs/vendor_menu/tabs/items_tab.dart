import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/item_widget.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/delete_confirmation_dialog.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/shared_preferences_service.dart';

class ItemsTab extends StatelessWidget {
  const ItemsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sharedPreferencesService = sl.get<SharedPreferencesService>();
    final itemService = sl.get<ItemService>();
    final userId = sharedPreferencesService.getStringAsync(SharePreferencesKey.USER_ID);

    return StreamBuilder<List<Item>>(
      stream: itemService.getItems(userId),
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
                  isFromItemTab: true,
                  item: item,
                  onTap: () => _goToItemDetail(context, item),
                  onUpdate: () => _onUpdate(context, item),
                  onDelete: () => _showDeleteConfirmationDialog(context, item, itemService),
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

  void _showDeleteConfirmationDialog(BuildContext context, Item item, ItemService itemService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          title: TempLanguage().lblDeleteItem,
          body: TempLanguage().lblAreYouSureYouWantToDeleteItem,
          onConfirm: () async {
            final result = await itemService.deleteItem(item);
            if (result) {
              if (context.mounted) {
                showToast(context, TempLanguage().lblItemDeletedSuccessfully);
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

  void _onUpdate (BuildContext context, Item item) {
    final imageCubit =  context.read<ImageCubit>();
    final itemCubit = context.read<AddItemCubit>();
    final foodTypeExpandedCubit = context.read<FoodTypeExpandedCubit>();
    final foodTypeCubit = context.read<FoodTypeCubit>();
    final pricingCategoryExpandCubit = context.read<PricingCategoryExpandedCubit>();
    final pricingCategoryTypeCubit = context.read<PricingCategoryCubit>();

    foodTypeCubit.loadFromFirebase();
    itemCubit.titleController.text = item.title ?? '';
    itemCubit.descriptionController.text = item.description ?? '';
    itemCubit.foodTypeController.text = item.foodType ?? '';
    itemCubit.actualPriceController.text = item.actualPrice.toString() ?? '';
    itemCubit.discountedPriceController.text = item.discountedPrice.toString() ?? '';
    itemCubit.id = item.id ?? '';
    itemCubit.createdAt = item.createdAt ?? Timestamp.now();
    itemCubit.smallItemTitleController.text = item.smallItemTitle ?? '';
    itemCubit.mediumItemTitleController.text = item.mediumItemTitle ?? '';
    itemCubit.largeItemTitleController.text = item.largeItemTitle ?? '';
    itemCubit.smallItemActualPriceController.text = item.smallItemActualPrice.toString() ?? '';
    itemCubit.mediumItemActualPriceController.text = item.mediumItemActualPrice.toString() ?? '';
    itemCubit.largeItemActualPriceController.text = item.largeItemActualPrice.toString() ?? '';
    itemCubit.smallItemDiscountedPriceController.text = item.smallItemDiscountedPrice.toString() ?? '';
    itemCubit.mediumItemDiscountedPriceController.text = item.mediumItemDiscountedPrice.toString() ?? '';
    itemCubit.largeItemDiscountedPriceController.text = item.largeItemDiscountedPrice.toString() ?? '';

    if (itemCubit.foodTypeController.text.isNotEmpty) {
      foodTypeExpandedCubit.expand();
      foodTypeCubit.addString(itemCubit.foodTypeController.text);
      foodTypeCubit.defaultValue = itemCubit.foodTypeController.text;
    } else {
      foodTypeExpandedCubit.collapse();
      foodTypeCubit.defaultValue = TempLanguage().lblSelect;
    }

    if (itemCubit.smallItemTitleController.text.isNotEmpty) {
      pricingCategoryExpandCubit.expand();
      if (itemCubit.largeItemTitleController.text.isNotEmpty) {
        pricingCategoryTypeCubit.setCategoryType(PricingCategoryType.large);
      }
    } else {
      pricingCategoryExpandCubit.collapse();
    }

    imageCubit.resetForUpdateImage(item.image ?? '',);

    context.pushNamed(AppRoutingName.addItem, pathParameters: {IS_UPDATE: true.toString(), IS_FROM_DETAIL: false.toString()});
  }

  void _goToItemDetail(BuildContext context, Item item) {
    context.pushNamed(AppRoutingName.itemDetail, extra: item);
  }
}
