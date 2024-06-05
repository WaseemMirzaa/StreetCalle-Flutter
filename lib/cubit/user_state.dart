import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/utils/constant/constants.dart';

class UserState {
  final String userId;
  final String vendorId;
  final String userImage;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String countryCode;
  final String userAbout;
  final bool isLoggedIn;
  final bool isVendor;
  final bool isOnline;
  final bool isEmployee;
  final bool isEmployeeBlocked;
  final bool isSubscribed;
  final bool isGuest;
  final String vendorType;
  final String userType;
  final String category;
  final String translatedCategory;
  final String categoryImage;
  final String employeeOwnerImage;
  final String employeeOwnerName;
  final String subscriptionType;
  final String stripeId;
  final String planLookUpKey;
  final String subscriptionId;
  final String sessionId;

  UserState({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userImage,
    required this.userPhone,
    required this.userAbout,
    required this.countryCode,
    required this.isLoggedIn,
    required this.isVendor,
    required this.isOnline,
    required this.vendorType,
    required this.userType,
    required this.category,
    required this.translatedCategory,
    required this.categoryImage,
    required this.vendorId,
    required this.isEmployee,
    required this.isEmployeeBlocked,
    required this.isSubscribed,
    required this.isGuest,
    required this.employeeOwnerName,
    required this.employeeOwnerImage,
    required this.subscriptionType,
    required this.stripeId,
    required this.planLookUpKey,
    required this.subscriptionId,
    required this.sessionId,
  });

  UserState copyWith(
      {String? userId,
      String? vendorId,
      String? userName,
      String? userEmail,
      String? userImage,
      String? userPhone,
      String? userAbout,
      bool? isLoggedIn,
      bool? isVendor,
      bool? isOnline,
      String? countryCode,
      String? vendorType,
      String? userType,
      String? category,
      String? categoryImage,
      bool? isEmployee,
      bool? isEmployeeBlocked,
      bool? isSubscribed,
      bool? isGuest,
      String? employeeOwnerImage,
      String? employeeOwnerName,
      String? subscriptionType,
      String? stripeId,
      String? planLookUpKey,
      String? subscriptionId,
      String? sessionId,
      String? translatedCategory,
      String? translatedCategoryImage
      }) {
    return UserState(
      userId: userId ?? this.userId,
      vendorId: vendorId ?? this.vendorId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userImage: userImage ?? this.userImage,
      userPhone: userPhone ?? this.userPhone,
      userAbout: userAbout ?? this.userAbout,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isVendor: isVendor ?? this.isVendor,
      isOnline: isOnline ?? this.isOnline,
      countryCode: countryCode ?? this.countryCode,
      vendorType: vendorType ?? this.vendorType,
      userType: userType ?? this.userType,
      category: category ?? this.category,
      categoryImage: categoryImage ?? this.categoryImage,
      isEmployee: isEmployee ?? this.isEmployee,
      isEmployeeBlocked: isEmployeeBlocked ?? this.isEmployeeBlocked,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      isGuest: isGuest ?? this.isGuest,
      employeeOwnerImage: employeeOwnerImage ?? this.employeeOwnerImage,
      employeeOwnerName: employeeOwnerName ?? this.employeeOwnerName,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      stripeId: stripeId ?? this.stripeId,
      planLookUpKey: planLookUpKey ?? this.planLookUpKey,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      sessionId: sessionId ?? this.sessionId,
      translatedCategory: translatedCategory ?? this.translatedCategory,
    );
  }
}

class UserCubit extends Cubit<UserState> {
  UserCubit(this.sharedPreferencesService)
      : super(
          UserState(
            userId: '',
            vendorId: '',
            userName: '',
            userEmail: '',
            userImage: '',
            userPhone: '',
            userAbout: '',
            isLoggedIn: false,
            isVendor: false,
            isOnline: true,
            countryCode: initialCountyCode,
            vendorType: '',
            userType: '',
            category: '',
            translatedCategory: '',
            categoryImage: '',
            isEmployee: false,
            isEmployeeBlocked: false,
            isSubscribed: false,
            isGuest: false,
            employeeOwnerName: '',
            employeeOwnerImage: '',
            subscriptionType: '',
            stripeId: '',
            planLookUpKey: '',
            subscriptionId: '',
            sessionId: ''
          ),
        );

