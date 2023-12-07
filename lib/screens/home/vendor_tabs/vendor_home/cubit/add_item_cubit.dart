import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_cubit.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/utils/common.dart';
part 'add_item_state.dart';

class AddItemCubit extends Cubit<AddItemState> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController foodTypeController = TextEditingController();
  final TextEditingController customFoodTypeController = TextEditingController();
  final TextEditingController actualPriceController = TextEditingController();
  final TextEditingController discountedPriceController = TextEditingController();
  String? id;
  Timestamp? createdAt;
  final ItemService itemService;
  final SharedPreferencesService sharedPrf;
  final PricingCategoryCubit pricingCategoryCubit;

  /// pricing categories
  /// let suppose first one is small, medium and large
  final TextEditingController smallItemActualPriceController = TextEditingController();
  final TextEditingController smallItemDiscountedPriceController = TextEditingController();
  final TextEditingController smallItemTitleController = TextEditingController();

  final TextEditingController mediumItemActualPriceController = TextEditingController();
  final TextEditingController mediumItemDiscountedPriceController = TextEditingController();
  final TextEditingController mediumItemTitleController = TextEditingController();

  final TextEditingController largeItemActualPriceController = TextEditingController();
  final TextEditingController largeItemDiscountedPriceController = TextEditingController();
  final TextEditingController largeItemTitleController = TextEditingController();
  /// pricing categories


  AddItemCubit(this.itemService, this.sharedPrf, this.pricingCategoryCubit) : super(AddItemInitial());

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    foodTypeController.dispose();
    actualPriceController.dispose();
    discountedPriceController.dispose();
    customFoodTypeController.dispose();
    smallItemTitleController.dispose();
    smallItemActualPriceController.dispose();
    smallItemDiscountedPriceController.dispose();
    mediumItemTitleController.dispose();
    mediumItemActualPriceController.dispose();
    mediumItemDiscountedPriceController.dispose();
    largeItemTitleController.dispose();
    largeItemActualPriceController.dispose();
    largeItemDiscountedPriceController.dispose();
    return super.close();
  }

  void clear() {
    titleController.clear();
    descriptionController.clear();
    foodTypeController.clear();
    actualPriceController.clear();
    discountedPriceController.clear();
    customFoodTypeController.clear();
    smallItemTitleController.clear();
    smallItemActualPriceController.clear();
    smallItemDiscountedPriceController.clear();
    mediumItemTitleController.clear();
    mediumItemActualPriceController.clear();
    mediumItemDiscountedPriceController.clear();
    largeItemTitleController.clear();
    largeItemActualPriceController.clear();
    largeItemDiscountedPriceController.clear();
  }

  Future<void> addItem(String image) async {
    emit(AddItemLoading());

    final item = Item(
      uid: sharedPrf.getStringAsync(SharePreferencesKey.USER_ID),
      title: titleController.text,
      description: descriptionController.text,
      foodType: foodTypeController.text,
      actualPrice: pricingCategoryCubit.state.categoryType == PricingCategoryType.none ? num.parse(actualPriceController.text) : defaultPrice,
      discountedPrice: pricingCategoryCubit.state.categoryType == PricingCategoryType.none
          ? parseNumeric(discountedPriceController.text)
          : defaultPrice,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      smallItemTitle: smallItemTitleController.text,
      mediumItemTitle: mediumItemTitleController.text,
      largeItemTitle: largeItemTitleController.text,
      searchParam: setSearchParam(titleController.text),
      smallItemActualPrice: parseNumeric(smallItemActualPriceController.text),
      mediumItemActualPrice: parseNumeric(mediumItemActualPriceController.text),
      largeItemActualPrice: parseNumeric(largeItemActualPriceController.text),
      smallItemDiscountedPrice: parseNumeric(smallItemDiscountedPriceController.text),
      mediumItemDiscountedPrice: parseNumeric(mediumItemDiscountedPriceController.text),
      largeItemDiscountedPrice: parseNumeric(largeItemDiscountedPriceController.text),
    );

    final result = await itemService.addItem(item, image);
    result.fold(
            (l) => emit(AddItemFailure(l)),
            (r) => emit(AddItemSuccess(r!)),
    );
  }

  Future<void> updateItem({required bool isUpdated,required String image}) async {
    emit(AddItemLoading());

    final item = Item(
        id: id ?? '',
        uid: sharedPrf.getStringAsync(SharePreferencesKey.USER_ID),
        title: titleController.text,
        description: descriptionController.text,
        foodType: foodTypeController.text,
        actualPrice: pricingCategoryCubit.state.categoryType == PricingCategoryType.none ? num.parse(actualPriceController.text) : defaultPrice,
        discountedPrice: pricingCategoryCubit.state.categoryType == PricingCategoryType.none
          ? parseNumeric(discountedPriceController.text)
          : defaultPrice,
        createdAt: createdAt ?? Timestamp.now(),
        updatedAt: Timestamp.now(),
        smallItemTitle: smallItemTitleController.text,
        mediumItemTitle: mediumItemTitleController.text,
        largeItemTitle: largeItemTitleController.text,
        searchParam: setSearchParam(titleController.text),
        smallItemActualPrice: parseNumeric(smallItemActualPriceController.text),
        mediumItemActualPrice: parseNumeric(mediumItemActualPriceController.text),
        largeItemActualPrice: parseNumeric(largeItemActualPriceController.text),
        smallItemDiscountedPrice: parseNumeric(smallItemDiscountedPriceController.text),
        mediumItemDiscountedPrice: parseNumeric(mediumItemDiscountedPriceController.text),
        largeItemDiscountedPrice: parseNumeric(largeItemDiscountedPriceController.text),
    );

    final result = await itemService.updateItem(item, image: image, isUpdated: isUpdated);
    result.fold(
          (l) => emit(AddItemFailure(l)),
          (r) => emit(AddItemSuccess(r!)),
    );
  }

  num parseNumeric(String value) {
    return value.isEmptyOrNull ? defaultPrice : num.parse(value);
  }
}