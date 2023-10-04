import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/auth/auth_screen.dart';
import 'package:street_calle/screens/auth/email_verification_screen.dart';
import 'package:street_calle/screens/auth/sign_up_screen.dart';
import 'package:street_calle/screens/auth/password_reset_screen.dart';
import 'package:street_calle/screens/auth/login_screen.dart';
import 'package:street_calle/screens/home/main_screen.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/add_item.dart';
import 'package:street_calle/screens/selectUser/select_user_screen.dart';
import 'package:street_calle/screens/splash/splash_screen.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/settings/widgets/privacy_policy.dart';
import 'package:street_calle/screens/home/settings/widgets/terms_and_conditions.dart';
import 'package:street_calle/screens/home/settings/widgets/vendor_subscription.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutingName.splashScreen,
      builder: (context, state) => const SplashScreen(),
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
      // routes: [
      //    GoRoute(
      //          name: AppRoutingName.addItem,
      //          path: AppRoutingName.addItem,
      //          builder: (BuildContext context, GoRouterState state) => const AddItem()
      //        ),
      // ],
      builder: (context, state) {
        final user = state.pathParameters['user']!;
        return MainScreen(user: user);
      },
    ),
    GoRoute(
      path: AppRoutingName.addItem,
      name: AppRoutingName.addItem,
      builder: (context, state) {
        return const AddItem();
      },
    ),
    GoRoute(
      path: AppRoutingName.privacyPolicy,
      name: AppRoutingName.privacyPolicy,
      builder: (context, state) {
        return const PrivacyPolicy();
      },
    ),
    GoRoute(
      path: AppRoutingName.termsAndConditions,
      name: AppRoutingName.termsAndConditions,
      builder: (context, state) {
        return const TermsAndConditions();
      },
    ),
    GoRoute(
      path: AppRoutingName.vendorSubscriptions,
      name: AppRoutingName.vendorSubscriptions,
      builder: (context, state) {
        return const VendorSubscription();
      },
    ),
  ],
);