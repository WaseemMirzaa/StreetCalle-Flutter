import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/current_location_cubit.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/widgets/no_data_found_widget.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/item_widget.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/widgets/search_field.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/cubit/filter_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/cubit/apply_filter_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';

class ClientItemTab extends StatelessWidget {
  const ClientItemTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemService = sl.get<ItemService>();
    final currentLocationCubit = context.read<CurrentLocationCubit>();
    final localItems = context.read<LocalItemsStorage>();
    final searchItemCubit = context.read<SearchItemsCubit>();
    searchItemCubit.updateQuery('');

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
          // child: localItems.state.isNotEmpty
          //     ? FilteredWidget(usersList: localItems.state.values.toList(), itemList: localItems.state.keys.toList(), userItems: localItems.state)
          //     :
          child: FutureBuilder<Map<Item, User>>(
            future: itemService.getNearestItemsWithUsers(currentLocationCubit),
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

                localItems.addLocalItems(snapshot.data!);
                List<Item> itemList = snapshot.data!.keys.toList();
                List<User> usersList = snapshot.data!.values.toList();

                return FilteredWidget(usersList: usersList, itemList: itemList, userItems: snapshot.data!);
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


class FilteredWidget extends StatelessWidget {
  const FilteredWidget({Key? key, required this.usersList, required this.itemList, required this.userItems}) : super(key: key);
  final List<User> usersList;
  final List<Item> itemList;
  final Map<Item, User> userItems;


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplyFilterCubit, bool>(
      builder: (context, isApplied) {
        return BlocBuilder<FilterItemsCubit, List<Item>>(
            builder: (context, filteredList) {
              List<Item> items = [];
              List<User> users = [];

              items = isApplied ? (filteredList.isEmpty ? [] : filteredList) : itemList;

              users = isApplied
                  ? (filteredList.isEmpty ? [] : items.map((item) => userItems[item]!).toList())
                  : usersList;

              Map<Item, User> itemUserMap = Map.fromIterables(items, users);
              context.read<RemoteUserItems>().resetRemoteUserItems();
              context.read<RemoteUserItems>().addRemoteUserItems(itemUserMap);

              return items.isEmpty
                  ? const NoDataFoundWidget()
                  : ItemsWidget(itemsList: items, usersList: users,);
            }
        );
      },
    );
  }
}

class ItemsWidget extends StatelessWidget {
  const ItemsWidget({Key? key, required this.itemsList, required this.usersList}) : super(key: key);
  final  List<Item> itemsList;
  final  List<User> usersList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchItemsCubit, String>(
      builder: (context, state){
        List<Item> items = [];
        List<User> users = [];

        if (state.isNotEmpty) {
          items = itemsList.where((item) {
            final itemName = item.title!.toLowerCase();
            return itemName.contains(state.toLowerCase());
          }).toList();

          List<int> filteredItemsIndexes = [];
          for (int i = 0; i < items.length; i++) {
            int index = itemsList.indexOf(items[i]);
            filteredItemsIndexes.add(index);
          }
          for (int index in filteredItemsIndexes) {
            if (index > -1) {
              users.add(usersList[index]);
            }
          }

        } else {
          items = itemsList;
          users = usersList;
        }

        return items.isEmpty
            ? const NoDataFoundWidget()
            : Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final user = users[index];

              return ItemWidget(
                isFromItemTab: false,
                isLastIndex: (index == (items.length - 1)),
                item: item,
                user: user,
                onTap: (){
                  //context.pushNamed(AppRoutingName.itemDetail, extra: item, pathParameters: {IS_CLIENT: true.toString()});
                  context.read<ClientSelectedVendorCubit>().selectedVendorId(user.uid);
                  context.pushNamed(AppRoutingName.clientMenuItemDetail, extra: user);
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
}