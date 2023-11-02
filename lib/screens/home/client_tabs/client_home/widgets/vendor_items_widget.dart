import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/filter_food_cubit.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/widgets/no_data_found_widget.dart';
import 'package:street_calle/models/user.dart';

class VendorItemsWidget extends StatelessWidget {
  VendorItemsWidget({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    final itemService = sl.get<ItemService>();
    //String? clientVendorId = context.select((ClientSelectedVendorCubit cubit) => cubit.state);


    return Expanded(
      child: Stack(
        children: [
          Container(
            width: 100,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(60), bottomRight: Radius.circular(60)),
                color: AppColors.primaryColor
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: StreamBuilder<List<Item>>(
              stream: user.isVendor ? itemService.getItems(user.uid ?? '') : itemService.getEmployeeItems(user.employeeItemsList),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryColor,),
                  );
                }
                if (snapshot.hasData && snapshot.data != null) {
                  if (snapshot.data!.isEmpty) {
                    return const NoDataFoundWidget();
                  }
                  return BlocBuilder<FoodSearchCubit, String>(
                    builder: (context, state) {

                      List<Item> list = [];
                      if (state.isNotEmpty) {
                        list = snapshot.data!.where((item) {
                          final itemName = item.title!.toLowerCase();
                          return itemName.contains(state.toLowerCase());
                        }).toList();
                      } else {
                        list = snapshot.data!;
                      }
                      context.read<ItemList>().addItems(list);

                      return list.isEmpty
                          ? const NoDataFoundWidget()
                          : BlocBuilder<FilterFoodCubit, List<Item>>(
                            builder: (context, filteredList) {
                              List<Item> items = [];
                              filteredList.isEmpty ? items = list : items = filteredList;

                            return ListView.builder(
                            itemCount: items.length,
                            //padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final item = items[index];

                              return InkWell(
                                onTap: () {
                                  context.pushNamed(AppRoutingName.itemDetail, extra: item, pathParameters: {IS_CLIENT: true.toString()});
                                },
                                child: ItemWidget(item: item),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
                return const NoDataFoundWidget();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 44.0, right: 14),
            child: Container(
              height: 100,
              width: context.width,
              padding: const EdgeInsets.only(left: 44.0, right: 14),
              decoration:  BoxDecoration(
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withOpacity(0.25),
                    spreadRadius: 2, // Spread radius
                    blurRadius: 15, // Blur radius
                    offset: const Offset(0, 8), // Offset in the Y direction
                  ),
                ],
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(height: 4,),
                        Text(
                          '${item.title}',
                          style: context.currentTextTheme.labelMedium?.copyWith(color: AppColors.primaryFontColor),
                        ),
                        item.description == null ? const SizedBox.shrink() : Text(
                          '${item.description}',
                          style: context.currentTextTheme.displaySmall,
                        ),
                        item.foodType == null ? const SizedBox.shrink() : Text(
                          '${item.foodType}',
                          style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Text(
                      '\$${item.actualPrice}',
                      style: context.currentTextTheme.labelMedium?.copyWith(color: AppColors.primaryFontColor),
                    ),
                  ),
                  const SizedBox(width: 24,),
                ],
              ),
            ),
          ),
          ItemImage(item: item),
          const ForwardArrow(),
        ],
      ),
    );
  }
}

class ItemImage extends StatelessWidget {
  const ItemImage({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      left: 0,
      child: Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          // image: DecorationImage(
          //   image: AssetImage(AppAssets.customTriangle)
          // )
        ),
        clipBehavior: Clip.hardEdge,
        child: item.image == null
            ? Image.asset(AppAssets.teaImage, width: 50, height: 50, fit: BoxFit.cover,)
            : CachedNetworkImage(
          imageUrl: item.image!,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}

class ForwardArrow extends StatelessWidget {
  const ForwardArrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 28,
      right: 0,
      child: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.25),
                spreadRadius: 1, // Spread radius
                blurRadius: 10, // Blur radius
                offset: const Offset(0, 0), // Offset in the Y direction
              ),
            ],
          ),
          child: const Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor,)
      ),
    );
  }
}