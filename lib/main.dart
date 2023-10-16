import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:street_calle/cubit/user_state.dart';
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
import 'package:street_calle/screens/home/profile/cubit/edit_profile_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/profile_status_cubit.dart';
import 'package:street_calle/screens/home/profile/user_profile_tab.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_custom_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_drop_down_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/vendor_home_tab.dart';
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
  runApp(
    MultiBlocProvider(
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
          create: (context)=> FoodTypeCubit(),
        ),
        BlocProvider(
          create: (context)=> FoodTypeExpandedCubit(),
        ),
        BlocProvider(
          create: (context)=> PricingCategoryExpandedCubit(),
        ),
        BlocProvider(
          create: (context)=> FoodTypeDropDownCubit(),
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
          create: (context)=> sl<ProfileStatusCubit>(),
          child: const UserprofileTab(),
        ),
        BlocProvider(
          create: (context)=> sl<EditProfileCubit>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Street Calle',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}

