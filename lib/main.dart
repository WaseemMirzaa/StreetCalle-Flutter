import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/auth/cubit/create_employee/create_employee_cubit.dart';
import 'package:street_calle/screens/auth/cubit/email_verification/email_verification_cubit.dart';
import 'package:street_calle/screens/auth/cubit/forget_password/forget_password_cubit.dart';
import 'package:street_calle/screens/auth/cubit/google_login/google_login_cubit.dart';
import 'package:street_calle/screens/auth/cubit/guest/guest_cubit.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/auth/cubit/login/login_cubit.dart';
import 'package:street_calle/screens/auth/cubit/timer/timer_cubit.dart';
import 'package:street_calle/screens/auth/password_reset_screen.dart';
import 'package:street_calle/screens/auth/login_screen.dart';
import 'package:street_calle/screens/auth/sign_up_screen.dart';
import 'package:street_calle/screens/auth/cubit/sign_up/sign_up_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_favourites/cubit/favourite_list_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/client_home_tab.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/online_vendors_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/cubit/apply_filter_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/current_location_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/direction_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/favourite_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/cubit/filter_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/marker_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/edit_profile_enable_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/profile_status_cubit.dart';
import 'package:street_calle/screens/home/profile/user_profile_tab.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_custom_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/menu_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_drop_down_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/selected_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/selected_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/vendor_home_tab.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/employee/add_employee_menu_item_screen.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/employee/create_employee_profile_screen.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/utils/routing/routing.dart';
import 'package:street_calle/utils/themes/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/firebase_options.dart';
import 'package:street_calle/dependency_injection.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  final sharedPreferencesService = sl.get<SharedPreferencesService>();
  await sharedPreferencesService.init();

  try {
    if (isAndroid) {
        await GoogleMapsFlutterAndroid().initializeWithRenderer(AndroidMapRenderer.latest);
      }
  } catch (e) {
    print(e);
  } finally {
    runApp(
      const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context)=> sl<SignUpCubit>(),
          child: const SignUpScreen(),
        ),
        BlocProvider(
          create: (context)=> ImageCubit(),
        ),
        BlocProvider(
          create: (context)=> sl<LoginCubit>(),
          child: const LoginScreen(),
        ),
        BlocProvider(
          create: (context)=> sl<PasswordResetCubit>(),
          child: const PasswordResetScreen(),
        ),
        BlocProvider(
          create: (context)=> sl<EmailVerificationCubit>(),
        ),
        BlocProvider(
          create: (context)=> sl<GuestCubit>(),
        ),
        BlocProvider(
          create: (context)=> TimerCubit(60),
        ),
        BlocProvider(
          create: (context)=> sl<GoogleLoginCubit>(),
        ),
        BlocProvider(
          create: (context)=> sl<UserCubit>(),
        ),
        BlocProvider(
          create: (context)=> sl<AddItemCubit>(),
          child: const VendorHomeTab(),
        ),
        // BlocProvider(
        //   create: (context)=> ItemBloc(itemService, sharedPreferencesService),
        // ),
        BlocProvider(
          create: (context)=> sl<FoodTypeCubit>(),
        ),
        BlocProvider(
          create: (context)=> sl<FoodTypeExpandedCubit>(),
        ),
        BlocProvider(
          create: (context)=> sl<PricingCategoryExpandedCubit>(),
        ),
        BlocProvider(
          create: (context)=> sl<FoodTypeDropDownCubit>(),
        ),
        BlocProvider(
          create: (context)=> sl<PricingCategoryCubit>(),
        ),
        BlocProvider(
          create: (context)=> sl<AddDealCubit>(),
        ),
        BlocProvider(
          create: (context)=> AddCustomItemCubit(),
        ),
        BlocProvider(
          create: (context)=> SearchCubit(),
        ),
        BlocProvider(
          create: (context)=> ClientMenuSearchCubit(),
        ),
        BlocProvider(
          create: (context)=> FoodSearchCubit(),
        ),
        BlocProvider(
          create: (context)=> AllDealsSearchCubit(),
        ),
        BlocProvider(
          create: (context)=> AllItemsSearchCubit(),
        ),
        BlocProvider(
          create: (context)=> SearchItemsCubit(),
        ),
        BlocProvider(
          create: (context)=> SearchDealsCubit(),
        ),
        BlocProvider(
          create: (context)=> sl<ProfileStatusCubit>(),
          child: const UserprofileTab(),
        ),
        BlocProvider(
          create: (context)=> sl<EditProfileCubit>(),
        ),
        BlocProvider(
          create: (context)=> sl<ClientSelectedVendorCubit>(),
        ),
        BlocProvider(
          create: (context)=> sl<EditProfileEnableCubit>(),
        ),
        BlocProvider(
          create: (context)=> sl<CreateEmployeeCubit>(),
          child: CreateEmployeeProfileScreen(),
        ),

        BlocProvider(
          create: (context)=> sl<SelectedItemsCubit>(),
          child: AddEmployeeMenuItemsScreen(),
        ),
        BlocProvider(
          create: (context)=> sl<MenuCubit>(),
          child: AddEmployeeMenuItemsScreen(),
        ),
        BlocProvider(
          create: (context)=> sl<SelectedDealsCubit>(),
          child: AddEmployeeMenuItemsScreen(),
        ),
        BlocProvider(
          create: (_) => LocalItemsStorage(),
        ),
        BlocProvider(
          create: (_) => LocalDealsStorage(),
        ),
        BlocProvider(
          create: (_) => RemoteUserItems(),
        ),
        BlocProvider(
          create: (_) => NavPositionCubit(),
        ),
        BlocProvider(
          create: (_) => OnlineVendorsCubit(),
        ),
        BlocProvider(
          create: (context)=> sl<MarkersCubit>(),
          child: const ClientHomeTab(),
        ),
        BlocProvider(
          create: (context)=> sl<FavoriteCubit>(),
        ),
        BlocProvider(
          create: (context)=> sl<FavouriteListCubit>(),
        ),
        BlocProvider(
          create: (context)=> sl<FilterItemsCubit>(),
        ),
        BlocProvider(
          create: (context)=> FilterDealsCubit(),
        ),
        BlocProvider(
          create: (context)=> RemoteUserDeals(),
        ),
        BlocProvider(
          create: (context)=> sl<DirectionCubit>(),
        ),
        BlocProvider(
          create: (context)=> ApplyFilterCubit(),
        ),
        BlocProvider(
          create: (context)=> sl<CurrentLocationCubit>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        //locale: DevicePreview.locale(context),
        //builder: DevicePreview.appBuilder,
        title: 'Street Calle',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: router,
      ),
    );
  }
}