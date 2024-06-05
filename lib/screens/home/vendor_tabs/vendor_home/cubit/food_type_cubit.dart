import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class FoodTypeCubit extends Cubit<List<String>> {
  FoodTypeCubit() : super([LocaleKeys.select.tr(), '+ ${LocaleKeys.addFoodType.tr()}']);
  String defaultValue = LocaleKeys.select.tr();

  // Future<void> loadFromFirebase() async {
  //   try {
  //     final documentSnapshot = await sl.get<FirebaseFirestore>().collection(Collections.FOOD_TYPE).doc(Collections.FOOD_TYPE).get();
  //     if (documentSnapshot.exists && documentSnapshot.data() != null) {
  //       //List<String> foodTypesFromFirebase = List<String>.from(documentSnapshot.data()?['types']);
  //
  //       Map<String, dynamic> dataFromFirebase = documentSnapshot.data()?['translatedTypes'];
  //       // List<String> foodTypesFromFirebase = dataFromFirebase.values.map((foodTypeMap) {
  //       //   if (foodTypeMap.containsKey(LANGUAGE)) {
  //       //     return foodTypeMap[LANGUAGE].toString();
  //       //   } else {
  //       //     return ''; // or handle the case where the language code is not found
  //       //   }
  //       // }).where((foodType) => foodType.isNotEmpty).toList();
  //
  //       Set<String> foodTypesFromFirebaseSet = dataFromFirebase.values.map((foodTypeMap) {
  //         if (foodTypeMap.containsKey(LANGUAGE)) {
  //           return foodTypeMap[LANGUAGE].toString();
  //         } else {
  //           return ''; // or handle the case where the language code is not found
  //         }
  //       }).where((foodType) => foodType.isNotEmpty).toSet();
  //
  //       //final List<String> mergedList = state.toSet().union(foodTypesFromFirebase.toSet()).toList();
  //       List<String> foodTypesFromFirebase = foodTypesFromFirebaseSet.map((foodType) {
  //         if (foodType.isNotEmpty) {
  //           return foodType.capitalizeEachFirstLetter();
  //         } else {
  //           return foodType; // Return unchanged if it's an empty string
  //         }
  //       }).toList();
  //
  //       foodTypesFromFirebase.insert(0, LocaleKeys.select.tr());
  //       foodTypesFromFirebase.add('+ ${LocaleKeys.addFoodType.tr()}');
  //
  //       emit(foodTypesFromFirebase);
  //     }
  //   } catch (e) {
  //     print('Error loading data from Firebase: $e');
  //   }
  // }

  Future<void> loadFromFirebase() async {
    try {
      final documentSnapshot = await sl.get<FirebaseFirestore>().collection(Collections.FOOD_TYPE).doc(Collections.FOOD_TYPE).get();
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        List<String> foodTypesFromFirebase = List<String>.from(documentSnapshot.data()?['types']);
        //final List<String> mergedList = state.toSet().union(foodTypesFromFirebase.toSet()).toList();
        foodTypesFromFirebase = foodTypesFromFirebase.map((foodType) {
          if (foodType.isNotEmpty) {
            return foodType.capitalizeEachFirstLetter();
          } else {
            return foodType; // Return unchanged if it's an empty string
          }
        }).toList();

        foodTypesFromFirebase.insert(0, LocaleKeys.select.tr());
        foodTypesFromFirebase.add('+ ${LocaleKeys.addFoodType.tr()}');

        emit(foodTypesFromFirebase);
      }
    } catch (e) {
      print('Error loading data from Firebase: $e');
    }
  }

  void addString(String text) {
    final List<String> currentState = List.from(state);
    final Set<String> uniqueSet = Set.from(currentState);

    if (!uniqueSet.contains(text)) {
      uniqueSet.remove('+ ${LocaleKeys.addFoodType.tr()}'); // Remove the '+ ${TempLanguage().lblAddFoodType}' if it's present
      uniqueSet.add(text);
      uniqueSet.add('+ ${LocaleKeys.addFoodType.tr()}'); // Add it back at the end
      emit(List.from(uniqueSet));
    }
  }

  // void addString(String text) {
  //   final List<String> currentState = List.from(state);
  //   final Set<String> uniqueSet = Set.from(currentState.map((e) => e.toLowerCase()));
  //
  //   final String lowerCaseText = text.toLowerCase();
  //   final String addFoodTypeText = '+ ${LocaleKeys.addFoodType.tr()}';
  //   final String lowerCaseAddFoodTypeText = addFoodTypeText.toLowerCase();
  //
  //   if (!uniqueSet.contains(lowerCaseText)) {
  //     // Remove the '+ ${LocaleKeys.addFoodType.tr()}' if it's present
  //     currentState.removeWhere((e) => e.toLowerCase() == lowerCaseAddFoodTypeText);
  //     currentState.add(text);
  //   } else {
  //     // Replace the existing value with the new lower case value
  //     for (int i = 0; i < currentState.length; i++) {
  //       if (currentState[i].toLowerCase() == lowerCaseText) {
  //         currentState[i] = text;
  //         break;
  //       }
  //     }
  //   }
  //
  //   currentState.add(addFoodTypeText); // Add '+ ${LocaleKeys.addFoodType.tr()}' back at the end
  //   emit(List.from(currentState));
  // }

  // void addString(String text) {
  //   final List<String> currentState = List.from(state);
  //   final Set<String> uniqueSet = Set.from(currentState.map((e) => e.toLowerCase()));
  //
  //   final String lowerCaseText = text.toLowerCase();
  //   final String addFoodTypeText = '+ ${LocaleKeys.addFoodType.tr()}';
  //   final String lowerCaseAddFoodTypeText = addFoodTypeText.toLowerCase();
  //
  //   if (!uniqueSet.contains(lowerCaseText)) {
  //     currentState.removeWhere((e) => e.toLowerCase() == lowerCaseAddFoodTypeText); // Remove the '+ ${LocaleKeys.addFoodType.tr()}' if it's present
  //     currentState.add(text);
  //     currentState.add(addFoodTypeText); // Add it back at the end
  //
  //     emit(List.from(currentState));
  //   }
  // }


  Future<void> addToFirebase(String newFoodType) async {
    try {
      final CollectionReference foodTypeCollection = FirebaseFirestore.instance.collection(Collections.FOOD_TYPE);

      await foodTypeCollection.doc(Collections.FOOD_TYPE).update({
        'types': FieldValue.arrayUnion([newFoodType]),
      });

    } catch (e) {
      print('Error adding data to Firebase: $e');
    }
  }

}