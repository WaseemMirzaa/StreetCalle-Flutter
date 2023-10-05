import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/utils/common.dart';


OutlineInputBorder titleBorder =  OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.circular(40),
);


class AddItem extends StatelessWidget {
  const AddItem({Key? key, required this.isUpdate}) : super(key: key);
  final bool isUpdate;

  @override
  Widget build(BuildContext context) {
    final itemCubit = context.read<AddItemCubit>();
    if (!isUpdate) {
      context.read<ImageCubit>().resetImage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          TempLanguage().lblCreateMenu,
          style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
        titleSpacing: 0,
        leading: GestureDetector(
            onTap: () => context.pop(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(AppAssets.backIcon, width: 20, height: 20,)
              ],
            ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //const SizedBox(height: 16,),
              Text(
                TempLanguage().lblAddItem,
                style: const TextStyle(
                  fontFamily: METROPOLIS_BOLD,
                  fontSize: 18,
                  color: AppColors.primaryFontColor
                )
              ),
              const SizedBox(
                height: 24,
              ),

              const ItemImage(),
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
                        TempLanguage().lblItemTitle,
                        style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 16.0, bottom: 16),
                      child: TextField(
                        controller: itemCubit.titleController,
                        style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
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
                    Text(
                        TempLanguage().lblPrice,
                        style: context.currentTextTheme.labelLarge?.copyWith(fontSize: 14, color: AppColors.primaryFontColor)
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
                              offset: const Offset(1, 8), // Offset in the Y direction
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18, top: 12.0),
                              child: Text(
                                TempLanguage().lblActualPrice,
                                style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 16.0, bottom: 12, top: 6),
                              child: TextField(
                                controller: itemCubit.actualPriceController,
                                keyboardType: TextInputType.number,
                                style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
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
                              offset: const Offset(1, 8), // Offset in the Y direction
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
                                style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 16.0, bottom: 12, top: 6),
                              child: TextField(
                                controller: itemCubit.discountedPriceController,
                                keyboardType: TextInputType.number,
                                style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
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
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),

              Text(
                  TempLanguage().lblItemAddPricingCategories,
                  style: const TextStyle(
                      fontFamily: METROPOLIS_BOLD,
                      fontSize: 18,
                      color: AppColors.primaryFontColor
                  )
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
                        TempLanguage().lblItemDescription,
                        style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 16.0, bottom: 16),
                      child: TextField(
                        controller: itemCubit.descriptionController,
                        style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
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
                height: 24,
              ),

              Text(
                  TempLanguage().lblItemAddFoodType,
                  style: const TextStyle(
                      fontFamily: METROPOLIS_BOLD,
                      fontSize: 18,
                      color: AppColors.primaryFontColor
                  )
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
                        TempLanguage().lblItemFoodType,
                        style: context.currentTextTheme.displaySmall?.copyWith(fontSize: 12, color: AppColors.placeholderColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 16.0, bottom: 16),
                      child: TextField(
                        controller: itemCubit.foodTypeController,
                        style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryFontColor),
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


              BlocConsumer<AddItemCubit, AddItemState>(
                listener: (context, state) {
                  if (state is AddItemSuccess) {
                    itemCubit.clear();
                    showToast(context, TempLanguage().lblItemAddedSuccessfully);
                    context.pop();
                  } else if (state is AddItemFailure) {
                    showToast(context, state.error);
                  }
                },
                builder: (context, state) {
                  return state is AddItemLoading
                      ? const CircularProgressIndicator(color: AppColors.primaryColor,)
                      : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SizedBox(
                      width: context.width,
                      height: defaultButtonSize,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        onPressed: ()=> isUpdate ? updateItem(context) : addItem(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isUpdate ? const SizedBox.shrink() : Image.asset(AppAssets.add, width: 15, height: 15,),
                            SizedBox(width: isUpdate ? 0 : 16,),
                            Text(
                              isUpdate ? TempLanguage().lblItemUpdateToMenu : TempLanguage().lblItemAddToMenu,
                              style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addItem(BuildContext context) async {
    final imageCubit = context.read<ImageCubit>();
    final itemCubit = context.read<AddItemCubit>();

    final image = imageCubit.state.selectedImage.path;
    final title = itemCubit.titleController.text;
    final description = itemCubit.descriptionController.text;
    final foodType = itemCubit.foodTypeController.text;
    final actualPrice = itemCubit.actualPriceController.text;
    final discountedPrice = itemCubit.discountedPriceController.text;

    if (image.isEmpty) {
      showToast(context, TempLanguage().lblSelectImage);
    } else if (title.isEmpty) {
      showToast(context, TempLanguage().lblAddItemTitle);
    } else if (actualPrice.isEmpty) {
      showToast(context, TempLanguage().lblAddItemPrice);
    } else if (foodType.isEmpty ) {
      showToast(context, TempLanguage().lblAddItemFoodType);
    }  else {
      itemCubit.addItem(image);
    }
  }

  Future<void> updateItem(BuildContext context) async {
    final imageCubit = context.read<ImageCubit>();
    final itemCubit = context.read<AddItemCubit>();

    final image = imageCubit.state.selectedImage.path;
    final url = imageCubit.state.url;
    final isUpdated = imageCubit.state.isUpdated;
    final title = itemCubit.titleController.text;
    final description = itemCubit.descriptionController.text;
    final foodType = itemCubit.foodTypeController.text;
    final actualPrice = itemCubit.actualPriceController.text;
    final discountedPrice = itemCubit.discountedPriceController.text;

    if (image.isEmpty && url == null) {
      showToast(context, TempLanguage().lblSelectImage);
    } else if (title.isEmpty) {
      showToast(context, TempLanguage().lblAddItemTitle);
    } else if (actualPrice.isEmpty) {
      showToast(context, TempLanguage().lblAddItemPrice);
    } else if (foodType.isEmpty ) {
      showToast(context, TempLanguage().lblAddItemFoodType);
    }  else {
      if (isUpdated ?? false) {
        itemCubit.updateItem(image: image, isUpdated: true);
      } else {
        itemCubit.updateItem(image: url ?? '', isUpdated: false);
      }
    }
  }
}


class ItemImage extends StatelessWidget {
  const ItemImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: context.width,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.35),
              spreadRadius: 0.5, // Spread radius
              blurRadius: 8, // Blur radius
              offset: const Offset(1, 8), // Offset in the Y direction
            ),
          ],
        ),
        child: BlocBuilder<ImageCubit, ImageState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () async {
                context.read<ImageCubit>().selectImage();
              },
              child: state.selectedImage.path.isNotEmpty
                  ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: state.url != null ? Image.network(state.url!, fit: BoxFit.cover) : Image.file(File(state.selectedImage.path), fit: BoxFit.cover))
                  : state.url != null
                  ? Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(state.url!, fit: BoxFit.cover))
                  : Center(child: Image.asset(AppAssets.camera, width: 60, height: 60,),
              ),
            );
          },
        ),
      ),
    );
  }
}
