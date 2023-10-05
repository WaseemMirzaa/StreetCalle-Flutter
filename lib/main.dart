import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/bloc/item_bloc.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/routing/routing.dart';
import 'package:street_calle/utils/themes/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/firebase_options.dart';

FirebaseFirestore fireStore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;

UserService userService = UserService();
AuthService authService = AuthService();
ItemService itemService = ItemService();
SharedPreferencesService sharedPreferencesService = SharedPreferencesService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await sharedPreferencesService.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context)=> SignUpCubit(authService),
          child: const SignUpScreen(),
        ),
        BlocProvider(
          create: (context)=> ImageCubit(),
          child: const SignUpScreen(),
        ),
        BlocProvider(
          create: (context)=> LoginCubit(authService),
          child: const LoginScreen(),
        ),
        BlocProvider(
          create: (context)=> PasswordResetCubit(authService),
          child: const PasswordResetScreen(),
        ),
        BlocProvider(
          create: (context)=> EmailVerificationCubit(authService),
        ),
        BlocProvider(
          create: (context)=> GuestCubit(authService),
        ),
        BlocProvider(
          create: (context)=> TimerCubit(60),
        ),
        BlocProvider(
          create: (context)=> GoogleLoginCubit(authService),
        ),
        BlocProvider(
          create: (context)=> UserCubit(sharedPreferencesService),
        ),
        BlocProvider(
          create: (context)=> AddItemCubit(itemService, sharedPreferencesService),
        ),
        // BlocProvider(
        //   create: (context)=> ItemBloc(itemService, sharedPreferencesService),
        // ),
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

