import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:street_calle/screens/auth/auth_screen.dart';
import 'package:street_calle/screens/auth/cubit/facebook_login/facebook_login_cubit.dart';
import 'package:street_calle/screens/auth/cubit/login/login_cubit.dart';
import 'package:street_calle/screens/auth/cubit/sign_up/sign_up_cubit.dart';
import 'package:street_calle/screens/auth/email_verification_screen.dart';
import 'package:street_calle/screens/auth/sign_up_screen.dart';
import 'package:street_calle/screens/auth/password_reset_screen.dart';
import 'package:street_calle/screens/auth/login_screen.dart';
import 'package:street_calle/screens/home/client_main_screen.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/client_menu.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/client_menu_item_detail.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/client_vendor_direction.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/client_vendor_profile.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/vendor_employee_map.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/view_all_deals.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/view_all_items.dart';
import 'package:street_calle/screens/home/settings/cubit/subscription_cubit.dart';
import 'package:street_calle/screens/home/vendor_main_screen.dart';
import 'package:street_calle/screens/home/profile/user_profile_tab.dart';
import 'package:street_calle/screens/home/settings/widgets/vendor_profile.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/add_deal.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/employee/add_employee_menu_item_screen.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/item/add_item.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/employee/create_employee_profile_screen.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/employee/employee_detail_screen.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/item/item_detail.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/employee/manage_employees_screen.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/item/select_menu_item.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/deal_detail.dart';
import 'package:street_calle/screens/selectUser/select_user_screen.dart';
import 'package:street_calle/screens/splash/splash_screen.dart';
import 'package:street_calle/screens/web/delete_account_web_view.dart';
import 'package:street_calle/services/stripe_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/settings/widgets/privacy_policy.dart';
import 'package:street_calle/screens/home/settings/widgets/terms_and_conditions.dart';
import 'package:street_calle/screens/home/settings/widgets/vendor_subscription.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/widgets/location_picker.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/screens/auth/cubit/google_login/google_login_cubit.dart';
import 'package:street_calle/screens/auth/cubit/guest/guest_cubit.dart';
import 'package:street_calle/screens/auth/cubit/forget_password/forget_password_cubit.dart';
import 'package:street_calle/screens/auth/cubit/email_verification/email_verification_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_custom_item_cubit.dart';
import 'package:street_calle/screens/auth/cubit/timer/timer_cubit.dart';
import 'package:street_calle/screens/auth/cubit/create_employee/create_employee_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/menu_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/selected_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/selected_item_cubit.dart';

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
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context)=> sl<LoginCubit>(),
            ),
            BlocProvider(
              create: (context)=> sl<GoogleLoginCubit>(),
            ),
            BlocProvider(
              create: (context)=> sl<FacebookLoginCubit>(),
            ),
            BlocProvider(
              create: (context)=> sl<GuestCubit>(),
            ),
          ],
           child: const LoginScreen()
        );
      },
    ),
    GoRoute(
      path: AppRoutingName.signUpScreen,
      name: AppRoutingName.signUpScreen,
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context)=> sl<SignUpCubit>(),
            ),
          ],
          child: const SignUpScreen()
        );
      },
    ),
    GoRoute(
      path: AppRoutingName.passwordResetScreen,
      name: AppRoutingName.passwordResetScreen,
      builder: (context, state) {
        return BlocProvider(
          create: (context)=> sl<PasswordResetCubit>(),
          child: const PasswordResetScreen(),
        );
      }
    ),
    GoRoute(
      path: AppRoutingName.emailVerificationScreen,
      name: AppRoutingName.emailVerificationScreen,
      builder: (context, state) {
        final email = state.pathParameters[EMAIL]!;

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context)=> sl<EmailVerificationCubit>(),
            ),
            BlocProvider(
              create: (context)=> TimerCubit(60),
            ),
          ],
          child: EmailVerificationScreen(email: email),
        );
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
        return const VendorMainScreen();
      },
    ),
    GoRoute(
      path: AppRoutingName.clientMainScreen,
      name: AppRoutingName.clientMainScreen,
      // routes: [
      //    GoRoute(
      //          name: AppRoutingName.addItem,
      //          path: AppRoutingName.addItem,
      //          builder: (BuildContext context, GoRouterState state) => const AddItem()
      //        ),
      // ],
      builder: (context, state) {
        //final user = state.pathParameters[USER]!;
        return const ClientMainScreen();
      },
    ),
    GoRoute(
      path: AppRoutingName.addItem,
      name: AppRoutingName.addItem,
      builder: (context, state) {
        final isUpdate = state.pathParameters[IS_UPDATE]!;
        final isFromDetail = state.pathParameters[IS_FROM_DETAIL]!;
        return AddItem(
            isUpdate: bool.parse(isUpdate),
            isFromDetail: bool.parse(isFromDetail));
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
        return BlocProvider(
          create: (_) => SubscriptionCubit(sl<UserService>(), sl<StripeService>()),
          child: const VendorSubscription(),
        );
      },
    ),
    GoRoute(
      path: AppRoutingName.itemDetail,
      name: AppRoutingName.itemDetail,
      builder: (context, state) {
        final item = state.extra as Item;
        final isClient = state.pathParameters[IS_CLIENT]!;
        return ItemDetail(item: item, isClient: bool.parse(isClient),);
      },
    ),
    GoRoute(
      path: AppRoutingName.addDeal,
      name: AppRoutingName.addDeal,
      builder: (context, state) {
        final isUpdate = state.pathParameters[IS_UPDATE]!;
        final isFromDetail = state.pathParameters[IS_FROM_DETAIL]!;

        return BlocProvider(
          create: (context)=> AddCustomItemCubit(),
          child: AddDeal(
              isUpdate: bool.parse(isUpdate),
              isFromDetail: bool.parse(isFromDetail)),
        );
      },
    ),
    GoRoute(
      path: AppRoutingName.selectMenuItem,
      name: AppRoutingName.selectMenuItem,
      builder: (context, state) {
        return const SelectMenuItem();
      },
    ),
    GoRoute(
      path: AppRoutingName.dealDetail,
      name: AppRoutingName.dealDetail,
      builder: (context, state) {
        final deal = state.extra as Deal;
        final isClient = state.pathParameters[IS_CLIENT]!;
        return DealDetail(deal: deal, isClient: bool.parse(isClient));
      },
    ),
    GoRoute(
      path: AppRoutingName.clientMenu,
      name: AppRoutingName.clientMenu,
      builder: (context, state) {
        return BlocProvider(
           create: (context)=> ClientMenuSearchCubit(),
           child: const ClientMenu(),
         );
      },
    ),
    GoRoute(
      path: AppRoutingName.clientMenuItemDetail,
      name: AppRoutingName.clientMenuItemDetail,
      builder: (context, state) {
        final user = state.extra as User;
        return  BlocProvider(
          create: (context)=> FoodSearchCubit(),
          child: ClientMenuItemDetail(user: user),
        );
      },
    ),
    GoRoute(
      path: AppRoutingName.manageEmployee,
      name: AppRoutingName.manageEmployee,
      builder: (context, state) {
        return const ManageEmployeesScreen();
      },
    ),
    GoRoute(
      path: AppRoutingName.createEmployeeProfileScreen,
      name: AppRoutingName.createEmployeeProfileScreen,
      builder: (context, state) {
        // return const CreateEmployeeProfileScreen();
        return BlocProvider(
          create: (context)=> sl<CreateEmployeeCubit>(),
          child: CreateEmployeeProfileScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutingName.employeeDetail,
      name: AppRoutingName.employeeDetail,
      builder: (context, state) {
        final user = state.extra as User;
        return EmployeeDetailScreen(user: user);
      },
    ),
    // GoRoute(
    //   path: AppRoutingName.addEmployeeMenuItems,
    //   name: AppRoutingName.addEmployeeMenuItems,
    //   builder: (context, state) {
    //     return   AddEmployeeMenuItemsScreen();
    //   },
    // ),
    GoRoute(
      path: AppRoutingName.viewAllDeals,
      name: AppRoutingName.viewAllDeals,
      builder: (context, state) {
        // return const CreateEmployeeProfileScreen();
        final user = state.extra as User;
        return BlocProvider(
          create: (context)=> AllDealsSearchCubit(),
          child: ViewAllDeals(user: user),
        );
      },
    ),
    GoRoute(
      path: AppRoutingName.viewAllItems,
      name: AppRoutingName.viewAllItems,
      builder: (context, state) {
        // return const CreateEmployeeProfileScreen();
       final user = state.extra as User;
       return BlocProvider(
          create: (context)=> AllItemsSearchCubit(),
          child: ViewAllItems(user: user),
        );
      },
    ),
    GoRoute(
      path: AppRoutingName.addEmployeeMenuItems,
      name: AppRoutingName.addEmployeeMenuItems,
      builder: (context, state) {
        final user = state.extra as User;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context)=> sl<SelectedItemsCubit>(),
            ),
            BlocProvider(
              create: (context)=> sl<MenuCubit>(),
            ),
            BlocProvider(
              create: (context)=> sl<SelectedDealsCubit>(),
            ),
          ],
          child: AddEmployeeMenuItemsScreen(user: user),
        );
      },
    ),
    GoRoute(
      path: AppRoutingName.profile,
      name: AppRoutingName.profile,
      builder: (context, state) {
        return const UserprofileTab();
      },
    ),
    GoRoute(
      path: AppRoutingName.clientVendorDirection,
      name: AppRoutingName.clientVendorDirection,
      builder: (context, state) {
        return const ClientVendorDirection();
      },
    ),
    GoRoute(
      path: AppRoutingName.vendorProfile,
      name: AppRoutingName.vendorProfile,
      builder: (context, state) {
        return const VendorProfile();
      },
    ),
    GoRoute(
      path: AppRoutingName.clientVendorProfile,
      name: AppRoutingName.clientVendorProfile,
      builder: (context, state) {
        final userId = state.extra as String;
        return ClientVendorProfile(userId: userId,);
      },
    ),

    GoRoute(
      path: AppRoutingName.locationPicker,
      name: AppRoutingName.locationPicker,
      builder: (context, state) {
        final position = state.extra as LatLng;
        return LocationPicker(position: position,);
      },
    ),

    GoRoute(
      path: AppRoutingName.vendorEmployeeMap,
      name: AppRoutingName.vendorEmployeeMap,
      builder: (context, state) {
        final userId = state.extra as String;
        return VendorEmployeeMap(userId: userId,);
      },
    ),
    GoRoute(
      path: AppRoutingName.deleteAccount,
      name: AppRoutingName.deleteAccount,
      builder: (context, state) {
        return const DeleteAccountWebView();
      },
    ),
  ],
);
