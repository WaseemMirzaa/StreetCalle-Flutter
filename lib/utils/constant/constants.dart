const METROPOLIS_MEDIUM = 'MetropolisMD';
const METROPOLIS_SEMI_BOLD = 'MetropolisSM';
const METROPOLIS_BOLD =
    'MetropolisB'; //TODO: Also create a separate TextStyle for it
const METROPOLIS_EXTRA_BOLD = 'MetropolisEB';
const METROPOLIS_R = 'MetropolisR';
const EUROPA_BOLD = 'EuropaBD';
const CABIN_BOLD = 'CabinBD';
const POPPINS_R = 'PoppinsR';
const RIFTSOFT = 'RiftSoft';

const defaultLogoSize = 300.0;
const defaultButtonSize = 55.0;
const defaultPrice = 0;
const defaultHorizontalPadding = 28.0;
const defaultVerticalPadding = 16.0;
const initialCountyCode = 'US';

/// PathParameters (for items and deals) --> change these wisely
const IS_UPDATE = 'isUpdate';
const IS_FROM_DETAIL = 'isFromDetail';
const USER = 'user';
const EMAIL = 'email';
const VENDOR_TYPE = 'vendor_type';
const IS_CLIENT = 'isClient';
const IS_FAVOURITE = 'isFavourite';
/// PathParameters (for items and deals) --> change these wisely

class Collections {
  static const String users = 'users';
  static const String items = 'items';
  static const String deals = 'deals';
  static const String foodType = 'foodType';
}

class SharePreferencesKey {
  static const IS_LOGGED_IN = 'IS_LOGGED_IN';
  static const USER_ID = 'USER_ID';
  static const VENDOR_ID = 'VENDOR_ID';
  static const USER_NAME = 'USER_NAME';
  static const USER_ABOUT = 'USER_ABOUT';
  static const USER_NUMBER = 'USER_NUMBER';
  static const COUNTRY_CODE = 'COUNTRY_CODE';
  static const USER_EMAIL = 'USER_EMAIL';
  static const USER_IMAGE = 'USER_IMAGE';
  static const IS_VENDOR = 'IS_VENDOR';
  static const IS_ONLINE = 'IS_ONLINE';
  static const IS_EMPLOYEE = 'IS_EMPLOYEE';
  static const IS_EMPLOYEE_BLOCKED = 'IS_EMPLOYEE_BLOCKED';
  static const IS_SUBSCRIBED = 'IS_SUBSCRIBED';
  static const VENDOR_TYPE = 'VENDOR_TYPE';
  static const EMPLOYEE_OWNER_NAME = 'EMPLOYEE_OWNER_NAME';
  static const EMPLOYEE_OWNER_IMAGE = 'EMPLOYEE_OWNER_IMAGE';
  static const SUBSCRIPTION_TYPE = 'SUBSCRIPTION_TYPE';
}

class UserKey {
  static const String uid = 'uid';
  static const String vendorId = 'vendorId';
  static const String image = 'image';
  static const String name = 'name';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String about = 'about';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String fcmTokens = 'fcmTokens';
  static const String employeeItemList = 'employeeItemList';
  static const String employeeDealList = 'employeeDealList';
  static const String isVendor = 'isVendor';
  static const String isOnline = 'isOnline';
  static const String isEmployee = 'isEmployee';
  static const String isEmployeeBlocked = 'isEmployeeBlocked';
  static const String isSubscribed = 'isSubscribed';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String countryCode = 'countryCode';
  static const String vendorType = 'vendorType';
  static const String favouriteVendors = 'favouriteVendors';
  static const String employeeOwnerImage = 'employeeOwnerImage';
  static const String employeeOwnerName = 'employeeOwnerName';
  static const String subscriptionType = 'subscriptionType';
}

class ItemKey {
  static const String uid = 'uid';
  static const String id = 'id';
  static const String image = 'image';
  static const String title = 'title';
  static const String description = 'description';
  static const String foodType = 'foodType';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String actualPrice = 'actualPrice';
  static const String discountedPrice = 'discountedPrice';

  static const String smallItemTitle = 'smallItemTitle';
  static const String mediumItemTitle = 'mediumItemTitle';
  static const String largeItemTitle = 'largeItemTitle';

  static const String smallItemActualPrice = 'smallItemActualPrice';
  static const String smallItemDiscountedPrice = 'smallItemDiscountedPrice';

  static const String mediumItemActualPrice = 'mediumItemActualPrice';
  static const String mediumItemDiscountedPrice = 'mediumItemDiscountedPrice';

  static const String largeItemActualPrice = 'largeItemActualPrice';
  static const String largeItemDiscountedPrice = 'largeItemDiscountedPrice';
}

class DealKey {
  static const String uid = 'uid';
  static const String id = 'id';
  static const String image = 'image';
  static const String title = 'title';
  static const String description = 'description';
  static const String foodType = 'foodType';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String actualPrice = 'actualPrice';
  static const String discountedPrice = 'discountedPrice';
  static const String itemNames = 'itemName';
}
