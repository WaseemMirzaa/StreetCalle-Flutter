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
import 'package:street_calle/models/user.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/filter_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/apply_filter_cubit.dart';

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
          child: FutureBuilder<Map<Item, User>>(
            future: itemService.getNearestItemsWithUsers(),
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

                List<Item> itemList = snapshot.data!.keys.toList();
                List<User> usersList = snapshot.data!.values.toList();

                return BlocBuilder<ApplyFilterCubit, bool>(
                  builder: (context, isApplied) {
                    return BlocBuilder<FilterItemsCubit, List<Item>>(
                        builder: (context, filteredList) {
                          List<Item> items = [];
                          List<User> users = [];

                          (filteredList.isEmpty && !isApplied)
                              ? items = itemList
                              : items = filteredList;

                          if (filteredList.isEmpty && !isApplied) {
                            users = usersList;
                          } else {
                            users = items.map((item) => snapshot.data![item]!).toList();
                          }

                          context.read<ItemList>().resetItems();
                          context.read<ItemUserList>().resetUsers();
                          context.read<ItemList>().addItems(items);
                          context.read<ItemUserList>().addUsers(users);

                          return items.isEmpty
                              ? const NoDataFoundWidget()
                              : FilteredWidget(itemsList: items, usersList: users,);
                        }
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


class FilteredWidget extends StatelessWidget {
  const FilteredWidget({Key? key, required this.itemsList, required this.usersList}) : super(key: key);
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final user = users[index];

              return ItemWidget(
                isFromItemTab: false,
                item: item,
                user: user,
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
}



// class Testing extends StatelessWidget {
//   const Testing({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final itemService = sl.get<ItemService>();
//     context.read<SearchItemsCubit>().updateQuery('');
//     itemService.getNearestItems();
//     return Column(
//       children: [
//         SearchField(
//           hintText: TempLanguage().lblSearchItems,
//           padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
//           onChanged: (String? value) => _searchQuery(context, value),
//         ),
//         const SizedBox(
//           height: 12,
//         ),
//         Expanded(
//           child: FutureBuilder<Map<Item, User>>(
//             future: itemService.getNearestItemsWithUsers(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                   child: CircularProgressIndicator(color: AppColors.primaryColor,),
//                 );
//               }
//               if (snapshot.hasData && snapshot.data != null) {
//                 if (snapshot.data!.isEmpty) {
//                   return const NoDataFoundWidget();
//                 }
//
//                 return Builder(
//                   builder: (context) {
//
//                     final isApplied = context.watch<ApplyFilterCubit>().state;
//                     final filteredList = context.watch<FilterItemsCubit>().state;
//                     final state = context.watch<SearchItemsCubit>().state;
//
//                     List<Item> items = snapshot.data!.keys.toList();
//                     List<User> users = snapshot.data!.values.toList();
//
//                     (filteredList.isEmpty && !isApplied)
//                         ? items = items
//                         : items = filteredList;
//
//                     if (filteredList.isEmpty && !isApplied) {
//                       users = users;
//                     } else {
//                       users = items.map((item) => snapshot.data![item]!).toList();
//                     }
//
//                     context.read<ItemList>().resetItems();
//                     context.read<ItemUserList>().resetUsers();
//                     context.read<ItemList>().addItems(items);
//                     context.read<ItemUserList>().addUsers(users);
//
//                     if (state.isNotEmpty) {
//                       items = items.where((item) {
//                         final itemName = item.title!.toLowerCase();
//                         return itemName.contains(state.toLowerCase());
//                       }).toList();
//
//                       List<int> filteredItemsIndexes = [];
//                       for (int i = 0; i < items.length; i++) {
//                         int index = items.indexOf(items[i]);
//                         filteredItemsIndexes.add(index);
//                       }
//                       for (int index in filteredItemsIndexes) {
//                         if (index > -1) {
//                           users.add(users[index]);
//                         }
//                       }
//
//                     } else {
//                       items = items;
//                       users = users;
//                     }
//
//                     return items.isEmpty
//                         ? const NoDataFoundWidget()
//                         : Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//                       child: ListView.builder(
//                         padding: EdgeInsets.zero,
//                         itemCount: items.length,
//                         itemBuilder: (context, index) {
//                           final item = items[index];
//                           final user = users[index];
//
//                           return ItemWidget(
//                             isFromItemTab: false,
//                             item: item,
//                             user: user,
//                             onTap: (){
//                               context.pushNamed(AppRoutingName.itemDetail, extra: item, pathParameters: {IS_CLIENT: true.toString()});
//                             },
//                             onUpdate: (){},
//                             onDelete: (){},
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 );
//               }
//               return const NoDataFoundWidget();
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _searchQuery(BuildContext context, String? value) {
//     context.read<SearchItemsCubit>().updateQuery(value ?? '');
//   }
// }