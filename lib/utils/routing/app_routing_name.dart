import 'package:street_calle/utils/constant/constants.dart';

class AppRoutingName {
  static const splashScreen = '/';
  static const selectUserScreen = '/selectUser';
  static const authScreen = '/authScreen';
  static const loginScreen = '/loginScreen';
  static const signUpScreen = '/createAccountScreen';
  static const passwordResetScreen = '/passwordResetScreen';
  static const emailVerificationScreen = '/emailVerificationScreen/:$EMAIL';
  static const mainScreen = '/mainScreen';
  static const clientMainScreen = '/clientMainScreen';
  static const addItem = '/addItem/:$IS_UPDATE/:$IS_FROM_DETAIL';
  static const privacyPolicy = '/privacyPolicy';
  static const termsAndConditions = '/termsAndConditions';
  static const deleteAccount = '/deleteAccount';
  static const vendorSubscriptions = '/vendorSubscriptions';
  static const itemDetail = '/itemDetail/:$IS_CLIENT';
  static const addDeal = '/addDeal/:$IS_UPDATE/:$IS_FROM_DETAIL';
  static const selectMenuItem = '/selectMenuItem';
  static const dealDetail = '/dealDetail/:$IS_CLIENT';
  static const clientMenu = '/clientMenu';
  static const clientMenuItemDetail = '/clientMenuItemDetail';
  static const manageEmployee = '/manageEmployee';
  static const createEmployeeProfileScreen = '/createEmployeeProfileScreen';
  static const addEmployeeMenuItems = '/addEmployeeMenuItems';
  static const employeeDetail = '/employeeDetail:';
  static const viewAllDeals = '/viewAllDeals';
  static const viewAllItems = '/viewAllItems';
  static const profile = '/profile';
  static const vendorProfile = '/vendorProfile';
  static const clientVendorProfile = '/clientVendorProfile';
  static const clientVendorDirection = '/clientVendorDirection';
  static const locationPicker = '/locationPicker';
  static const vendorEmployeeMap = '/vendorEmployeeMap';
  static const userDeleteAccount = '/userDeleteAccount';
}
