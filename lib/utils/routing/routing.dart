import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/auth/auth_screen.dart';
import 'package:street_calle/screens/auth/email_verification_screen.dart';
import 'package:street_calle/screens/auth/sign_up_screen.dart';
import 'package:street_calle/screens/auth/password_reset_screen.dart';
import 'package:street_calle/screens/auth/login_screen.dart';
import 'package:street_calle/screens/home/main_screen.dart';
import 'package:street_calle/screens/selectUser/select_user_screen.dart';
import 'package:street_calle/screens/splash/splash_screen.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutingName.splashScreen,
      builder: (context, state) => const MainScreen(user: 'Shehzad'),
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
      path: AppRoutingName.signUpScreen,
      name: AppRoutingName.signUpScreen,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoutingName.passwordResetScreen,
      name: AppRoutingName.passwordResetScreen,
      builder: (context, state) => const PasswordResetScreen(),
    ),
    GoRoute(
      path: AppRoutingName.emailVerificationScreen,
      name: AppRoutingName.emailVerificationScreen,
      builder: (context, state) {
        final email = state.pathParameters['email']!;
        return EmailVerificationScreen(email: email);
      },
    ),
    GoRoute(
      path: AppRoutingName.mainScreen,
      name: AppRoutingName.mainScreen,
      builder: (context, state) {
        final user = state.pathParameters['email']!;
        return MainScreen(user: user);
      },
    ),
  ],
);