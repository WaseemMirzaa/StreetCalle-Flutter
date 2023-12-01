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
      uid: json[ItemKey.uid],
      image: json[ItemKey.image],
      title: json[ItemKey.title],
      description: json[ItemKey.description],
      foodType: json[ItemKey.foodType],
      searchParam: json[ItemKey.searchParam],
      createdAt: json[ItemKey.createdAt],
      updatedAt: json[ItemKey.updatedAt],
      actualPrice: json[ItemKey.actualPrice],
      discountedPrice: json[ItemKey.discountedPrice],
      smallItemTitle: json[ItemKey.smallItemTitle],
      mediumItemTitle: json[ItemKey.mediumItemTitle],
      largeItemTitle: json[ItemKey.largeItemTitle],
      smallItemActualPrice: json[ItemKey.smallItemActualPrice],
      mediumItemActualPrice: json[ItemKey.mediumItemActualPrice],
      largeItemActualPrice: json[ItemKey.largeItemActualPrice],
      smallItemDiscountedPrice: json[ItemKey.smallItemDiscountedPrice],
      mediumItemDiscountedPrice: json[ItemKey.mediumItemDiscountedPrice],
      largeItemDiscountedPrice: json[ItemKey.largeItemDiscountedPrice],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[ItemKey.id] = id;
    data[ItemKey.uid] = uid;
    data[ItemKey.image] = image;
    data[ItemKey.title] = title;
    data[ItemKey.description] = description;
    data[ItemKey.foodType] = foodType;
    data[ItemKey.createdAt] = createdAt;
    data[ItemKey.updatedAt] = updatedAt;
    data[ItemKey.actualPrice] = actualPrice;
    data[ItemKey.searchParam] = searchParam;
    data[ItemKey.discountedPrice] = discountedPrice;
    data[ItemKey.smallItemTitle] = smallItemTitle;
    data[ItemKey.mediumItemTitle] = mediumItemTitle;
    data[ItemKey.largeItemTitle] = largeItemTitle;
    data[ItemKey.smallItemActualPrice] = smallItemActualPrice;
    data[ItemKey.mediumItemActualPrice] = mediumItemActualPrice;
    data[ItemKey.largeItemActualPrice] = largeItemActualPrice;
    data[ItemKey.smallItemDiscountedPrice] = smallItemDiscountedPrice;
    data[ItemKey.mediumItemDiscountedPrice] = mediumItemDiscountedPrice;
    data[ItemKey.largeItemDiscountedPrice] = largeItemDiscountedPrice;
    return data;
  }

  @override
  List<Object?> get props => [
    id, uid, image,
    title, description,
    foodType, createdAt,
    updatedAt, actualPrice,
    discountedPrice, smallItemTitle,
    mediumItemTitle, largeItemTitle,
    smallItemActualPrice, mediumItemActualPrice,
    largeItemActualPrice, smallItemDiscountedPrice,
    mediumItemDiscountedPrice, largeItemDiscountedPrice];

}