  final SharedPreferencesService sharedPreferencesService;

  // Setters
  void setUsername(String value) {
    emit(state.copyWith(userName: value));
    sharedPreferencesService.setValue(SharePreferencesKey.USER_NAME, value);
  }

  void setUserEmail(String value) {
    emit(state.copyWith(userEmail: value));
    sharedPreferencesService.setValue(SharePreferencesKey.USER_EMAIL, value);
  }

  void setUserId(String value) {
    emit(state.copyWith(userId: value));
    sharedPreferencesService.setValue(SharePreferencesKey.USER_ID, value);
  }

  void setVendorId(String value) {
    emit(state.copyWith(vendorId: value));
    sharedPreferencesService.setValue(SharePreferencesKey.VENDOR_ID, value);
  }

  void setStripeId(String value) {
    emit(state.copyWith(stripeId: value));
    sharedPreferencesService.setValue(SharePreferencesKey.STRIPE_ID, value);
  }

  void setPlanLookUpKey(String value) {
    emit(state.copyWith(planLookUpKey: value));
    sharedPreferencesService.setValue(SharePreferencesKey.PLAN_LOOK_UP_KEY, value);
  }

  void setSubscriptionId(String value) {
    emit(state.copyWith(subscriptionId: value));
    sharedPreferencesService.setValue(SharePreferencesKey.SUBSCRIPTION_ID, value);
  }

  void setSessionId(String value) {
    emit(state.copyWith(sessionId: value));
    sharedPreferencesService.setValue(SharePreferencesKey.SESSION_ID, value);
  }

  void setUserImage(String value) {
    emit(state.copyWith(userImage: value));
    sharedPreferencesService.setValue(SharePreferencesKey.USER_IMAGE, value);
  }

  void setUserPhone(String value) {
    emit(state.copyWith(userPhone: value));
    sharedPreferencesService.setValue(SharePreferencesKey.USER_NUMBER, value);
  }

  void setUserAbout(String value) {
    emit(state.copyWith(userAbout: value));
    sharedPreferencesService.setValue(SharePreferencesKey.USER_ABOUT, value);
  }

  void setUserCountryCode(String value) {
    emit(state.copyWith(countryCode: value));
    sharedPreferencesService.setValue(SharePreferencesKey.COUNTRY_CODE, value);
  }

  void setIsLoggedIn(bool value) {
    emit(state.copyWith(isLoggedIn: value));
    sharedPreferencesService.setValue(SharePreferencesKey.IS_LOGGED_IN, value);
  }

  void setIsGuest(bool value) {
    emit(state.copyWith(isGuest: value));
    sharedPreferencesService.setValue(SharePreferencesKey.IS_GUEST, value);
  }

  void setIsVendor(bool value) {
    emit(state.copyWith(isVendor: value));
    sharedPreferencesService.setValue(SharePreferencesKey.IS_VENDOR, value);
  }

  void setIsOnline(bool value) {
    emit(state.copyWith(isOnline: value));
    sharedPreferencesService.setValue(SharePreferencesKey.IS_ONLINE, value);
  }

  void setIsEmployee(bool value) {
    emit(state.copyWith(isEmployee: value));
    sharedPreferencesService.setValue(SharePreferencesKey.IS_EMPLOYEE, value);
  }

  void setIsEmployeeBlocked(bool value) {
    emit(state.copyWith(isEmployeeBlocked: value));
    sharedPreferencesService.setValue(SharePreferencesKey.IS_EMPLOYEE_BLOCKED, value);
  }

