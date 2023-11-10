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
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/widgets/search_field.dart';

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
          SearchField(
            hintText: TempLanguage().lblSearchItems,
            padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
            onChanged: (String? value) => _searchQuery(context, value),
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
