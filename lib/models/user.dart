import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:street_calle/utils/constant/constants.dart';

@immutable
class User extends Equatable {
  final String? uid;
  final String? vendorId;
  final String? image;
  final String? name;
  final String? email;
  final String? phone;
  final String? countryCode;
  final bool? isVendor;
  final bool? isOnline;
  final bool? isEmployee;
  final bool? isEmployeeBlocked;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final List<dynamic>? fcmTokens;
  final List<dynamic>? employeeItemsList;
  final List<dynamic>? favouriteVendors;
  final double? latitude;
  final double? longitude;
  final String? vendorType;

  User(
      {this.uid,
      this.vendorId,
      this.image,
      this.name,
      this.email,
      this.phone,
      this.createdAt,
      this.updatedAt,
      this.fcmTokens,
      this.employeeItemsList,
      this.isVendor,
      this.isOnline,
      this.isEmployee,
      this.isEmployeeBlocked,
      this.latitude,
      this.longitude,
      this.countryCode,
      this.vendorType,
      this.favouriteVendors});

  User copyWith(
      {String? uid,
      String? vendorId,
      String? image,
      String? name,
      String? email,
      String? phone,
      Timestamp? createdAt,
      Timestamp? updatedAt,
      List<dynamic>? fcmTokens,
      List<dynamic>? employeeItemsList,
      List<dynamic>? favouriteVendors,
      bool? isVendor,
      bool? isOnline,
      bool? isEmployee,
      bool? isEmployeeBlocked,
      double? latitude,
      double? longitude,
      String? countryCode,
      String? vendorType}) {
    return User(
      uid: uid ?? this.uid,
      vendorId: vendorId ?? this.vendorId,
      image: image ?? this.image,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      employeeItemsList: employeeItemsList ?? this.employeeItemsList,
      favouriteVendors: favouriteVendors ?? this.favouriteVendors,
      isVendor: isVendor ?? this.isVendor,
      isOnline: isOnline ?? this.isOnline,
      isEmployee: isEmployee ?? this.isEmployee,
      isEmployeeBlocked: isEmployeeBlocked ?? this.isEmployeeBlocked,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      countryCode: countryCode ?? this.countryCode,
      vendorType: vendorType ?? this.vendorType,
    );
  }

  factory User.fromJson(Map<String, dynamic> json, String userId) {
    return User(
      uid: userId,
      vendorId: json[UserKey.vendorId],
      image: json[UserKey.image],
      name: json[UserKey.name],
      email: json[UserKey.email],
      phone: json[UserKey.phone],
      createdAt: json[UserKey.createdAt],
      updatedAt: json[UserKey.updatedAt],
      fcmTokens: json[UserKey.fcmTokens],
      employeeItemsList: json[UserKey.employeeItemList],
      isVendor: json[UserKey.isVendor],
      isOnline: json[UserKey.isOnline],
      isEmployeeBlocked: json[UserKey.isEmployeeBlocked],
      isEmployee: json[UserKey.isEmployee],
      latitude: json[UserKey.latitude],
      longitude: json[UserKey.longitude],
      countryCode: json[UserKey.countryCode],
      vendorType: json[UserKey.vendorType],
      favouriteVendors: json[UserKey.favouriteVendors],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[UserKey.uid] = uid;
    data[UserKey.vendorId] = vendorId;
    data[UserKey.image] = image;
    data[UserKey.name] = name;
    data[UserKey.email] = email;
    data[UserKey.phone] = phone;
    data[UserKey.createdAt] = createdAt;
    data[UserKey.updatedAt] = updatedAt;
    data[UserKey.fcmTokens] = fcmTokens;
    data[UserKey.employeeItemList] = employeeItemsList;
    data[UserKey.isVendor] = isVendor;
    data[UserKey.isOnline] = isOnline;
    data[UserKey.isEmployee] = isEmployee;
    data[UserKey.isEmployeeBlocked] = isEmployeeBlocked;
    data[UserKey.latitude] = latitude;
    data[UserKey.longitude] = longitude;
    data[UserKey.countryCode] = countryCode;
    data[UserKey.vendorType] = vendorType;
    data[UserKey.favouriteVendors] = favouriteVendors;
    return data;
  }

  @override
  List<Object?> get props => [uid];
}
