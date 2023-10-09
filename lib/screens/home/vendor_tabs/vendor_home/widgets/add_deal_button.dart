import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_cubit.dart';


class AddDealButton extends StatelessWidget {
  const AddDealButton({Key? key, required this.isUpdate}) : super(key: key);
  final bool isUpdate;

  @override
  Widget build(BuildContext context) {
    return   BlocConsumer<AddDealCubit, AddDealState>(
      listener: (context, state) {
        if (state is AddDealSuccess) {
          context.read<AddItemCubit>().clear();
          showToast(context, TempLanguage().lblItemAddedSuccessfully);
          context.pop();
        } else if (state is AddDealFailure) {
          showToast(context, state.error);
        }
      },
      builder: (context, state) {
        return state is AddDealLoading
            ? const CircularProgressIndicator(
          color: AppColors.primaryColor,
        )
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            width: context.width,
            height: defaultButtonSize,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              onPressed: () => isUpdate
                  ? updateItem(context)
                  : addItem(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isUpdate
                      ? const SizedBox.shrink()
                      : Image.asset(
                    AppAssets.add,
                    width: 15,
                    height: 15,
                  ),
                  SizedBox(
                    width: isUpdate ? 0 : 16,
                  ),
                  Text(
                    isUpdate
                        ? TempLanguage().lblItemUpdateToMenu
                        : TempLanguage().lblItemAddToMenu,
                    style: context.currentTextTheme.labelLarge
                        ?.copyWith(color: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> addItem(BuildContext context) async {
    final imageCubit = context.read<ImageCubit>();
    final dealCubit = context.read<AddDealCubit>();

    final image = imageCubit.state.selectedImage.path;
    final title = dealCubit.titleController.text;
    final actualPrice = dealCubit.actualPriceController.text;


    if (image.isEmpty) {
      showToast(context, TempLanguage().lblSelectImage);
    } else if (title.isEmpty) {
      showToast(context, TempLanguage().lblAddItemTitle);
    } else if (actualPrice.isEmpty) {
      showToast(context, TempLanguage().lblAddItemPrice);
    } else {
      dealCubit.addDeal(image);
    }
  }

  Future<void> updateItem(BuildContext context) async {
    final imageCubit = context.read<ImageCubit>();
    final itemCubit = context.read<AddItemCubit>();
    final pricingCategoryType = context.read<PricingCategoryCubit>().state.categoryType;

    final image = imageCubit.state.selectedImage.path;
    final url = imageCubit.state.url;
    final isUpdated = imageCubit.state.isUpdated;
    final title = itemCubit.titleController.text;
    final description = itemCubit.descriptionController.text;
    final foodType = itemCubit.foodTypeController.text;
    final actualPrice = itemCubit.actualPriceController.text;
    final discountedPrice = itemCubit.discountedPriceController.text;
    final smallActualPrice = itemCubit.smallItemActualPriceController.text;
    final smallTitle = itemCubit.smallItemTitleController.text;

    if (image.isEmpty && url == null) {
      showToast(context, TempLanguage().lblSelectImage);
    } else if (title.isEmpty) {
      showToast(context, TempLanguage().lblAddItemTitle);
    } else if (pricingCategoryType == PricingCategoryType.smallMedium && smallTitle.isEmpty) {
      showToast(context, TempLanguage().lblAddItemTitle);
    } else if (actualPrice.isEmpty || (pricingCategoryType == PricingCategoryType.smallMedium && smallActualPrice.isEmpty)) {
      showToast(context, TempLanguage().lblAddItemPrice);
    } else {
      // if (isUpdated ?? false) {
      //   itemCubit.updateItem(image: image, isUpdated: true);
      // } else {
      //   itemCubit.updateItem(image: url ?? '', isUpdated: false);
      // }
    }
  }
}
