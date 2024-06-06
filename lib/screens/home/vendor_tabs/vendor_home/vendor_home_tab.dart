import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/generated/locale_keys.g.dart';
import 'package:street_calle/revenucat/singleton_data.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/item/show_all_items.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/item_deal_buttons.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/manage_vendor_locations.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/screens/home/profile/cubit/profile_status_cubit.dart';
import 'package:street_calle/widgets/search_field.dart';
import 'package:street_calle/widgets/category_widget.dart';

import 'package:street_calle/revenucat/revenu_cat_api.dart';
import 'package:street_calle/services/user_service.dart';

class VendorHomeTab extends StatefulWidget {
  const VendorHomeTab({Key? key}) : super(key: key);

  @override
  State<VendorHomeTab> createState() => _VendorHomeTabState();
}

class _VendorHomeTabState extends State<VendorHomeTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Future<void> syncUserSubscriptionStatus(
      UserService userService,
      UserCubit userCubit,
      bool isSubscribed,
      String subscriptionType,
      String planLookUpKey
      ) async {

    final result = await userService.updateUserSubscription(
        isSubscribed, subscriptionType, userCubit.state.userId, planLookUpKey);
    if (result) {
      userCubit.setIsSubscribed(isSubscribed);
      userCubit.setSubscriptionType(subscriptionType);
      userCubit.setPlanLookUpKey(planLookUpKey);
    }
    if (!isSubscribed) {
      await userService.updateUserStripeDetails(
          '', '', '', userCubit.state.userId);
      userCubit.setSubscriptionId('');
      userCubit.setStripeId('');
      userCubit.setSessionId('');
    }
  }


  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final userService = sl.get<UserService>();

    context.read<SearchCubit>().updateQuery('');
    var uid = FirebaseAuth.instance.currentUser!.uid;
    RevenuCatAPI().initPlatformState(uid,userCubit.state.vendorType).then((value) {
      if(['ind_starter_v1', 'ind_starter_v2', 'ind_growth_v2', 'ind_growth__v1']
          .contains(AppData().entitlement)){
        syncUserSubscriptionStatus(userService, userCubit,AppData().entitlementIsActive, SubscriptionType.individual.name,AppData().entitlement);
      }else{
        syncUserSubscriptionStatus(userService, userCubit,AppData().entitlementIsActive, SubscriptionType.agency.name,AppData().entitlement);

      }
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          SizedBox(
            height: 30,
            width: 50,
            child: FittedBox(
              child: BlocBuilder<ProfileStatusCubit, bool>(
                builder: (context, state) {
                  return Switch(
                    value: state,
                    activeColor: const Color(0xff4BC551),
                    onChanged: (bool value) {
                      final profileCubit = context.read<ProfileStatusCubit>();
                      final userCubit = context.read<UserCubit>();

                      if (state) {
                        profileCubit.goOffline();
                        userCubit.setIsOnline(false);
                      } else {
                        profileCubit.goOnline();
                        userCubit.setIsOnline(true);
                      }
                    },
                  );
                },
              ),
            ),
          ),
          BlocBuilder<ProfileStatusCubit, bool>(
            builder: (context, state) {
              return Text(
                state ? LocaleKeys.online.tr() : LocaleKeys.offline.tr(),
                style: const TextStyle(
                  // fontFamily: RIFTSOFT,
                  fontSize: 18,
                ),
              );
            },
          ),
          const SizedBox(width: 20,),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  child: context.read<UserCubit>().state.userImage.isEmpty
                      ? const Icon(
                    Icons.image_outlined,
                    color: AppColors.whiteColor,
                  )
                      : ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: context.read<UserCubit>().state.userImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    // child: Image.network(
                    //   context.read<UserCubit>().state.userImage,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  '${LocaleKeys.hello.tr()} ${context.read<UserCubit>().state.userName.capitalizeEachFirstLetter()}!',
                  textAlign: TextAlign.center,
                  style: context.currentTextTheme.titleMedium
                      ?.copyWith(fontSize: 20, color: AppColors.primaryFontColor),
                ),
                const SizedBox(
                  height: 2,
                ),
                const CategoryWidget(),
                const SizedBox(
                  height: 8,
                ),
                const ManageVendorLocations(),
                const SizedBox(
                  height: 16,
                ),
                SearchField(
                  hintText: LocaleKeys.searchItemDeal.tr(),
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  onChanged: (String? value) => _searchQuery(context, value),
                ),
                SizedBox(
                  height: userCubit.state.isEmployee ? 0 : 24,
                ),
                userCubit.state.isEmployee
                    ? const SizedBox.shrink()
                    : const ItemDealsButtons(),
                SizedBox(
                  height: userCubit.state.isEmployee ? 40 : 12,
                ),

                //TODO: Do it with bloc rather than direct use
                const ShowAllItems(),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _searchQuery(BuildContext context, String? value) {
    Future.delayed(const Duration(seconds: 1), () {
      context.read<SearchCubit>().updateQuery(value ?? '');
    });
  }
}