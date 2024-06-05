import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:street_calle/utils/constant/constants.dart';

@immutable
class Deal extends Equatable {
  final String? uid;
  final String? id;
  final String? image;
  final String? title;
  final String? description;
  final String? foodType;
  final String? category;
  final String? translatedCategory;
  final num? actualPrice;
  final num? discountedPrice;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final List<dynamic>? itemNames;
  final List<dynamic>? searchParam;
  final Map<String, dynamic>? translatedDes;
  final Map<String, dynamic>? translatedTitle;
  //final Map<String, dynamic>? translatedFoodType;



  Deal({
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
    this.itemNames,
    this.searchParam,
    this.translatedDes,
    this.translatedTitle,
    this.translatedCategory,
    //this.translatedFoodType
  });

  Deal copyWith({
    String? uid,
    String? id,
    String? image,
    String? title,
    String? description,
    String? foodType,
    //Map<String, dynamic>? translatedFoodType,
    String? category,
    String? translatedCategory,
    num? actualPrice,
    num? discountedPrice,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    List<dynamic>? itemNames,
    List<dynamic>? searchParam,
    Map<String, dynamic>? translatedDes,
    Map<String, dynamic>? translatedTitle
  }){
    return Deal(
        uid: uid ?? this.uid,
        id: id ?? this.id,
        image: image ?? this.image,
        title: title ?? this.title,
        description: description ?? this.description,
        foodType: foodType ?? this.foodType,
        category: category ?? this.category,
        translatedCategory: translatedCategory ?? this.translatedCategory,
        actualPrice: actualPrice ?? this.actualPrice,
        discountedPrice: discountedPrice ?? this.discountedPrice,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        itemNames: itemNames ?? this.itemNames,
      searchParam: searchParam ?? this.searchParam,
      translatedDes: translatedDes ?? this.translatedDes,
      translatedTitle: translatedTitle ?? this.translatedTitle,
      //translatedFoodType: translatedFoodType ?? this.translatedFoodType
    );
  }

  factory Deal.fromJson(Map<String, dynamic> json, String id) {
    return Deal(
      id: id,
      uid: json[DealKey.UID],
      image: json[DealKey.IMAGE],
      title: json[DealKey.TITLE],
      description: json[DealKey.DESCRIPTION],
      foodType: json[DealKey.FOOD_TYPE],
     // translatedFoodType: json[DealKey.TRANSLATED_FOOD_TYPE],
      category: json[DealKey.CATEGORY],
      translatedCategory: json[DealKey.TRANSLATED_CATEGORY],
      searchParam: json[DealKey.SEARCH_PARAM],
      createdAt: json[DealKey.CREATED_AT],
      updatedAt: json[DealKey.UPDATED_AT],
      actualPrice: json[DealKey.ACTUAL_PRICE],
      discountedPrice: json[DealKey.DISCOUNTED_PRICE],
      itemNames: json[DealKey.ITEM_NAME],
      translatedDes: json['translatedDes'],
      translatedTitle: json['translatedTitle']
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[DealKey.ID] = id;
    data[DealKey.UID] = uid;
    data[DealKey.IMAGE] = image;
    data[DealKey.TITLE] = title;
    data[DealKey.DESCRIPTION] = description;
    data[DealKey.SEARCH_PARAM] = searchParam;
    data[DealKey.FOOD_TYPE] = foodType;
   // data[DealKey.TRANSLATED_FOOD_TYPE] = translatedFoodType;
    data[DealKey.CATEGORY] = category;
    data[DealKey.TRANSLATED_CATEGORY] = translatedCategory;
    data[DealKey.CREATED_AT] = createdAt;
    data[DealKey.UPDATED_AT] = updatedAt;
    data[DealKey.ACTUAL_PRICE] = actualPrice;
    data[DealKey.DISCOUNTED_PRICE] = discountedPrice;
    data[DealKey.ITEM_NAME] = itemNames;
    return data;
  }

  @override
  List<Object?> get props => [
    id, uid, image,
    title, description,
    foodType, createdAt,
    category,
    updatedAt, actualPrice,
    discountedPrice,
    itemNames
  ];

}