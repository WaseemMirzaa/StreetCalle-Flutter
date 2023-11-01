import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/item_widget.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

class ViewAllItems extends StatelessWidget {
  const ViewAllItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemService = sl.get<ItemService>();
    String? clientVendorId = context.select((ClientSelectedVendorCubit cubit) => cubit.state);
    context.read<AllItemsSearchCubit>().updateQuery('');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          TempLanguage().lblItems,
          style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(AppAssets.backIcon, width: 20, height: 20,)
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withOpacity(0.25),
                    spreadRadius: 3, // Spread radius
                    blurRadius: 15, // Blur radius
                    offset: const Offset(0, 0), // Offset in the Y direction
                  ),
                ],
              ),
              child: TextField(
                textAlign: TextAlign.center,
                onChanged: (String? value) => _searchQuery(context, value),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  filled: true,
                  prefixIcon: Container(
                      margin: const EdgeInsets.only(left: 8),
                      decoration: const BoxDecoration(
                          color: AppColors.primaryLightColor,
                          shape: BoxShape.circle
                      ),
                      child: const Icon(Icons.search, color: AppColors.hintColor,)),
                  hintStyle: context.currentTextTheme.displaySmall,
                  hintText: TempLanguage().lblSearchItems,
                  fillColor: AppColors.whiteColor,
                  border: clientSearchBorder,
                  focusedBorder: clientSearchBorder,
                  disabledBorder: clientSearchBorder,
                  enabledBorder: clientSearchBorder,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: FutureBuilder<List<Item>>(
                future: itemService.getMenuItems(clientVendorId ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primaryColor,),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        TempLanguage().lblSomethingWentWrong,
                        style: context.currentTextTheme.displaySmall,
                      ),
                    );
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          TempLanguage().lblNoDataFound,
                          style: context.currentTextTheme.displaySmall,
                        ),
                      );
                    }
                    return BlocBuilder<AllItemsSearchCubit, String>(
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

                        return list.isEmpty
                            ? Center(
                          child: Text(
                            TempLanguage().lblNoDataFound,
                            style: context.currentTextTheme.displaySmall,
                          ),
                        )
                            : ListView.builder(
                          itemCount: list.length,
                          //padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final item = list[index];

                            return ItemWidget(
                              item: item,
                              onTap: (){
                                context.pushNamed(AppRoutingName.itemDetail, extra: item, pathParameters: {IS_CLIENT: true.toString()});
                              },
                              onUpdate: (){},
                              onDelete: (){},
                              isFromItemTab: false,
                            );
                          },
                        );
                      },
                    );
                  }
                  return Center(
                    child: Text(
                      TempLanguage().lblSomethingWentWrong,
                      style: context.currentTextTheme.displaySmall,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _searchQuery(BuildContext context, String? value) {
    context.read<AllItemsSearchCubit>().updateQuery(value ?? '');
  }
}
