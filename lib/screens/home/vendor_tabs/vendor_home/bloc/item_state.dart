part of 'item_bloc.dart';

// States
abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object?> get props => [];
}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoadSuccess extends ItemState {
  final List<Item> itemList;

  ItemLoadSuccess(this.itemList);

  @override
  List<Object?> get props => [itemList];
}

class ItemLoadFailure extends ItemState {
  final String error;

  ItemLoadFailure(this.error);

  @override
  List<Object?> get props => [error];
}