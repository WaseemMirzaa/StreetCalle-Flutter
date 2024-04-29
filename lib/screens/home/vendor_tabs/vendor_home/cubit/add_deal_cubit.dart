import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/services/deal_service.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/common.dart';

part 'add_deal_state.dart';

class AddDealCubit extends Cubit<AddDealState> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final foodTypeController = TextEditingController();
  final customFoodTypeController = TextEditingController();
  final customTitleController = TextEditingController();
  final actualPriceController = TextEditingController();
  final discountedPriceController = TextEditingController();
  String? id;
  Timestamp? createdAt;
  DealService dealService;
  final SharedPreferencesService sharedPrf;

  AddDealCubit(this.sharedPrf, this.dealService) : super(AddDealInitial());

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    foodTypeController.dispose();
    customFoodTypeController.dispose();
    actualPriceController.dispose();
    discountedPriceController.dispose();
    return super.close();
  }

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
    foodTypeController.clear();
    customFoodTypeController.clear();
    actualPriceController.clear();
    discountedPriceController.clear();
  }

  Future<void> addDeal(String image, String category) async {
    emit(AddDealLoading());

    final deal = Deal(
      uid: sharedPrf.getStringAsync(SharePreferencesKey.USER_ID),
      title: titleController.text,
      description: descriptionController.text,
      foodType: foodTypeController.text,
      category: category,
      searchParam: setSearchParam(titleController.text.toLowerCase()),
      actualPrice: parseNumeric(actualPriceController.text),
      discountedPrice: parseNumeric(discountedPriceController.text),
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );

    final result = await dealService.addDeal(deal, image);
    result.fold(
          (l) => emit(AddDealFailure(l)),
          (r) => emit(AddDealSuccess(r!)),
    );
  }

  Future<void> updateDeal({required bool isUpdated,required String image, required String category}) async {
    emit(AddDealLoading());

    final deal = Deal(
      id: id ?? '',
      uid: sharedPrf.getStringAsync(SharePreferencesKey.USER_ID),
      title: titleController.text,
      description: descriptionController.text,
      foodType: foodTypeController.text,
      category: category,
      searchParam: setSearchParam(titleController.text.toLowerCase()),
      actualPrice: parseNumeric(actualPriceController.text),
      discountedPrice: parseNumeric(discountedPriceController.text),
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );

    final result = await dealService.updateDeal(deal, image: image, isUpdated: isUpdated);
    result.fold(
          (l) => emit(AddDealFailure(l)),
          (r) => emit(AddDealSuccess(r!)),
    );
  }


  num parseNumeric(String value) {
    return value.isEmptyOrNull ? defaultPrice : num.parse(value);
  }
}