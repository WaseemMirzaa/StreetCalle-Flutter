import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/vendor_deals_widget.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/vendor_items_widget.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/food_search_field.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/favourite_cubit.dart';

class ClientMenuItemDetail extends StatelessWidget {
  const ClientMenuItemDetail({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    String? vendorId = context.select((ClientSelectedVendorCubit cubit) => cubit.state);
    String? userId = context.read<UserCubit>().state.userId;
    context.read<FavoriteCubit>().checkFavoriteStatus(userId, vendorId ?? '');

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                        context.pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios, color: AppColors.blackColor,),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: (){},
                        icon: Image.asset(AppAssets.filterIcon, width: 24, height: 24,),
                    ),
                    IconButton(
                        onPressed: (){},
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
                        child: user.image == null
                            ? CircleAvatar(
                          backgroundImage: Image.asset(AppAssets.teaImage, fit: BoxFit.cover).image,
                        )
                            : ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: user.image!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            )
                    ),
                    const SizedBox(width: 12,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.name}',
                            style: const TextStyle(
                                fontSize: 24,
                                fontFamily: METROPOLIS_BOLD,
                                color: AppColors.primaryFontColor
                            ),
                          ),
                          const SizedBox(height: 6,),
                          BlocBuilder<FavoriteCubit, FavoriteStatus>(
                            builder: (context, state) {
                              switch (state) {
                                case FavoriteStatus.loading:
                                  return const CircularProgressIndicator(); // Display a loading indicator.
                                case FavoriteStatus.isFavorite:
                                  return const Icon(
                                    Icons.favorite_outlined,
                                    color: AppColors.redColor,
                                  );
                                case FavoriteStatus.isNotFavorite:
                                  return const Icon(
                                    Icons.favorite_border_rounded,
                                  );
                                default:
                                  return const SizedBox(); // Handle other states as needed.
                              }
                            },
                          ),
                          // FutureBuilder(
                          //     future: userService.isVendorInFavorites(userId ?? '', clientVendorId ?? ''),
                          //     builder: (context, snapshot) {
                          //       if (snapshot.connectionState == ConnectionState.waiting) {
                          //         return const Icon(
                          //             Icons.favorite_border_rounded
                          //         );
                          //       }
                          //       if (snapshot.hasData) {
                          //         return const Icon(
                          //             Icons.favorite_outlined, color: AppColors.redColor,
                          //         );
                          //       }
                          //       return const Icon(
                          //           Icons.favorite_border_rounded
                          //       );
                          //     }
                          // ),
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
              const VendorDealsWidget(),

              const SizedBox(
                height: 24,
              ),
              const FoodSearchField(),

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
              const VendorItemsWidget(),
            ],
          ),
        ],
      ),
    );
  }
}