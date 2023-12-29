import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:street_calle/utils/constant/constants.dart';

@immutable
class Item extends Equatable {
  final String? uid;
  final String? id;
  final String? image;
  final String? title;
  final String? description;
  final String? foodType;
  final String? category;
  final num? actualPrice;
  final num? discountedPrice;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  final List<dynamic>? searchParam;

  final String? smallItemTitle;
  final String? mediumItemTitle;
  final String? largeItemTitle;

  final num? smallItemActualPrice;
  final num? smallItemDiscountedPrice;

  final num? mediumItemActualPrice;
  final num? mediumItemDiscountedPrice;

  final num? largeItemActualPrice;
  final num? largeItemDiscountedPrice;


  Item({
   this.uid,
   this.id,
   this.image,
   this.title,
   this.description,
   this.foodType,
   this.category,
   this.actualPrice,
   this.discountedPrice,
   this.updatedAt,
   this.createdAt,
    this.searchParam,
    this.smallItemTitle,
    this.mediumItemTitle,
    this.largeItemTitle,
    this.smallItemActualPrice,
    this.smallItemDiscountedPrice,
    this.mediumItemActualPrice,
    this.mediumItemDiscountedPrice,
    this.largeItemActualPrice,
    this.largeItemDiscountedPrice
  });

  Item copyWith({
   String? uid,
   String? id,
   String? image,
   String? title,
   String? description,
   String? foodType,
   String? category,
   num? actualPrice,
   num? discountedPrice,
   List<dynamic>? searchParam,
   Timestamp? createdAt,
   Timestamp? updatedAt,
   String? smallItemTitle,
   String? mediumItemTitle,
   String? largeItemTitle,
    num? smallItemActualPrice,
    num? smallItemDiscountedPrice,
    num? mediumItemActualPrice,
    num? mediumItemDiscountedPrice,
    num? largeItemActualPrice,
    num? largeItemDiscountedPrice,
  }){
    return Item(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      description: description ?? this.description,
      foodType: foodType ?? this.foodType,
      category: category ?? this.category,
      actualPrice: actualPrice ?? this.actualPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      searchParam: searchParam ?? this.searchParam,
      smallItemTitle: smallItemTitle ?? this.smallItemTitle,
      mediumItemTitle: mediumItemTitle ?? this.mediumItemTitle,
      largeItemTitle: largeItemTitle ?? this.largeItemTitle,
      smallItemActualPrice: smallItemActualPrice ?? this.smallItemActualPrice,
      mediumItemActualPrice: mediumItemActualPrice ?? this.mediumItemActualPrice,
      largeItemActualPrice: largeItemActualPrice ?? this.largeItemActualPrice,
      smallItemDiscountedPrice: smallItemDiscountedPrice ?? this.smallItemDiscountedPrice,
      mediumItemDiscountedPrice: mediumItemDiscountedPrice ?? this.mediumItemDiscountedPrice,
      largeItemDiscountedPrice: largeItemDiscountedPrice ?? this.largeItemDiscountedPrice
    );
  }

  factory Item.fromJson(Map<String, dynamic> json, String id) {
    return Item(
      id: id,
      uid: json[ItemKey.UID],
      image: json[ItemKey.IMAGE],
      title: json[ItemKey.TITLE],
      description: json[ItemKey.DESCRIPTION],
      foodType: json[ItemKey.FOOD_TYPE],
      category: json[ItemKey.CATEGORY],
      searchParam: json[ItemKey.SEARCH_PARAM],
      createdAt: json[ItemKey.CREATED_AT],
      updatedAt: json[ItemKey.UPDATED_AT],
      actualPrice: json[ItemKey.ACTUAL_PRICE],
      discountedPrice: json[ItemKey.DISCOUNTED_PRICE],
      smallItemTitle: json[ItemKey.SMALL_ITEM_TITLE],
      mediumItemTitle: json[ItemKey.MEDIUM_ITEM_TITLE],
      largeItemTitle: json[ItemKey.LARGE_ITEM_TITLE],
      smallItemActualPrice: json[ItemKey.SMALL_ITEM_ACTUAL_PRICE],
      mediumItemActualPrice: json[ItemKey.MEDIUM_ITEM_ACTUAL_PRICE],
      largeItemActualPrice: json[ItemKey.LARGE_ITEM_ACTUAL_PRICE],
      smallItemDiscountedPrice: json[ItemKey.SMALL_ITEM_DISCOUNTED_PRICE],
      mediumItemDiscountedPrice: json[ItemKey.MEDIUM_ITEM_DISCOUNTED_PRICE],
      largeItemDiscountedPrice: json[ItemKey.LARGE_ITEM_DISCOUNTED_PRICE],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[ItemKey.ID] = id;
    data[ItemKey.UID] = uid;
    data[ItemKey.IMAGE] = image;
    data[ItemKey.TITLE] = title;
    data[ItemKey.DESCRIPTION] = description;
    data[ItemKey.FOOD_TYPE] = foodType;
    data[ItemKey.CATEGORY] = category;
    data[ItemKey.CREATED_AT] = createdAt;
    data[ItemKey.UPDATED_AT] = updatedAt;
    data[ItemKey.ACTUAL_PRICE] = actualPrice;
    data[ItemKey.SEARCH_PARAM] = searchParam;
    data[ItemKey.DISCOUNTED_PRICE] = discountedPrice;
    data[ItemKey.SMALL_ITEM_TITLE] = smallItemTitle;
    data[ItemKey.MEDIUM_ITEM_TITLE] = mediumItemTitle;
    data[ItemKey.LARGE_ITEM_TITLE] = largeItemTitle;
    data[ItemKey.SMALL_ITEM_ACTUAL_PRICE] = smallItemActualPrice;
    data[ItemKey.MEDIUM_ITEM_ACTUAL_PRICE] = mediumItemActualPrice;
    data[ItemKey.LARGE_ITEM_ACTUAL_PRICE] = largeItemActualPrice;
    data[ItemKey.SMALL_ITEM_DISCOUNTED_PRICE] = smallItemDiscountedPrice;
    data[ItemKey.MEDIUM_ITEM_DISCOUNTED_PRICE] = mediumItemDiscountedPrice;
    data[ItemKey.LARGE_ITEM_DISCOUNTED_PRICE] = largeItemDiscountedPrice;
    return data;
  }

  @override
  List<Object?> get props => [
    id, uid, image,
    title, description,
    foodType, createdAt, category,
    updatedAt, actualPrice,
    discountedPrice, smallItemTitle,
    mediumItemTitle, largeItemTitle,
    smallItemActualPrice, mediumItemActualPrice,
    largeItemActualPrice, smallItemDiscountedPrice,
    mediumItemDiscountedPrice, largeItemDiscountedPrice];

}