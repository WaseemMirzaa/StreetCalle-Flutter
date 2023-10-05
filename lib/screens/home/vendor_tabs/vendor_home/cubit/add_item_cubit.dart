import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
part 'add_item_state.dart';

class AddItemCubit extends Cubit<AddItemState> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController foodTypeController = TextEditingController();
  final TextEditingController actualPriceController = TextEditingController();
  final TextEditingController discountedPriceController = TextEditingController();
  String? id;
  Timestamp? createdAt;
  final ItemService itemService;
  final SharedPreferencesService sharedPrf;

  AddItemCubit(this.itemService, this.sharedPrf) : super(AddItemInitial());

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    foodTypeController.dispose();
    actualPriceController.dispose();
    discountedPriceController.dispose();
    return super.close();
  }

  void clear() {
    titleController.text = '';
    descriptionController.text = '';
    foodTypeController.text = '';
    actualPriceController.text = '';
    discountedPriceController.text = '';
  }

  Future<void> addItem(String image) async {
    emit(AddItemLoading());

    final item = Item(
      uid: sharedPrf.getStringAsync(SharePreferencesKey.USER_ID),
      title: titleController.text,
      description: descriptionController.text,
      foodType: foodTypeController.text,
      actualPrice: num.parse(actualPriceController.text),
      discountedPrice: discountedPriceController.text.isEmpty ? 0.0 : num.parse(discountedPriceController.text),
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now()
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
        actualPrice: num.parse(actualPriceController.text),
        discountedPrice: discountedPriceController.text.isEmpty ? 0.0 : num.parse(discountedPriceController.text),
        createdAt: createdAt ?? Timestamp.now(),
        updatedAt: Timestamp.now()
    );

    final result = await itemService.updateItem(item, image: image, isUpdated: isUpdated);
    result.fold(
          (l) => emit(AddItemFailure(l)),
          (r) => emit(AddItemSuccess(r!)),
    );
  }
}