  void setIsSubscribed(bool value) {
    emit(state.copyWith(isSubscribed: value));
    sharedPreferencesService.setValue(SharePreferencesKey.IS_SUBSCRIBED, value);
  }

  void setVendorType(String value) {
    emit(state.copyWith(vendorType: value));
    sharedPreferencesService.setValue(SharePreferencesKey.VENDOR_TYPE, value);
  }

  void setUserType(String value) {
    emit(state.copyWith(userType: value));
    sharedPreferencesService.setValue(SharePreferencesKey.USER_TYPE, value);
  }

  void setCategory(String value) {
    emit(state.copyWith(category: value));
    sharedPreferencesService.setValue(SharePreferencesKey.CATEGORY, value);
  }

  void setCategoryImage(String value) {
    emit(state.copyWith(categoryImage: value));
    sharedPreferencesService.setValue(SharePreferencesKey.CATEGORY_IMAGE, value);
  }

  void setTranslatedCategory(String value) {
    emit(state.copyWith(translatedCategory: value));
    sharedPreferencesService.setValue(SharePreferencesKey.TRANSLATED_CATEGORY, value);
  }

  void setEmployeeOwnerImage(String value) {
    emit(state.copyWith(employeeOwnerImage: value));
    sharedPreferencesService.setValue(SharePreferencesKey.EMPLOYEE_OWNER_IMAGE, value);
  }

  void setEmployeeOwnerName(String value) {
    emit(state.copyWith(employeeOwnerName: value));
    sharedPreferencesService.setValue(SharePreferencesKey.EMPLOYEE_OWNER_NAME, value);
  }

  void setSubscriptionType(String value) {
    emit(state.copyWith(subscriptionType: value));
    sharedPreferencesService.setValue(SharePreferencesKey.SUBSCRIPTION_TYPE, value);
  }

  void setDefaultState() {
    emit(UserState(
        userId: '',
        vendorId: '',
        userName: '',
        userEmail: '',
        userImage: '',
        userPhone: '',
        userAbout: '',
        isLoggedIn: false,
        isVendor: false,
        isOnline: true,
        countryCode: initialCountyCode,
        vendorType: '',
        userType: '',
        category: '',
        translatedCategory: '',
        categoryImage: '',
        isEmployee: false,
        isEmployeeBlocked: false,
        isSubscribed: false,
        isGuest: false,
        employeeOwnerName: '',
        employeeOwnerImage: '',
        subscriptionType: '',
        stripeId: '',
        planLookUpKey: '',
        subscriptionId: '',
        sessionId: ''
    ));
  }

  void setUserModel(User user,
      {bool isLoggedIn = false}) {
    setUsername(user.name ?? '');
    setVendorId(user.vendorId ?? '');
    setUserEmail(user.email ?? '');
    setUserImage(user.image ?? '');
    setUserId(user.uid ?? '');
    setUserPhone(user.phone ?? '');
    setUserAbout(user.about ?? '');
    setUserCountryCode(user.countryCode ?? initialCountyCode);
    setIsLoggedIn(isLoggedIn);
    setIsVendor(user.isVendor);
    setIsOnline(user.isOnline);
    setIsEmployee(user.isEmployee);
    setIsEmployeeBlocked(user.isEmployeeBlocked);
    setIsSubscribed(user.isSubscribed);
    setEmployeeOwnerImage(user.employeeOwnerImage ?? '');
    setEmployeeOwnerName(user.employeeOwnerName ?? '');
    setVendorType(user.vendorType ?? '');
    setUserType(user.userType ?? '');
    setCategory(user.category ?? '');
    setCategoryImage(user.categoryImage ?? '');
    setTranslatedCategory(user.translatedCategory ?? '');
    setSubscriptionType(user.subscriptionType ?? '');
    setStripeId(user.stripeId ?? '');
    setPlanLookUpKey(user.planLookUpKey ?? '');
    setSubscriptionId(user.subscriptionId ?? '');
    setSessionId(user.sessionId ?? '');
  }
}
