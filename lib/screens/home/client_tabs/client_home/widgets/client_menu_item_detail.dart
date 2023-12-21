import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide StringExtension;
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/vendor_deals_widget.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/vendor_items_widget.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/widgets/search_field.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/favourite_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/filter_bottom_sheet.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/widgets/show_favourite_item_widget.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/screens/home/client_tabs/client_favourites/cubit/favourite_list_cubit.dart';

class ClientMenuItemDetail extends StatefulWidget {
  const ClientMenuItemDetail({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<ClientMenuItemDetail> createState() => _ClientMenuItemDetailState();
}

class _ClientMenuItemDetailState extends State<ClientMenuItemDetail> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String? userId = context.read<UserCubit>().state.userId;
    context.read<FavoriteCubit>().checkFavoriteStatus(userId, widget.user.uid ?? '');
    context.read<FoodSearchCubit>().updateQuery('');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.backgroundImage, fit: BoxFit.fill,),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 34,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        ContextExtensions(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios, color: AppColors.blackColor,),
                    ),
                    const Spacer(),
                    // IconButton(
                    //   onPressed: (){},
                    //     //onPressed: ()=> _filterBottomSheet(context),
                    //     icon: Image.asset(AppAssets.filterIcon, width: 24, height: 24,),
                    // ),
                    IconButton(
                        onPressed: (){
                          context.pushNamed(AppRoutingName.clientVendorDirection);
                        },
                        icon: Image.asset(AppAssets.marker, width: 24, height: 24,),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 54.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(4), // Border width
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle, // Uncomment this line
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primaryColor,
                              AppColors.primaryLightColor,
                            ],
                          ),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: widget.user.isVendor ? widget.user.image! : widget.user.employeeOwnerImage!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                    ),
                    const SizedBox(width: 12,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.isVendor ? widget.user.name.capitalizeEachFirstLetter() : widget.user.employeeOwnerName.capitalizeEachFirstLetter(),
                            style: const TextStyle(
                                fontSize: 24,
                                fontFamily: METROPOLIS_BOLD,
                                color: AppColors.primaryFontColor
                            ),
                          ),
                          const SizedBox(height: 6,),
                          Row(
                            children: [
                              ShowFavouriteItemWidget(
                                onTap: (){
                                  _favouriteItem(userId, widget.user.uid ?? '', context);
                                },
                              ),
                              const SizedBox(width: 6,),
                              Chip(
                                avatar: widget.user.categoryImage.isEmptyOrNull
                                    ? const SizedBox.shrink()
                                    : Image.network(
                                  widget.user.categoryImage!,
                                  fit: BoxFit.cover,
                                ),
                                label: Text(widget.user.category ?? '', style: context.currentTextTheme.displaySmall,),
                                backgroundColor: AppColors.greyColor,
                                side: BorderSide.none,
                                shape: const StadiumBorder(),
                              )
                            ],
                          ),
                          InkWell(
                            onTap: (){
                              context.pushNamed(AppRoutingName.clientVendorProfile, extra: widget.user.uid ?? '');
                            },
                            child: Text(
                              TempLanguage().lblViewProfile,
                              style: context.textTheme.displaySmall?.copyWith(color: AppColors.primaryColor, decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      TempLanguage().lblDeals,
                      style: context.currentTextTheme.labelMedium?.copyWith(fontSize: 16),
                    ),

                    InkWell(
                      onTap: (){
                        context.pushNamed(AppRoutingName.viewAllDeals);
                      },
                      child: Text(
                        TempLanguage().lblViewAll,
                        style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 12,
              ),
              VendorDealsWidget(user: widget.user),

              const SizedBox(
                height: 24,
              ),
              SearchField(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                hintText: TempLanguage().lblSearchFood,
                onChanged: (String? value) => _searchQuery(context, value),
              ),

              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      TempLanguage().lblItems,
                      style: context.currentTextTheme.labelMedium?.copyWith(fontSize: 16),
                    ),

                    InkWell(
                      onTap: (){
                        context.pushNamed(AppRoutingName.viewAllItems);
                      },
                      child: Text(
                        TempLanguage().lblViewAll,
                        style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 16, color: AppColors.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              VendorItemsWidget(user: widget.user),
            ],
          ),
        ],
      ),
    );
  }

  void _filterBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return const FilterBottomSheet();
      },
    );
  }

  void _favouriteItem(String userId, String vendorId, BuildContext context) {
    final userService = sl.get<UserService>();
    final favouriteCubit = context.read<FavoriteCubit>();
    final isFavourite = favouriteCubit.state == FavoriteStatus.isFavorite;
    if (isFavourite) {
      context.read<FavouriteListCubit>().removeUser(vendorId);
    }

    favouriteCubit.updateFavouriteStatue(!isFavourite);
    userService.updateFavourites(vendorId, userId, !isFavourite);
  }

  void _searchQuery(BuildContext context, String? value) {
    Future.delayed(const Duration(seconds: 1), () {
      context.read<FoodSearchCubit>().updateQuery(value ?? '');
    });
  }
}