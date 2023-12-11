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

/// Pagination page size
const int ITEM_PER_PAGE = 10;
const int DEAL_PER_PAGE = 10;

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
  static const String USERS = 'users';
  static const String ITEMS = 'items';
  static const String DEALS = 'deals';
  static const String FOOD_TYPE = 'foodType';
  static const String CATEGORY = 'category';
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
  static const USER_TYPE = 'USER_TYPE';
  static const TRUCK_CATEGORY = 'TRUCK_CATEGORY';
  static const EMPLOYEE_OWNER_NAME = 'EMPLOYEE_OWNER_NAME';
  static const EMPLOYEE_OWNER_IMAGE = 'EMPLOYEE_OWNER_IMAGE';
  static const SUBSCRIPTION_TYPE = 'SUBSCRIPTION_TYPE';
}

class UserKey {
  static const String UID = 'uid';
  static const String VENDOR_ID = 'vendorId';
  static const String IMAGE = 'image';
  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String PHONE = 'phone';
  static const String ABOUT = 'about';
  static const String CREATED_AT = 'createdAt';
  static const String UPDATED_AT = 'updatedAt';
  static const String FCM_TOKENS = 'fcmTokens';
  static const String EMPLOYEE_ITEM_LIST = 'employeeItemList';
  static const String EMPLOYEE_DEAL_LIST = 'employeeDealList';
  static const String IS_VENDOR = 'isVendor';
  static const String IS_ONLINE = 'isOnline';
  static const String IS_EMPLOYEE = 'isEmployee';
  static const String IS_EMPLOYEE_BLOCKED = 'isEmployeeBlocked';
  static const String IS_SUBSCRIBED = 'isSubscribed';
  static const String LATITUDE = 'latitude';
  static const String LONGITUDE = 'longitude';
  static const String COUNTRY_CODE = 'countryCode';
  static const String VENDOR_TYPE = 'vendorType';
  static const String USER_TYPE = 'userType';
  static const String TRUCK_CATEGORY = 'truckCategory';
  static const String FAVOURITE_VENDORS = 'favouriteVendors';
  static const String EMPLOYEE_OWNER_IMAGE = 'employeeOwnerImage';
  static const String EMPLOYEE_OWNER_NAME = 'employeeOwnerName';
  static const String SUBSCRIPTION_TYPE = 'subscriptionType';
}

class ItemKey {
  static const String UID = 'uid';
  static const String ID = 'id';
  static const String IMAGE = 'image';
  static const String TITLE = 'title';
  static const String DESCRIPTION = 'description';
  static const String FOOD_TYPE = 'foodType';
  static const String SEARCH_PARAM = 'searchParam';
  static const String CREATED_AT = 'createdAt';
  static const String UPDATED_AT = 'updatedAt';
  static const String ACTUAL_PRICE = 'actualPrice';
  static const String DISCOUNTED_PRICE = 'discountedPrice';

  static const String SMALL_ITEM_TITLE = 'smallItemTitle';
  static const String MEDIUM_ITEM_TITLE = 'mediumItemTitle';
  static const String LARGE_ITEM_TITLE = 'largeItemTitle';

  static const String SMALL_ITEM_ACTUAL_PRICE = 'smallItemActualPrice';
  static const String SMALL_ITEM_DISCOUNTED_PRICE = 'smallItemDiscountedPrice';

  static const String MEDIUM_ITEM_ACTUAL_PRICE = 'mediumItemActualPrice';
  static const String MEDIUM_ITEM_DISCOUNTED_PRICE = 'mediumItemDiscountedPrice';

  static const String LARGE_ITEM_ACTUAL_PRICE = 'largeItemActualPrice';
  static const String LARGE_ITEM_DISCOUNTED_PRICE = 'largeItemDiscountedPrice';
}

class DealKey {
  static const String UID = 'uid';
  static const String ID = 'id';
  static const String IMAGE = 'image';
  static const String TITLE = 'title';
  static const String DESCRIPTION = 'description';
  static const String SEARCH_PARAM = 'searchParam';
  static const String FOOD_TYPE = 'foodType';
  static const String CREATED_AT = 'createdAt';
  static const String UPDATED_AT = 'updatedAt';
  static const String ACTUAL_PRICE = 'actualPrice';
  static const String DISCOUNTED_PRICE = 'discountedPrice';
  static const String ITEM_NAME = 'itemName';
}

class CategoryKey {
  static const String TITLE = 'title';
  static const String ICON = 'icon';
  static const String CATEGORIES = 'categories';
}