
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/revenucat/revenu_cat_api.dart';
import 'package:street_calle/screens/auth/cubit/checkbox/checkbox_cubit.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_favourites/cubit/favourite_list_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/client_home_tab.dart';
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
import 'package:flutter_dotenv/flutter_dotenv.dart';

String SECRET_KEY = '';
String PUBLISH_KEY = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  final sharedPreferencesService = sl.get<SharedPreferencesService>();
  await sharedPreferencesService.init();

  await dotenv.load(fileName: 'assets/.env');
  Stripe.publishableKey = dotenv.env['PUBLISHABLE_KEY_TEST'] ?? '';
  PUBLISH_KEY = dotenv.env['PUBLISHABLE_KEY_TEST'] ?? '';
  SECRET_KEY = dotenv.env['SECRET_KEY_TEST'] ?? '';
  Stripe.merchantIdentifier = 'merchant.flutter.street-calle.stripe';
  Stripe.urlScheme = 'street-calle-stripe';
  await Stripe.instance.applySettings();
  RevenuCatAPI.initPlatformState();


  try {
    if (isAndroid) {
        await GoogleMapsFlutterAndroid().initializeWithRenderer(AndroidMapRenderer.latest);
      }
  } catch (e) {
    print(e);
  } finally {
    runApp(
      DevicePreview(
          enabled: !kReleaseMode,
          builder: (context)=> const MyApp())
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
          create: (context)=> ImageCubit(),
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
          create: (context)=> SearchCubit(),
        ),
        BlocProvider(
          create: (context)=> CheckBoxCubit(),
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