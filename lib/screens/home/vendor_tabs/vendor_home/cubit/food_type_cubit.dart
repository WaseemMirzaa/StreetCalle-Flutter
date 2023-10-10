import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';

class FoodTypeCubit extends Cubit<List<String>> {
  FoodTypeCubit() : super([TempLanguage().lblSelect, '+ ${TempLanguage().lblAddFoodType}']);
  String defaultValue = TempLanguage().lblSelect;

  Future<void> loadFromFirebase() async {
    try {
      final documentSnapshot = await sl.get<FirebaseFirestore>().collection(Collections.foodType).doc(Collections.foodType).get();
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        final List<String> foodTypesFromFirebase = List<String>.from(documentSnapshot.data()?['types']);
        //final List<String> mergedList = state.toSet().union(foodTypesFromFirebase.toSet()).toList();

        foodTypesFromFirebase.insert(0, TempLanguage().lblSelect);
        foodTypesFromFirebase.add('+ ${TempLanguage().lblAddFoodType}');

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
      uniqueSet.remove('+ ${TempLanguage().lblAddFoodType}'); // Remove the '+ ${TempLanguage().lblAddFoodType}' if it's present
      uniqueSet.add(text);
      uniqueSet.add('+ ${TempLanguage().lblAddFoodType}'); // Add it back at the end
      emit(List.from(uniqueSet));
    }
  }

  Future<void> addToFirebase(String newFoodType) async {
    try {
      final CollectionReference foodTypeCollection = FirebaseFirestore.instance.collection(Collections.foodType);

      await foodTypeCollection.doc(Collections.foodType).update({
        'types': FieldValue.arrayUnion([newFoodType]),
      });

    } catch (e) {
      print('Error adding data to Firebase: $e');
    }
  }

}