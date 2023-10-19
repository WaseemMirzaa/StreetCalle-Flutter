import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_custom_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/add_deal_button.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/item_image.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/food_type_expanded_widget.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/utils/common.dart';


class AddDeal extends StatelessWidget {
  const AddDeal({Key? key, required this.isUpdate, required this.isFromDetail}) : super(key: key);
  final bool isUpdate;
  final bool isFromDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TempLanguage().lblCreateMenu,
          style: context.currentTextTheme.titleMedium
              ?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                AppAssets.backIcon,
                width: 20,
                height: 20,
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(TempLanguage().lblAddDeal, style: const TextStyle(
                      fontFamily: METROPOLIS_BOLD,
                      fontSize: 18,
                      color: AppColors.primaryFontColor)),
              const SizedBox(
                height: 24,
              ),

              ItemImage(isUpdate: isUpdate),
              const SizedBox(
                height: 32,
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withOpacity(0.35),
                      spreadRadius: 0.5, // Spread radius
                      blurRadius: 8, // Blur radius
                      offset: const Offset(1, 8), // Offset in the Y direction
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 34, top: 12.0),
                      child: Text(
                        TempLanguage().lblDealTitle,
                        style: context.currentTextTheme.displaySmall?.copyWith(
                            fontSize: 12, color: AppColors.placeholderColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 16.0, bottom: 16),
                      child: TextField(
                        controller: context.read<AddDealCubit>().titleController,
                        style: context.currentTextTheme.labelSmall?.copyWith(
                            fontSize: 18, color: AppColors.primaryFontColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 10),
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.whiteColor,
                          border: titleBorder,
                          enabledBorder: titleBorder,
                          focusedBorder: titleBorder,
                          disabledBorder: titleBorder,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    const SizedBox(width: 40,),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: AppButton(
                         elevation: 8.0,
                          text: TempLanguage().lblMenuItem,
                          onTap: () async {
                            final addDealCubit = context.read<AddDealCubit>();
                            final result = await context.pushNamed(AppRoutingName.selectMenuItem);
                            if (result != null) {
                              addDealCubit.titleController.text += ' $result';
                            }
                          },
                          shapeBorder: RoundedRectangleBorder(
                              side: const BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          textStyle: context.currentTextTheme.displaySmall
                              ?.copyWith(
                              fontSize: 13,
                              color: AppColors.whiteColor),
                          color: AppColors.primaryColor,
                        ),
                        // child: ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: AppColors.primaryColor,
                        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        //     elevation: 8,
                        //     shadowColor: AppColors.blackColor
                        //   ),
                        //   onPressed: () async {
                        //     final addDealCubit = context.read<AddDealCubit>();
                        //     final result = await context.pushNamed(AppRoutingName.selectMenuItem);
                        //     if (result != null) {
                        //       addDealCubit.titleController.text += ' $result';
                        //     }
                        //   },
                        //   child: Text(
                        //     TempLanguage().lblMenuItem,
                        //     style: context.currentTextTheme.displaySmall
                        //         ?.copyWith(
                        //         fontSize: 13,
                        //         color: AppColors.whiteColor),
                        //   ),
                        // ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: AppButton(
                          elevation: 8.0,
                          text: TempLanguage().lblCustomItem,
                          onTap: () => context.read<AddCustomItemCubit>().expand(),
                          shapeBorder: RoundedRectangleBorder(
                              side: const BorderSide(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          textStyle: context.currentTextTheme.displaySmall
                              ?.copyWith(
                              fontSize: 11,
                              color: AppColors.whiteColor),
                          color: AppColors.primaryColor,
                        ),
                        // child: ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //       backgroundColor: AppColors.primaryColor,
                        //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        //       elevation: 8,
                        //       shadowColor: AppColors.blackColor,
                        //   ),
                        //   onPressed: () => context.read<AddCustomItemCubit>().expand(),
                        //   child: Text(
                        //     TempLanguage().lblCustomItem,
                        //     style: context.currentTextTheme.displaySmall
                        //         ?.copyWith(
                        //         fontSize: 11,
                        //         color: AppColors.whiteColor),
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
              const AddCustomItem(),
              const SizedBox(
                height: 32,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(TempLanguage().lblPrice,
                        style: context.currentTextTheme.labelLarge
                            ?.copyWith(
                            fontSize: 16,
                            color: AppColors.primaryFontColor)),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackColor.withOpacity(0.35),
                              spreadRadius: 0.5, // Spread radius
                              blurRadius: 8, // Blur radius
                              offset: const Offset(
                                  1, 8), // Offset in the Y direction
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 18, top: 12.0),
                              child: Text(
                                TempLanguage().lblActualPrice,
                                style: context.currentTextTheme.displaySmall
                                    ?.copyWith(
                                    fontSize: 12,
                                    color: AppColors.placeholderColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 16.0,
                                  bottom: 12,
                                  top: 6),
                              child: TextField(
                                controller: context
                                    .read<AddDealCubit>()
                                    .actualPriceController,
                                keyboardType: TextInputType.number,
                                style: context.currentTextTheme.labelSmall
                                    ?.copyWith(
                                    fontSize: 16,
                                    color: AppColors.primaryFontColor),
                                decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.only(left: 10),
                                  prefix: const Text('\$'),
                                  isDense: true,
                                  filled: true,
                                  fillColor: AppColors.whiteColor,
                                  border: titleBorder,
                                  enabledBorder: titleBorder,
                                  focusedBorder: titleBorder,
                                  disabledBorder: titleBorder,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackColor.withOpacity(0.35),
                              spreadRadius: 0.5, // Spread radius
                              blurRadius: 8, // Blur radius
                              offset: const Offset(
                                  1, 8), // Offset in the Y direction
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18, top: 12.0),
                              child: Text(
                                TempLanguage().lblDiscountedPrice,
                                style: context.currentTextTheme.displaySmall
                                    ?.copyWith(
                                    fontSize: 12,
                                    color: AppColors.placeholderColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 16.0, bottom: 12, top: 6),
                              child: TextField(
                                controller: context
                                    .read<AddDealCubit>()
                                    .discountedPriceController,
                                keyboardType: TextInputType.number,
                                style: context.currentTextTheme.labelSmall
                                    ?.copyWith(
                                    fontSize: 16,
                                    color: AppColors.primaryFontColor),
                                decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.only(left: 10),
                                  prefix: const Text('\$'),
                                  isDense: true,
                                  filled: true,
                                  fillColor: AppColors.whiteColor,
                                  border: titleBorder,
                                  enabledBorder: titleBorder,
                                  focusedBorder: titleBorder,
                                  disabledBorder: titleBorder,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withOpacity(0.35),
                      spreadRadius: 0.5, // Spread radius
                      blurRadius: 8, // Blur radius
                      offset: const Offset(1, 8), // Offset in the Y direction
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 34, top: 12.0),
                      child: Text(
                        TempLanguage().lblDealDescription,
                        style: context.currentTextTheme.displaySmall?.copyWith(
                            fontSize: 12, color: AppColors.placeholderColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 16.0, bottom: 16),
                      child: TextField(
                        controller: context.read<AddDealCubit>().descriptionController,
                        style: context.currentTextTheme.labelSmall?.copyWith(
                            fontSize: 18, color: AppColors.primaryFontColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 10),
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.whiteColor,
                          border: titleBorder,
                          enabledBorder: titleBorder,
                          focusedBorder: titleBorder,
                          disabledBorder: titleBorder,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),

              InkWell(
                onTap: () {
                  context.read<FoodTypeExpandedCubit>().expand();
                },
                child: Text(TempLanguage().lblItemAddFoodType,
                    style: const TextStyle(
                        fontFamily: METROPOLIS_BOLD,
                        fontSize: 18,
                        color: AppColors.primaryFontColor)),
              ),
              const SizedBox(
                height: 16,
              ),
              const FoodTypeExpandedWidget(isFromItem: false,),
              AddDealButton(isUpdate: isUpdate, isFromDetail: isFromDetail),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCustomItem extends StatelessWidget {
  const AddCustomItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCustomItemCubit, bool>(
      builder: (context, state) {
        return state
            ? Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  context.read<AddCustomItemCubit>().collapse();
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withOpacity(0.35),
                    spreadRadius: 0.5, // Spread radius
                    blurRadius: 8, // Blur radius
                    offset: const Offset(1, 8), // Offset in the Y direction
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 34, top: 12.0),
                    child: Text(
                      TempLanguage().lblCustomItem,
                      style: context.currentTextTheme.displaySmall?.copyWith(
                          fontSize: 12, color: AppColors.placeholderColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 16.0, bottom: 16),
                    child: TextField(
                      controller: context.read<AddDealCubit>().customTitleController,
                      style: context.currentTextTheme.labelSmall?.copyWith(
                          fontSize: 16, color: AppColors.primaryFontColor),
                      onSubmitted: (String? value) {
                        if (value != null) {
                          final addDealCubit = context.read<AddDealCubit>();
                          final addCustomItemCubit = context.read<AddCustomItemCubit>();
                          addDealCubit.titleController.text += ' $value';
                          addDealCubit.customTitleController.clear();
                          addCustomItemCubit.collapse();
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10),
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.whiteColor,
                        border: titleBorder,
                        enabledBorder: titleBorder,
                        focusedBorder: titleBorder,
                        disabledBorder: titleBorder,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
            : const SizedBox.shrink();
      },
    );
  }
}
