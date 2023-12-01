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
  final num? actualPrice;
  final num? discountedPrice;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final List<dynamic>? itemNames;
  final List<dynamic>? searchParam;



  Deal({
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
    this.itemNames,
    this.searchParam
  });

  Deal copyWith({
    String? uid,
    String? id,
    String? image,
    String? title,
    String? description,
    String? foodType,
    num? actualPrice,
    num? discountedPrice,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    List<dynamic>? itemNames,
    List<dynamic>? searchParam,
  }){
    return Deal(
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
        itemNames: itemNames ?? this.itemNames,
      searchParam: searchParam ?? this.searchParam,
    );
  }

  factory Deal.fromJson(Map<String, dynamic> json, String id) {
    return Deal(
      id: id,
      uid: json[DealKey.uid],
      image: json[DealKey.image],
      title: json[DealKey.title],
      description: json[DealKey.description],
      foodType: json[DealKey.foodType],
      searchParam: json[DealKey.searchParam],
      createdAt: json[DealKey.createdAt],
      updatedAt: json[DealKey.updatedAt],
      actualPrice: json[DealKey.actualPrice],
      discountedPrice: json[DealKey.discountedPrice],
      itemNames: json[DealKey.itemNames],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[DealKey.id] = id;
    data[DealKey.uid] = uid;
    data[DealKey.image] = image;
    data[DealKey.title] = title;
    data[DealKey.description] = description;
    data[DealKey.searchParam] = searchParam;
    data[DealKey.foodType] = foodType;
    data[DealKey.createdAt] = createdAt;
    data[DealKey.updatedAt] = updatedAt;
    data[DealKey.actualPrice] = actualPrice;
    data[DealKey.discountedPrice] = discountedPrice;
    data[DealKey.itemNames] = itemNames;
    return data;
  }

  @override
  List<Object?> get props => [
    id, uid, image,
    title, description,
    foodType, createdAt,
    updatedAt, actualPrice,
    discountedPrice,
    itemNames
  ];

}