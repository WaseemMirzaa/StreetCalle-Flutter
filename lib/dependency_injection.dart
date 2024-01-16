import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/auth/cubit/create_employee/create_employee_cubit.dart';
import 'package:street_calle/screens/auth/cubit/email_verification/email_verification_cubit.dart';
import 'package:street_calle/screens/auth/cubit/forget_password/forget_password_cubit.dart';
import 'package:street_calle/screens/auth/cubit/google_login/google_login_cubit.dart';
import 'package:street_calle/screens/auth/cubit/guest/guest_cubit.dart';
import 'package:street_calle/screens/auth/cubit/login/login_cubit.dart';
import 'package:street_calle/screens/auth/cubit/sign_up/sign_up_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_favourites/cubit/favourite_list_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/current_location_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/direction_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/favourite_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/cubit/filter_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/marker_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_enable_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/profile_status_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/menu_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_drop_down_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/selected_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/selected_item_cubit.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/services/category_service.dart';
import 'package:street_calle/services/deal_service.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/services/stripe_service.dart';
import 'package:street_calle/services/user_service.dart';

/// [Dependency Injection] a way of making a class
/// independent of its own dependencies.

final sl = GetIt.instance;

Future<void> init() async {


  ///  [registerFactory] method is used to register a
  ///  factory function that will be used to create
  ///  an instance of a specific type whenever it is requested.

  /// Cubits
  sl.registerFactory(() => SignUpCubit(sl.call(), sl.call()));
  sl.registerFactory(() => LoginCubit(sl.call(), sl.call()));
  sl.registerFactory(() => PasswordResetCubit(sl.call()));
  sl.registerFactory(() => EmailVerificationCubit(sl.call()));
  sl.registerFactory(() => GuestCubit(sl.call()));
  sl.registerFactory(() => GoogleLoginCubit(sl.call(), sl.call()));
  sl.registerFactory(() => UserCubit(sl.call()));
  sl.registerFactory(() => AddItemCubit(sl.call(), sl.call(), sl.call()));
  sl.registerFactory(() => AddDealCubit(sl.call(), sl.call()));
  sl.registerFactory(() => ProfileStatusCubit(sl.call(), sl.call()));
  sl.registerFactory(() => EditProfileCubit(sl.call(), sl.call()));
  sl.registerFactory(() => FavoriteCubit(sl.call()));
  sl.registerFactory(() => ClientSelectedVendorCubit());
  sl.registerFactory(() => EditProfileEnableCubit());
  sl.registerFactory(() => MarkersCubit());
  sl.registerFactory(() => CreateEmployeeCubit(sl.call(), sl.call()));
  sl.registerFactory(() => SelectedItemsCubit());
  sl.registerFactory(() => SelectedDealsCubit());
  sl.registerFactory(() => MenuCubit());
  sl.registerFactory(() => FavouriteListCubit());
  sl.registerFactory(() => FilterItemsCubit());
  sl.registerFactory(() => DirectionCubit());
  sl.registerFactory(() => FoodTypeCubit());
  sl.registerFactory(() => FoodTypeExpandedCubit());
  sl.registerFactory(() => PricingCategoryExpandedCubit());
  sl.registerFactory(() => FoodTypeDropDownCubit());
  sl.registerFactory(() => CurrentLocationCubit());


  ///  [registerLazySingleton] which registers a singleton object that will be
  ///  lazily initialized the first time it is requested,
  ///  and will return the same instance on subsequent requests.

  sl.registerLazySingleton(() => UserService());
  sl.registerLazySingleton(() => ItemService());
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton(() => DealService());
  sl.registerLazySingleton(() => CategoryService());
  sl.registerLazySingleton(() => PricingCategoryCubit());
  sl.registerLazySingleton(() => StripeService());

  /// Firebase
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;
  final firebaseAuth = FirebaseAuth.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseStorage);
  sl.registerLazySingleton(() => firebaseAuth);

  sl.registerLazySingleton(() => SharedPreferencesService());
}