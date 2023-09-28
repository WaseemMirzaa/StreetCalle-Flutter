import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/auth/auth_screen.dart';
import 'package:street_calle/screens/auth/create_account_screen.dart';
import 'package:street_calle/screens/auth/forget_password_screen.dart';
import 'package:street_calle/screens/auth/login_screen.dart';
import 'package:street_calle/screens/onBoarding/on_boarding_screen.dart';
import 'package:street_calle/screens/selectUser/select_user_screen.dart';
import 'package:street_calle/screens/splash/splash_screen.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutingName.splashScreen,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutingName.onBoardingScreen,
      name: AppRoutingName.onBoardingScreen,
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      path: AppRoutingName.selectUserScreen,
      name: AppRoutingName.selectUserScreen,
      builder: (context, state) => const SelectUserScreen(),
    ),
    GoRoute(
      path: AppRoutingName.authScreen,
      name: AppRoutingName.authScreen,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: AppRoutingName.loginScreen,
      name: AppRoutingName.loginScreen,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutingName.createAccountScreen,
      name: AppRoutingName.createAccountScreen,
      builder: (context, state) => const CreateAccountScreen(),
    ),
    GoRoute(
      path: AppRoutingName.forgetPasswordScreen,
      name: AppRoutingName.forgetPasswordScreen,
      builder: (context, state) => const ForgetPasswordScreen(),
    ),
  ],
);