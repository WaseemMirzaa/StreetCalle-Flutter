part of 'add_item_cubit.dart';

abstract class AddItemState extends Equatable {}

class AddItemInitial extends AddItemState {
  @override
  List<Object?> get props => [];
}

class AddItemLoading extends AddItemState {
  @override
  List<Object?> get props => [];
}

class AddItemSuccess extends AddItemState {
  final Item item;

  AddItemSuccess(this.item);

  @override
  List<Object?> get props => [item];
}

class AddItemFailure extends AddItemState {
  final String error;

  AddItemFailure(this.error);

  @override
  List<Object?> get props => [error];
}