import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:street_calle/utils/constant/constants.dart';

@immutable
class User extends Equatable {
  final String? uid;
  final String? image;
  final String? name;
  final String? email;
  final String? phone;
  final bool? isVendor;
  final bool? isOnline;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final List<dynamic>? fcmTokens;

  User({
    this.uid,
    this.image,
    this.name,
    this.email,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.fcmTokens,
    this.isVendor,
    this.isOnline
  });

  User copyWith({
    String? uid,
    String? image,
    String? name,
    String? email,
    String? phone,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    List<dynamic>? fcmTokens,
    bool? isVendor,
    bool? isOnline
  }){
    return User(
      uid: uid ?? this.uid,
      image: image ?? this.image,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      isVendor: isVendor ?? this.isVendor,
      isOnline: isOnline ?? this.isOnline,
    );
 }

  factory User.fromJson(Map<String, dynamic> json, String userId) {
    return User(
      uid: userId,
      image: json[UserKey.image],
      name: json[UserKey.name],
      email: json[UserKey.email],
      phone: json[UserKey.phone],
      createdAt: json[UserKey.createdAt],
      updatedAt: json[UserKey.updatedAt],
      fcmTokens: json[UserKey.fcmTokens],
      isVendor: json[UserKey.isVendor],
      isOnline: json[UserKey.isOnline],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[UserKey.uid] = uid;
    data[UserKey.image] = image;
    data[UserKey.name] = name;
    data[UserKey.email] = email;
    data[UserKey.phone] = phone;
    data[UserKey.createdAt] = createdAt;
    data[UserKey.updatedAt] = updatedAt;
    data[UserKey.fcmTokens] = fcmTokens;
    data[UserKey.isVendor] = isVendor;
    data[UserKey.isOnline] = isOnline;
    return data;
  }

  @override
  List<Object?> get props => [uid, image, name, email, phone, fcmTokens, createdAt, updatedAt, isVendor, isOnline];

}