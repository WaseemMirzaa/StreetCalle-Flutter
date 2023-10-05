
const METROPOLIS_MEDIUM = 'MetropolisMD';
const METROPOLIS_SEMI_BOLD = 'MetropolisSM';
const METROPOLIS_BOLD = 'MetropolisB'; //TODO: Also create a separate TextStyle for it
const METROPOLIS_EXTRA_BOLD = 'MetropolisEB';
const METROPOLIS_R = 'MetropolisR';
const EUROPA_BOLD = 'EuropaBD';
const CABIN_BOLD = 'CabinBD';
const POPPINS_R = 'PoppinsR';
const RIFTSOFT = 'RiftSoft';

const defaultLogoSize = 300.0;
const defaultButtonSize = 55.0;

class Collections {
  static const String user = 'user';
  static const String item = 'item';
}

class SharePreferencesKey {

  static const IS_LOGGED_IN = 'IS_LOGGED_IN';
  static const USER_ID = 'USER_ID';
  static const USER_NAME = 'USER_NAME';
  static const USER_NUMBER = 'USER_NUMBER';
  static const USER_EMAIL = 'USER_EMAIL';
  static const USER_IMAGE = 'USER_IMAGE';
  static const IS_VENDOR = 'IS_VENDOR';
}

class UserKey {
  static const String uid = 'uid';
  static const String image = 'image';
  static const String name = 'name';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String fcmTokens = 'fcmTokens';
  static const String isVendor = 'isVendor';
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
}