part of 'add_deal_cubit.dart';

abstract class AddDealState extends Equatable {}

class AddDealInitial extends AddDealState {
  @override
  List<Object?> get props => [];
}

class AddDealLoading extends AddDealState {
  @override
  List<Object?> get props => [];
}

class AddDealSuccess extends AddDealState {
  final Deal deal;

  AddDealSuccess(this.deal);

  @override
  List<Object?> get props => [deal];
}

class AddDealFailure extends AddDealState {
  final String error;

  AddDealFailure(this.error);

  @override
  List<Object?> get props => [error];
}