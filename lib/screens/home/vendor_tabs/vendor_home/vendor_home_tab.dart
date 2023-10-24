import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/delete_confirmation_dialog.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/item_view.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_drop_down_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_expanded_cubit.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/shared_preferences_service.dart';

class VendorHomeTab extends StatelessWidget {
  const VendorHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sharedPreferencesService = sl.get<SharedPreferencesService>();
    final itemService = sl.get<ItemService>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 36.0, bottom: 24),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                child: context.read<UserCubit>().state.userImage.isEmpty
                    ? const Icon(
                        Icons.image_outlined,
                        color: AppColors.whiteColor,
                      )
                    : ClipOval(
                        child: Image.network(
                          context.read<UserCubit>().state.userImage,
                          fit: BoxFit.cover,
                        ),
                      )),
            const SizedBox(
              height: 2,
            ),
            Text(
              '${TempLanguage().lblHello} ${context.read<UserCubit>().state.userName.capitalizeEachFirstLetter()}!',
              textAlign: TextAlign.center,
              style: context.currentTextTheme.titleMedium
                  ?.copyWith(fontSize: 20, color: AppColors.primaryFontColor),
            ),
            const SizedBox(
              height: 16,
            ),

            BlocSelector<UserCubit, UserState, String>(
              selector: (userState) => userState.vendorType,
              builder: (context, state) {
                return (state.isEmpty ||
                        state.toLowerCase() == VendorType.individual.name)
                    ? const SizedBox.shrink()
                    : InkWell(
                        onTap: () {
                          context.pushNamed(AppRoutingName.manageEmployee);
                        },
                        child: Text(
                          TempLanguage().lblManageEmployees,
                          style: context.currentTextTheme.titleMedium?.copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 24,
                              decoration: TextDecoration.underline),
                        ),
                      );
              },
            ),

            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                onChanged: (String? value) => _searchQuery(context, value),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  filled: true,
                  prefixIcon: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Image.asset(
                          AppAssets.searchIcon,
                          width: 18,
                          height: 18,
                        ),
                      )
                    ],
                  ),
                  hintStyle: context.currentTextTheme.displaySmall?.copyWith(
                      color: AppColors.placeholderColor, fontSize: 15),
                  hintText: TempLanguage().lblSearchItemDeal,
                  fillColor: Colors.white70,
                  border: searchBorder,
                  focusedBorder: searchBorder,
                  disabledBorder: searchBorder,
                  enabledBorder: searchBorder,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: defaultButtonSize,
                      child: AppButton(
                        elevation: 0.0,
                        onTap: () {
                          _addItem(context);
                        },
                        shapeBorder: RoundedRectangleBorder(
                            side:
                                const BorderSide(color: AppColors.primaryColor),
                            borderRadius: BorderRadius.circular(30)),
                        textStyle: context.currentTextTheme.labelLarge
                            ?.copyWith(color: AppColors.whiteColor),
                        color: AppColors.primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAssets.add,
                              width: 15,
                              height: 15,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              TempLanguage().lblAddItem,
                              style: context.currentTextTheme.labelLarge
                                  ?.copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      // child: ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: AppColors.primaryColor,
                      //   ),
                      //   onPressed: () => _addItem(context),
                      //   child: Row(
                      //     children: [
                      //       Image.asset(AppAssets.add, width: 15, height: 15,),
                      //       const SizedBox(
                      //         width: 16,
                      //       ),
                      //       Text(
                      //         TempLanguage().lblAddItem,
                      //         style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor, fontSize: 16),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: defaultButtonSize,
                      child: AppButton(
                        elevation: 0.0,
                        onTap: () {
                          _addDeal(context);
                        },
                        shapeBorder: RoundedRectangleBorder(
                            side:
                                const BorderSide(color: AppColors.primaryColor),
                            borderRadius: BorderRadius.circular(30)),
                        textStyle: context.currentTextTheme.labelLarge
                            ?.copyWith(color: AppColors.whiteColor),
                        color: AppColors.primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAssets.add,
                              width: 15,
                              height: 15,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              TempLanguage().lblAddDeal,
                              style: context.currentTextTheme.labelLarge
                                  ?.copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      // child: ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: AppColors.primaryColor,
                      //   ),
                      //   onPressed: () => _addDeal(context),
                      //   child: Row(
                      //     children: [
                      //       Image.asset(AppAssets.add, width: 15, height: 15,),
                      //       const SizedBox(
                      //         width: 16,
                      //       ),
                      //       Text(
                      //         TempLanguage().lblAddDeal,
                      //         style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor, fontSize: 16),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),

            //TODO: Do it with bloc rather than direct use
            Expanded(
              child: StreamBuilder<List<Item>>(
                stream: itemService.getItems(sharedPreferencesService
                    .getStringAsync(SharePreferencesKey.USER_ID)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
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
                    return BlocBuilder<SearchCubit, String>(
                      builder: (context, state) {
                        List<Item> list = [];
                        if (state.isNotEmpty) {
                          list = snapshot.data!.where((item) {
                            final itemName = item.title!.toLowerCase();
                            return itemName.contains(state.toLowerCase());
                          }).toList();
                        } else {
                          list = snapshot.data!;
                        }

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final item = list[index];
                            return ItemView(
                              index: index,
                              item: item,
                              onUpdate: () => _onUpdate(context, item),
                              onDelete: () => _showDeleteConfirmationDialog(
                                  context, item, itemService),
                              onTap: () => _goToItemDetail(context, item),
                            );
                          },
                        );
                      },
                    );
                  }
                  return Center(
                    child: Text(
                      TempLanguage().lblNoDataFound,
                      style: context.currentTextTheme.displaySmall,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Item item, ItemService itemService) {
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

  void _onUpdate(BuildContext context, Item item) {
    final imageCubit = context.read<ImageCubit>();
    final itemCubit = context.read<AddItemCubit>();
    final foodTypeExpandedCubit = context.read<FoodTypeExpandedCubit>();
    final foodTypeCubit = context.read<FoodTypeCubit>();
    final pricingCategoryExpandCubit =
        context.read<PricingCategoryExpandedCubit>();
    final pricingCategoryTypeCubit = context.read<PricingCategoryCubit>();

    imageCubit.resetForUpdateImage(
      item.image ?? '',
    );
    foodTypeCubit.loadFromFirebase();
    itemCubit.titleController.text = item.title ?? '';
    itemCubit.descriptionController.text = item.description ?? '';
    itemCubit.foodTypeController.text = item.foodType ?? '';
    itemCubit.actualPriceController.text = item.actualPrice.toString() ?? '';
    itemCubit.discountedPriceController.text =
        item.discountedPrice.toString() ?? '';
    itemCubit.id = item.id ?? '';
    itemCubit.createdAt = item.createdAt ?? Timestamp.now();
    itemCubit.smallItemTitleController.text = item.smallItemTitle ?? '';
    itemCubit.mediumItemTitleController.text = item.mediumItemTitle ?? '';
    itemCubit.largeItemTitleController.text = item.largeItemTitle ?? '';
    itemCubit.smallItemActualPriceController.text =
        item.smallItemActualPrice.toString() ?? '';
    itemCubit.mediumItemActualPriceController.text =
        item.mediumItemActualPrice.toString() ?? '';
    itemCubit.largeItemActualPriceController.text =
        item.largeItemActualPrice.toString() ?? '';
    itemCubit.smallItemDiscountedPriceController.text =
        item.smallItemDiscountedPrice.toString() ?? '';
    itemCubit.mediumItemDiscountedPriceController.text =
        item.mediumItemDiscountedPrice.toString() ?? '';
    itemCubit.largeItemDiscountedPriceController.text =
        item.largeItemDiscountedPrice.toString() ?? '';

    if (itemCubit.foodTypeController.text.isNotEmpty) {
      foodTypeExpandedCubit.expand();
      foodTypeCubit.addString(itemCubit.foodTypeController.text);
      foodTypeCubit.defaultValue = itemCubit.foodTypeController.text;
    } else {
      foodTypeExpandedCubit.collapse();
      foodTypeCubit.defaultValue = TempLanguage().lblSelect;
    }

    if (itemCubit.smallItemTitleController.text.isNotEmpty) {
      pricingCategoryTypeCubit.setCategoryType(PricingCategoryType.smallMedium);
      pricingCategoryExpandCubit.expand();
      if (itemCubit.largeItemTitleController.text.isNotEmpty) {
        pricingCategoryTypeCubit.setCategoryType(PricingCategoryType.large);
      }
    } else {
      pricingCategoryExpandCubit.collapse();
    }

    context.pushNamed(AppRoutingName.addItem, pathParameters: {
      IS_UPDATE: true.toString(),
      IS_FROM_DETAIL: false.toString()
    });
  }

  void _searchQuery(BuildContext context, String? value) {
    context.read<SearchCubit>().updateQuery(value ?? '');
  }

  void _addDeal(BuildContext context) {
    _resetCubitStates(context);

    final addDealCubit = context.read<AddDealCubit>();
    addDealCubit.clearControllers();

    context.pushNamed(AppRoutingName.addDeal, pathParameters: {
      IS_UPDATE: false.toString(),
      IS_FROM_DETAIL: false.toString()
    });
  }

  void _addItem(BuildContext context) {
    _resetCubitStates(context);

    final pricingCubit = context.read<PricingCategoryCubit>();
    final pricingExpandedCubit = context.read<PricingCategoryExpandedCubit>();
    final addItemCubit = context.read<AddItemCubit>();

    pricingExpandedCubit.collapse();
    pricingCubit.setCategoryType(PricingCategoryType.none);
    addItemCubit.clear();

    context.pushNamed(AppRoutingName.addItem, pathParameters: {
      IS_UPDATE: false.toString(),
      IS_FROM_DETAIL: false.toString()
    });
  }

  void _resetCubitStates(BuildContext context) {
    final imageCubit = context.read<ImageCubit>();
    final foodTypeExpandedCubit = context.read<FoodTypeExpandedCubit>();
    final foodTypeDropDownCubit = context.read<FoodTypeDropDownCubit>();
    final foodTypeCubit = context.read<FoodTypeCubit>();

    imageCubit.resetImage();
    foodTypeExpandedCubit.collapse();
    foodTypeDropDownCubit.resetState();
    foodTypeCubit.defaultValue = TempLanguage().lblSelect;
    foodTypeCubit.loadFromFirebase();
  }

  void _goToItemDetail(BuildContext context, Item item) {
    context.pushNamed(AppRoutingName.itemDetail, extra: item);
  }
}
