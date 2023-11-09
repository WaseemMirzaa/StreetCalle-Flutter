import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';


class AddDealButton extends StatelessWidget {
  const AddDealButton({Key? key, required this.isUpdate, required this.isFromDetail}) : super(key: key);
  final bool isUpdate;
  final bool isFromDetail;

  @override
  Widget build(BuildContext context) {
    return   BlocConsumer<AddDealCubit, AddDealState>(
      listener: (context, state) {
        if (state is AddDealSuccess) {
          context.read<AddItemCubit>().clear();
          showToast(context, isUpdate ? TempLanguage().lblDealUpdatedSuccessfully : TempLanguage().lblDealAddedSuccessfully);
          context.pop(state.deal);
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
            child: AppButton(
              elevation: 0.0,
              onTap: () => isUpdate
                  ? updateDeal(context)
                  : addDeal(context),
              shapeBorder: RoundedRectangleBorder(
                  side: const BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(30)
              ),
              textStyle: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
              color: AppColors.primaryColor,
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

  Future<void> addDeal(BuildContext context) async {
    final imageCubit = context.read<ImageCubit>();
    final dealCubit = context.read<AddDealCubit>();

    final image = imageCubit.state.selectedImage.path;
    final title = dealCubit.titleController.text;
    final actualPrice = dealCubit.actualPriceController.text;
    final discountedPrice = dealCubit.discountedPriceController.text;


    if (image.isEmpty) {
      showToast(context, TempLanguage().lblSelectImage);
    } else if (title.isEmpty) {
      showToast(context, TempLanguage().lblAddDealTitle);
    } else if (actualPrice.isEmpty) {
      showToast(context, TempLanguage().lblAddDealPrice);
    } else if (actualPrice.isNotEmpty && discountedPrice.isNotEmpty && double.parse(discountedPrice) >= double.parse(actualPrice)) {
      showToast(context, TempLanguage().lblDiscountedPriceCantBeGrater);
    } else {
      dealCubit.addDeal(image);
    }
  }

  Future<void> updateDeal(BuildContext context) async {
    final imageCubit = context.read<ImageCubit>();
    final dealCubit = context.read<AddDealCubit>();

    final image = imageCubit.state.selectedImage.path;
    final url = imageCubit.state.url;
    final isUpdated = imageCubit.state.isUpdated;
    final title = dealCubit.titleController.text;
    final actualPrice = dealCubit.actualPriceController.text;
    final discountedPrice = dealCubit.discountedPriceController.text;

    if (image.isEmpty && url == null) {
      showToast(context, TempLanguage().lblSelectImage);
    } else if (title.isEmpty) {
      showToast(context, TempLanguage().lblAddDealTitle);
    } else if (actualPrice.isEmpty) {
      showToast(context, TempLanguage().lblAddDealPrice);
    } else if (actualPrice.isNotEmpty && discountedPrice.isNotEmpty && double.parse(discountedPrice) >= double.parse(actualPrice)) {
      showToast(context, TempLanguage().lblDiscountedPriceCantBeGrater);
    } else {
      if (isUpdated ?? false) {
        dealCubit.updateDeal(image: image, isUpdated: true);
      } else {
        dealCubit.updateDeal(image: url ?? '', isUpdated: false);
      }
    }
  }
}
