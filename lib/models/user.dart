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
  final bool? isAdmin;
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
    this.isAdmin,
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
    bool? isAdmin,
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
      isAdmin: isAdmin ?? this.isAdmin,
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
      isAdmin: json[UserKey.isAdmin],
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
    data[UserKey.isAdmin] = isAdmin;
    return data;
  }

  @override
  List<Object?> get props => [uid, image, name, email, phone, fcmTokens];

}