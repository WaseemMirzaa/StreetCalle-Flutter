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
  final String? clientVendorDistance;
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
  final String? category;
  final String? categoryImage;
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
      this.clientVendorDistance,
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
      this.subscriptionType,
      this.category,
      this.categoryImage,
      });

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
      String? category,
      String? categoryImage,
      String? clientVendorDistance,
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
      category: category ?? this.category,
      categoryImage: categoryImage ?? this.categoryImage,
      employeeOwnerImage: employeeOwnerImage ?? this.employeeOwnerImage,
      employeeOwnerName: employeeOwnerName ?? this.employeeOwnerName,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      clientVendorDistance: clientVendorDistance ?? this.clientVendorDistance,
    );
  }

  factory User.fromJson(Map<String, dynamic> json, String userId) {
    return User(
      uid: userId,
      vendorId: json[UserKey.VENDOR_ID],
      image: json[UserKey.IMAGE],
      name: json[UserKey.NAME],
      email: json[UserKey.EMAIL],
      phone: json[UserKey.PHONE],
      about: json[UserKey.ABOUT],
      createdAt: json[UserKey.CREATED_AT],
      updatedAt: json[UserKey.UPDATED_AT],
      fcmTokens: json[UserKey.FCM_TOKENS],
      employeeItemsList: json[UserKey.EMPLOYEE_ITEM_LIST],
      employeeDealsList: json[UserKey.EMPLOYEE_DEAL_LIST],
      isVendor: json[UserKey.IS_VENDOR],
      isOnline: json[UserKey.IS_ONLINE],
      isEmployeeBlocked: json[UserKey.IS_EMPLOYEE_BLOCKED],
      isEmployee: json[UserKey.IS_EMPLOYEE],
      isSubscribed: json[UserKey.IS_SUBSCRIBED],
      latitude: json[UserKey.LATITUDE],
      longitude: json[UserKey.LONGITUDE],
      countryCode: json[UserKey.COUNTRY_CODE],
      vendorType: json[UserKey.VENDOR_TYPE],
      userType: json[UserKey.USER_TYPE],
      category: json[UserKey.CATEGORY],
      categoryImage: json[UserKey.CATEGORY_IMAGE],
      favouriteVendors: json[UserKey.FAVOURITE_VENDORS],
      employeeOwnerName: json[UserKey.EMPLOYEE_OWNER_NAME],
      employeeOwnerImage: json[UserKey.EMPLOYEE_OWNER_IMAGE],
      subscriptionType: json[UserKey.SUBSCRIPTION_TYPE]
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[UserKey.UID] = uid;
    data[UserKey.VENDOR_ID] = vendorId;
    data[UserKey.IMAGE] = image;
    data[UserKey.NAME] = name;
    data[UserKey.EMAIL] = email;
    data[UserKey.PHONE] = phone;
    data[UserKey.ABOUT] = about;
    data[UserKey.CREATED_AT] = createdAt;
    data[UserKey.UPDATED_AT] = updatedAt;
    data[UserKey.FCM_TOKENS] = fcmTokens;
    data[UserKey.EMPLOYEE_ITEM_LIST] = employeeItemsList;
    data[UserKey.EMPLOYEE_DEAL_LIST] =employeeDealsList;
    data[UserKey.IS_VENDOR] = isVendor;
    data[UserKey.IS_ONLINE] = isOnline;
    data[UserKey.IS_EMPLOYEE] = isEmployee;
    data[UserKey.IS_SUBSCRIBED] = isSubscribed;
    data[UserKey.IS_EMPLOYEE_BLOCKED] = isEmployeeBlocked;
    data[UserKey.LATITUDE] = latitude;
    data[UserKey.LONGITUDE] = longitude;
    data[UserKey.COUNTRY_CODE] = countryCode;
    data[UserKey.VENDOR_TYPE] = vendorType;
    data[UserKey.USER_TYPE] = userType;
    data[UserKey.CATEGORY] = category;
    data[UserKey.CATEGORY_IMAGE] = categoryImage;
    data[UserKey.FAVOURITE_VENDORS] = favouriteVendors;
    data[UserKey.EMPLOYEE_OWNER_IMAGE] = employeeOwnerImage;
    data[UserKey.EMPLOYEE_OWNER_NAME] = employeeOwnerName;
    data[UserKey.SUBSCRIPTION_TYPE] = subscriptionType;
    return data;
  }

  @override
  List<Object?> get props => [uid];

  @override
  String toString() {
    // TODO: implement toString
    return 'User--> User-id: $uid--- Latitude: $latitude--- Longitude: $longitude --- User Name: $name';
  }
}
