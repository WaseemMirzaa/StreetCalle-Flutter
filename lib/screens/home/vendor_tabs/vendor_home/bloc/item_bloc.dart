import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/utils/constant/constants.dart';

part 'item_state.dart';
part 'item_event.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc(this.itemService, this.sharedPref) : super(ItemInitial()) {
    on<LoadItems>((event, emit) async {
      try {
        emit(ItemLoading());
        final todos = await itemService.getItems(sharedPref.getStringAsync(SharePreferencesKey.USER_ID)).first;
        emit(ItemLoadSuccess(todos));
      } catch (e) {
        emit(ItemLoadFailure('Failed to load todos.'));
      }
    });
  }

  final ItemService itemService;
  final SharedPreferencesService sharedPref;

  // @override
  // Stream<ItemState> mapEventToState(ItemEvent event) async* {
  //   if (event is LoadItems) {
  //     yield* _mapLoadItemsToState();
  //   }
  // }

  // Stream<ItemState> getItems() async* {
  //   try {
  //     final itemListStream = itemService.getItems(sharedPref.getStringAsync(SharePreferencesKey.USER_ID));
  //     yield ItemLoadSuccess(itemListStream);
  //   } catch (e) {
  //     yield ItemLoadFailure(e.toString());
  //   }
  // }
}