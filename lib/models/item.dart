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
   this.createdAt
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
   Timestamp? createdAt,
   Timestamp? updatedAt
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
      updatedAt: updatedAt ?? this.updatedAt
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
      createdAt: json[ItemKey.createdAt],
      updatedAt: json[ItemKey.updatedAt],
      actualPrice: json[ItemKey.actualPrice],
      discountedPrice: json[ItemKey.discountedPrice],
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
    data[ItemKey.discountedPrice] = discountedPrice;
    return data;
  }

  @override
  List<Object?> get props => [id, uid, image, title, description, foodType, createdAt, updatedAt, actualPrice, discountedPrice];

}