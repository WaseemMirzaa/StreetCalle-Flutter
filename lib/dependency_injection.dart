import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/auth/cubit/email_verification/email_verification_cubit.dart';
import 'package:street_calle/screens/auth/cubit/forget_password/forget_password_cubit.dart';
import 'package:street_calle/screens/auth/cubit/google_login/google_login_cubit.dart';
import 'package:street_calle/screens/auth/cubit/guest/guest_cubit.dart';
import 'package:street_calle/screens/auth/cubit/login/login_cubit.dart';
import 'package:street_calle/screens/auth/cubit/sign_up/sign_up_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_enable_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/profile_status_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_cubit.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/services/deal_service.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
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
  sl.registerFactory(() => ClientSelectedVendorCubit());
  sl.registerFactory(() => EditProfileEnableCubit());


  ///  [registerLazySingleton] which registers a singleton object that will be
  ///  lazily initialized the first time it is requested,
  ///  and will return the same instance on subsequent requests.


  /// UseCases
  // sl.registerLazySingleton(() => CreateTeacherUseCase(repository: sl.call()));
  // sl.registerLazySingleton(() => UploadImageToStorageUseCase(repository: sl.call()));

  /// Repository
  //sl.registerLazySingleton<TeacherFirebaseRepository>(() => TeacherFirebaseRepositoryImpl(remoteDataSource: sl.call()));

  /// Remote Data Source
  //sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(firebaseFirestore: sl.call(), firebaseStorage: sl.call()));
  sl.registerLazySingleton(() => UserService());
  sl.registerLazySingleton(() => ItemService());
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton(() => DealService());
  sl.registerLazySingleton(() => PricingCategoryCubit());

  /// Firebase
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;
  final firebaseAuth = FirebaseAuth.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseStorage);
  sl.registerLazySingleton(() => firebaseAuth);

  sl.registerLazySingleton(() => SharedPreferencesService());
}