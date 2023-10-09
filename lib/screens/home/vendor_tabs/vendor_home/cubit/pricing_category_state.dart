part of 'pricing_category_cubit.dart';

enum PricingCategoryType { none, smallMedium, large }

class PricingCategoryState extends Equatable {
  final PricingCategoryType categoryType;

  PricingCategoryState({required this.categoryType});

  PricingCategoryState copyWith({PricingCategoryType? categoryType}) {
    return PricingCategoryState(
        categoryType: categoryType ?? this.categoryType
    );
  }

  @override
  List<Object?> get props => [categoryType];
}