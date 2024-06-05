import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/generated/locale_keys.g.dart';


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
          showToast(context, isUpdate
              ? LocaleKeys.dealUpdatedSuccessfully.tr()
              : LocaleKeys.dealAddedSuccessfully.tr()
          );
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
                        ? LocaleKeys.itemUpdateToMenu.tr()
                        : LocaleKeys.itemAddToMenu.tr(),
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
    final userCubit = context.read<UserCubit>();

    final image = imageCubit.state.selectedImage.path;
    final title = dealCubit.titleController.text;
    final actualPrice = dealCubit.actualPriceController.text;
    final discountedPrice = dealCubit.discountedPriceController.text;
    final category = userCubit.state.category;
    final translatedCategory = userCubit.state.translatedCategory;


    if (image.isEmpty) {
      showToast(context, LocaleKeys.selectImage.tr());
    } else if (title.isEmpty) {
      showToast(context, LocaleKeys.addDealTitle.tr());
    } else if (actualPrice.isEmpty) {
      showToast(context, LocaleKeys.addDealPrice.tr());
    } else if (actualPrice.isNotEmpty && discountedPrice.isNotEmpty && double.parse(discountedPrice) >= double.parse(actualPrice)) {
      showToast(context, LocaleKeys.discountedPriceCantBeGrater.tr());
    } else {
      dealCubit.addDeal(image, category, translatedCategory);
    }
  }

  Future<void> updateDeal(BuildContext context) async {
    final imageCubit = context.read<ImageCubit>();
    final dealCubit = context.read<AddDealCubit>();
    final userCubit = context.read<UserCubit>();

    final image = imageCubit.state.selectedImage.path;
    final url = imageCubit.state.url;
    final isUpdated = imageCubit.state.isUpdated;
    final title = dealCubit.titleController.text;
    final actualPrice = dealCubit.actualPriceController.text;
    final discountedPrice = dealCubit.discountedPriceController.text;
    final category = userCubit.state.category;
    final translatedCategory = userCubit.state.translatedCategory;

    if (image.isEmpty && url == null) {
      showToast(context, LocaleKeys.selectImage.tr());
    } else if (title.isEmpty) {
      showToast(context, LocaleKeys.addDealTitle.tr());
    } else if (actualPrice.isEmpty) {
      showToast(context, LocaleKeys.addDealPrice.tr());
    } else if (actualPrice.isNotEmpty && discountedPrice.isNotEmpty && double.parse(discountedPrice) >= double.parse(actualPrice)) {
      showToast(context, LocaleKeys.discountedPriceCantBeGrater.tr());
    } else {
      if (isUpdated ?? false) {
        dealCubit.updateDeal(image: image, isUpdated: true, category: category, translatedCategory: translatedCategory);
      } else {
        dealCubit.updateDeal(image: url ?? '', isUpdated: false, category: category, translatedCategory: translatedCategory);
      }
    }
  }
}
