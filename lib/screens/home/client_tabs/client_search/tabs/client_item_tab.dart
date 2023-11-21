import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/widgets/no_data_found_widget.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/item_widget.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/widgets/search_field.dart';

class ClientItemTab extends StatelessWidget {
  const ClientItemTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemService = sl.get<ItemService>();
    context.read<SearchItemsCubit>().updateQuery('');
    itemService.getNearestItems();
    return Column(
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
          child: FutureBuilder<List<Item>>(
            future: itemService.getNearestItems(),
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
                return BlocBuilder<SearchItemsCubit, String>(
                  builder: (context, state){
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
                        ?  const NoDataFoundWidget()
                        :  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final item = list[index];

                          return ItemWidget(
                            isFromItemTab: false,
                            item: item,
                            onTap: (){
                              context.pushNamed(AppRoutingName.itemDetail, extra: item, pathParameters: {IS_CLIENT: true.toString()});
                            },
                            onUpdate: (){},
                            onDelete: (){},
                          );
                        },
                      ),
                    );
                  },
                );
              }
              return const NoDataFoundWidget();
            },
          ),
        ),
      ],
    );
  }

  void _searchQuery(BuildContext context, String? value) {
    context.read<SearchItemsCubit>().updateQuery(value ?? '');
  }
}
