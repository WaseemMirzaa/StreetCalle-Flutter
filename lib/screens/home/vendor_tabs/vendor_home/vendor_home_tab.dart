import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_item_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/item/show_all_items.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/app_enum.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/utils/my_sizer.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_drop_down_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/pricing_category_expanded_cubit.dart';
import 'package:street_calle/screens/home/profile/cubit/profile_status_cubit.dart';
import 'package:street_calle/widgets/search_field.dart';

class VendorHomeTab extends StatelessWidget {
  const VendorHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    context.read<SearchCubit>().updateQuery('');
    MySizer().init(context);

    return Scaffold(
      appBar: AppBar(
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
                state ? TempLanguage().lblOnline : TempLanguage().lblOffline,
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
      body: Column(
        children: [
          // const SizedBox(
          //   height: 10,
          // ),
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
            '${TempLanguage().lblHello} ${context.read<UserCubit>().state.userName.capitalizeEachFirstLetter()}!',
            textAlign: TextAlign.center,
            style: context.currentTextTheme.titleMedium
                ?.copyWith(fontSize: 20, color: AppColors.primaryFontColor),
          ),
          const SizedBox(
            height: 16,
          ),

          BlocSelector<UserCubit, UserState, String>(
            selector: (userState) => userState.vendorType,
            builder: (context, state) {
              return (state.isEmpty ||
                      state.toLowerCase() == VendorType.individual.name)
                  ? const SizedBox.shrink()
                  : InkWell(
                      onTap: () {
                       // var id =  context.read<UserCubit>().state.userId;
                       //  debugPrint('Print $id');
                        if (userCubit.state.isSubscribed && userCubit.state.subscriptionType.toLowerCase() == SubscriptionType.agency.name.toLowerCase()) {
                          context.pushNamed(AppRoutingName.manageEmployee);
                        } else {
                          showToast(context, TempLanguage().lblPleaseSubscribedAgencyFirst);
                        }
                      },
                      child: Text(
                        TempLanguage().lblManageEmployees,
                        style: context.currentTextTheme.titleMedium?.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 24,
                            decoration: TextDecoration.underline),
                      ),
                    );
            },
          ),

          const SizedBox(
            height: 16,
          ),
          SearchField(
            hintText: TempLanguage().lblSearchItemDeal,
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            onChanged: (String? value) => _searchQuery(context, value),
          ),
          SizedBox(
            height: userCubit.state.isEmployee ? 0 : 24,
          ),
          userCubit.state.isEmployee
              ? const SizedBox.shrink()
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: defaultButtonSize,
                    child: AppButton(
                      elevation: 0.0,
                      onTap: () {
                        if (userCubit.state.isSubscribed) {
                          _addItem(context);
                        } else {
                          showToast(context, TempLanguage().lblPleaseSubscribedFirst);
                        }
                      },
                      shapeBorder: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.circular(30)),
                      textStyle: context.currentTextTheme.labelLarge
                          ?.copyWith(color: AppColors.whiteColor),
                      color: AppColors.primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.add,
                            width: MySizer.size15,
                            height: MySizer.size15,
                          ),
                          SizedBox(
                            width: MySizer.size16,
                          ),
                          Text(
                            TempLanguage().lblAddItem,
                            style: context.currentTextTheme.labelLarge
                                ?.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: MySizer.size16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: SizedBox(
                    height: defaultButtonSize,
                    child: AppButton(
                      elevation: 0.0,
                      onTap: () {
                        if (userCubit.state.isSubscribed) {
                          _addDeal(context);
                        } else {
                          showToast(context, TempLanguage().lblPleaseSubscribedFirst);
                        }
                      },
                      shapeBorder: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.circular(30)),
                      textStyle: context.currentTextTheme.labelLarge
                          ?.copyWith(color: AppColors.whiteColor),
                      color: AppColors.primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.add,
                            width: MySizer.size15,
                            height: MySizer.size15,
                          ),
                          SizedBox(
                            width: MySizer.size16,
                          ),
                          Text(
                            TempLanguage().lblAddDeal,
                            style: context.currentTextTheme.labelLarge
                                ?.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: MySizer.size16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: userCubit.state.isEmployee ? 40 : 12,
          ),

          //TODO: Do it with bloc rather than direct use
          const ShowAllItems(),
        ],
      ),
    );
  }

  void _searchQuery(BuildContext context, String? value) {
    context.read<SearchCubit>().updateQuery(value ?? '');
  }

  void _addDeal(BuildContext context) {
    context.read<FoodTypeCubit>().loadFromFirebase();
    _resetCubitStates(context);

    final addDealCubit = context.read<AddDealCubit>();
    addDealCubit.clearControllers();

    context.pushNamed(AppRoutingName.addDeal, pathParameters: {
      IS_UPDATE: false.toString(),
      IS_FROM_DETAIL: false.toString()
    });
  }

  void _addItem(BuildContext context) {
    _resetCubitStates(context);

    final pricingCubit = context.read<PricingCategoryCubit>();
    final pricingExpandedCubit = context.read<PricingCategoryExpandedCubit>();
    final addItemCubit = context.read<AddItemCubit>();
    final foodTypeCubit = context.read<FoodTypeCubit>();

    foodTypeCubit.loadFromFirebase();
    pricingExpandedCubit.collapse();
    pricingCubit.setCategoryType(PricingCategoryType.none);
    addItemCubit.clear();

    context.pushNamed(AppRoutingName.addItem, pathParameters: {
      IS_UPDATE: false.toString(),
      IS_FROM_DETAIL: false.toString()
    });
  }

  void _resetCubitStates(BuildContext context) {
    final imageCubit = context.read<ImageCubit>();
    final foodTypeExpandedCubit = context.read<FoodTypeExpandedCubit>();
    final foodTypeDropDownCubit = context.read<FoodTypeDropDownCubit>();
    final foodTypeCubit = context.read<FoodTypeCubit>();

    imageCubit.resetImage();
    foodTypeExpandedCubit.collapse();
    foodTypeDropDownCubit.resetState();
    foodTypeCubit.defaultValue = TempLanguage().lblSelect;
    foodTypeCubit.loadFromFirebase();
  }
}
