import 'package:street_calle/utils/constant/constants.dart';

class AppRoutingName {
  static const splashScreen = '/';
  static const selectUserScreen = '/selectUser';
  static const authScreen = '/authScreen';
  static const loginScreen = '/loginScreen';
  static const signUpScreen = '/createAccountScreen';
  static const passwordResetScreen = '/passwordResetScreen';
  static const emailVerificationScreen = '/emailVerificationScreen/:$EMAIL';
  static const mainScreen = '/mainScreen/:$USER';
  static const clientMainScreen = '/clientMainScreen/:$USER';
  static const addItem = '/addItem/:$IS_UPDATE/:$IS_FROM_DETAIL';
  static const privacyPolicy = '/privacyPolicy';
  static const termsAndConditions = '/termsAndConditions';
  static const vendorSubscriptions = '/vendorSubscriptions';
  static const itemDetail = '/itemDetail';
  static const addDeal = '/addDeal/:$IS_UPDATE/:$IS_FROM_DETAIL';
  static const selectMenuItem = '/selectMenuItem';
  static const dealDetail = '/dealDetail';
  static const editProfile = '/editProfile';
  static const clientMenu = '/clientMenu';
  static const clientMenuItemDetail = '/clientMenuItemDetail:';
}