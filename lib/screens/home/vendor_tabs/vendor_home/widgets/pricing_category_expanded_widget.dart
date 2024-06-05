import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_expanded_cubit.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

OutlineInputBorder titleBorder = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.circular(40),
);

class PricingCategoryExpandedWidget extends StatelessWidget {
  const PricingCategoryExpandedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PricingCategoryExpandedCubit, bool>(
      builder: (context, state) {
        return Column(
          children: [
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
                      LocaleKeys.itemTitle.tr(),
                      style: context.currentTextTheme.displaySmall?.copyWith(
                          fontSize: 12, color: AppColors.placeholderColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 16.0, bottom: 16),
                    child: TextField(
                      controller: context.read<AddItemCubit>().titleController,
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
            state
                ? const SizedBox.shrink()
                : PriceInputWidget(
                    actualPriceController: context.read<AddItemCubit>().actualPriceController,
                    disCountedPriceController: context.read<AddItemCubit>().discountedPriceController,
                  ),

            state
                ? Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  context
                      .read<PricingCategoryCubit>()
                      .setCategoryType(PricingCategoryType.none);
                  context.read<PricingCategoryExpandedCubit>().collapse();
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.blackColor,
                ),
              ),
            )
                : const SizedBox.shrink(),

            /// small item (for our understanding)
            state
                ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withOpacity(0.35),
                    spreadRadius: 0.5, // Spread radius
                    blurRadius: 8, // Blur radius
                    offset:
                    const Offset(1, 8), // Offset in the Y direction
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 34, top: 12.0),
                    child: Text(
                      LocaleKeys.pricingCategoryTitle.tr(),
                      style: context.currentTextTheme.displaySmall
                          ?.copyWith(
                          fontSize: 12,
                          color: AppColors.placeholderColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 16.0, bottom: 16),
                    child: TextField(
                      controller: context
                          .read<AddItemCubit>()
                          .smallItemTitleController,
                      style: context.currentTextTheme.labelSmall
                          ?.copyWith(
                          fontSize: 16,
                          color: AppColors.primaryFontColor),
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
            )
                : const SizedBox.shrink(),
            SizedBox(
              height: state ? 32 : 0,
            ),
            state
                ? PriceInputWidget(
                   actualPriceController: context.read<AddItemCubit>().smallItemActualPriceController,
                   disCountedPriceController: context.read<AddItemCubit>().smallItemDiscountedPriceController,
                  )
                : const SizedBox.shrink(),
            SizedBox(
              height: state ? 32 : 0,
            ),

            /// medium item (for our understanding)
            state
                ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withOpacity(0.35),
                    spreadRadius: 0.5, // Spread radius
                    blurRadius: 8, // Blur radius
                    offset:
                    const Offset(1, 8), // Offset in the Y direction
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 34, top: 12.0),
                    child: Text(
                      LocaleKeys.pricingCategoryTitle.tr(),
                      style: context.currentTextTheme.displaySmall
                          ?.copyWith(
                          fontSize: 12,
                          color: AppColors.placeholderColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 16.0, bottom: 16),
                    child: TextField(
                      controller: context
                          .read<AddItemCubit>()
                          .mediumItemTitleController,
                      style: context.currentTextTheme.labelSmall
                          ?.copyWith(
                          fontSize: 16,
                          color: AppColors.primaryFontColor),
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
            )
                : const SizedBox.shrink(),
            SizedBox(
              height: state ? 32 : 0,
            ),
            state
                ? PriceInputWidget(
              actualPriceController: context.read<AddItemCubit>().mediumItemActualPriceController,
              disCountedPriceController: context.read<AddItemCubit>().mediumItemDiscountedPriceController,
            )
                : const SizedBox.shrink(),
            SizedBox(
              height: state ? 32 : 0,
            ),

            BlocBuilder<PricingCategoryCubit, PricingCategoryState>(
              builder: (context, state) {
                return state.categoryType == PricingCategoryType.large
                    ? Column(
                      children: [
                       /// large item (for our understanding)
                       Container(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 24.0),
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
                                left: 34, top: 12.0),
                            child: Text(
                              LocaleKeys.pricingCategoryTitle.tr(),
                              style: context.currentTextTheme.displaySmall
                                  ?.copyWith(
                                  fontSize: 12,
                                  color: AppColors.placeholderColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 16.0, bottom: 16),
                            child: TextField(
                              controller: context
                                  .read<AddItemCubit>()
                                  .largeItemTitleController,
                              style: context.currentTextTheme.labelSmall
                                  ?.copyWith(
                                  fontSize: 16,
                                  color: AppColors.primaryFontColor),
                              decoration: InputDecoration(
                                contentPadding:
                                const EdgeInsets.only(left: 10),
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
                       PriceInputWidget(
                      actualPriceController: context.read<AddItemCubit>().largeItemActualPriceController,
                      disCountedPriceController: context.read<AddItemCubit>().largeItemDiscountedPriceController,
                    ),
                     ],
                )
                    : const SizedBox.shrink();
              },
            ),

            const SizedBox(
              height: 24,
            ),
          ],
        );
      },
    );
  }
}

class PriceInputWidget extends StatelessWidget {
  const PriceInputWidget({Key? key, required this.actualPriceController, required this.disCountedPriceController}) : super(key: key);
  final TextEditingController actualPriceController;
  final TextEditingController disCountedPriceController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(LocaleKeys.price.tr(),
              style: context.currentTextTheme.labelLarge?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
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
                      LocaleKeys.actualPrice.tr(),
                      style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10,
                        right: 16.0,
                        bottom: 12,
                        top: 6),
                    child: TextField(
                      controller: actualPriceController,
                      keyboardType: TextInputType.number,
                      style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10),
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
          CustomInputField(controller: disCountedPriceController, title: LocaleKeys.discountedPrice.tr()),
        ],
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  const CustomInputField({Key? key, required this.controller, required this.title}) : super(key: key);
  final TextEditingController controller;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                title,
                style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 16.0, bottom: 12, top: 6),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
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
    );
  }
}