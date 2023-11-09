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
  final String? about;
  final bool isVendor;
  final bool isOnline;
  final bool isEmployee;
  final bool isEmployeeBlocked;
  final bool isSubscribed;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final List<dynamic>? fcmTokens;
  final List<dynamic>? employeeItemsList;
  final List<dynamic>? employeeDealsList;
  final List<dynamic>? favouriteVendors;
  final double? latitude;
  final double? longitude;
  final String? vendorType;
  final String? userType;
  final String? employeeOwnerImage;
  final String? employeeOwnerName;
  final String? subscriptionType;

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
      this.about,
      this.employeeItemsList,
      this.employeeDealsList,
      this.isVendor = false,
      this.isOnline = true,
      this.isEmployee = false,
      this.isEmployeeBlocked = false,
      this.isSubscribed = false,
      this.latitude,
      this.longitude,
      this.countryCode,
      this.vendorType,
      this.userType,
      this.favouriteVendors,
      this.employeeOwnerImage,
      this.employeeOwnerName,
      this.subscriptionType});

  User copyWith(
      {String? uid,
      String? vendorId,
      String? image,
      String? name,
      String? email,
      String? phone,
      String? about,
      Timestamp? createdAt,
      Timestamp? updatedAt,
      List<dynamic>? fcmTokens,
      List<dynamic>? employeeItemsList,
      List<dynamic>? employeeDealsList,
      List<dynamic>? favouriteVendors,
      bool? isVendor,
      bool? isOnline,
      bool? isEmployee,
      bool? isEmployeeBlocked,
      bool? isSubscribed,
      double? latitude,
      double? longitude,
      String? countryCode,
      String? vendorType,
      String? userType,
      String? employeeOwnerImage,
      String? employeeOwnerName,
      String? subscriptionType}) {
    return User(
      uid: uid ?? this.uid,
      vendorId: vendorId ?? this.vendorId,
      image: image ?? this.image,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      about: about ?? this.about,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      employeeItemsList: employeeItemsList ?? this.employeeItemsList,
      employeeDealsList: employeeDealsList ?? this.employeeDealsList,
      favouriteVendors: favouriteVendors ?? this.favouriteVendors,
      isVendor: isVendor ?? this.isVendor,
      isOnline: isOnline ?? this.isOnline,
      isEmployee: isEmployee ?? this.isEmployee,
      isEmployeeBlocked: isEmployeeBlocked ?? this.isEmployeeBlocked,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      countryCode: countryCode ?? this.countryCode,
      vendorType: vendorType ?? this.vendorType,
      userType: userType ?? this.userType,
      employeeOwnerImage: employeeOwnerImage ?? this.employeeOwnerImage,
      employeeOwnerName: employeeOwnerName ?? this.employeeOwnerName,
      subscriptionType: subscriptionType ?? this.subscriptionType
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
      about: json[UserKey.about],
      createdAt: json[UserKey.createdAt],
      updatedAt: json[UserKey.updatedAt],
      fcmTokens: json[UserKey.fcmTokens],
      employeeItemsList: json[UserKey.employeeItemList],
      employeeDealsList: json[UserKey.employeeDealList],
      isVendor: json[UserKey.isVendor],
      isOnline: json[UserKey.isOnline],
      isEmployeeBlocked: json[UserKey.isEmployeeBlocked],
      isEmployee: json[UserKey.isEmployee],
      isSubscribed: json[UserKey.isSubscribed],
      latitude: json[UserKey.latitude],
      longitude: json[UserKey.longitude],
      countryCode: json[UserKey.countryCode],
      vendorType: json[UserKey.vendorType],
      userType: json[UserKey.userType],
      favouriteVendors: json[UserKey.favouriteVendors],
      employeeOwnerName: json[UserKey.employeeOwnerName],
      employeeOwnerImage: json[UserKey.employeeOwnerImage],
      subscriptionType: json[UserKey.subscriptionType]
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
    data[UserKey.about] = about;
    data[UserKey.createdAt] = createdAt;
    data[UserKey.updatedAt] = updatedAt;
    data[UserKey.fcmTokens] = fcmTokens;
    data[UserKey.employeeItemList] = employeeItemsList;
    data[UserKey.employeeDealList] =employeeDealsList;
    data[UserKey.isVendor] = isVendor;
    data[UserKey.isOnline] = isOnline;
    data[UserKey.isEmployee] = isEmployee;
    data[UserKey.isSubscribed] = isSubscribed;
    data[UserKey.isEmployeeBlocked] = isEmployeeBlocked;
    data[UserKey.latitude] = latitude;
    data[UserKey.longitude] = longitude;
    data[UserKey.countryCode] = countryCode;
    data[UserKey.vendorType] = vendorType;
    data[UserKey.userType] = userType;
    data[UserKey.favouriteVendors] = favouriteVendors;
    data[UserKey.employeeOwnerImage] = employeeOwnerImage;
    data[UserKey.employeeOwnerName] = employeeOwnerName;
    data[UserKey.subscriptionType] = subscriptionType;
    return data;
  }

  @override
  List<Object?> get props => [uid];
}
