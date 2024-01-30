import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/current_location_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/cubit/filter_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/widgets/no_data_found_widget.dart';
import 'package:street_calle/services/deal_service.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/deal_widget.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/widgets/search_field.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/cubit/apply_filter_cubit.dart';
import 'package:street_calle/models/drop_down_item.dart';
import 'package:street_calle/services/category_service.dart';
import 'package:street_calle/screens/selectUser/widgets/drop_down_widget.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/filter_cubit.dart';

class ClientDealTab extends StatelessWidget {
  const ClientDealTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nvPositionCubit = context.read<NavPositionCubit>();
    nvPositionCubit.visitedDealTab();
    final currentLocationCubit = context.read<CurrentLocationCubit>();
    final localDeals = context.read<LocalDealsStorage>();
    final localDealsStorage = context.read<LocalDealsStorage>();
    final dealService = sl.get<DealService>();
    context.read<SearchDealsCubit>().updateQuery('');
    DropDownItem? selectedItem;

    return Column(
      children: [
        SearchField(
          hintText: TempLanguage().lblSearchDeals,
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
          onChanged: (String? value) => _searchQuery(context, value),
        ),
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: FutureBuilder<List<dynamic>?>(
            future: sl.get<CategoryService>().fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
              } else if (snapshot.hasData && snapshot.data != null) {
                List<DropDownItem> category = [];
                snapshot.data?.forEach((element) {
                  final dropDown = DropDownItem(
                      title: element[CategoryKey.TITLE],
                      icon: Image.network(element[CategoryKey.ICON], width: 18, height: 18,),
                      url: element[CategoryKey.ICON]
                  );
                  category.add(dropDown);
                });

                selectedItem = category[0];

                return Container(
                  margin: const EdgeInsets.only(right: 130),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackColor.withOpacity(0.1),
                        spreadRadius: 2, // Spread radius
                        blurRadius: 15, // Blur radius
                        offset: const Offset(0, 0), // Offset in the Y direction
                      ),
                    ],
                  ),
                  child: DropDownWidget(
                    initialValue: selectedItem,
                    items: category,
                    onChanged: (value) {
                      selectedItem = value;
                      context.read<MenuDealFilterCubit>().updateFilter(value?.title ?? '');
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(TempLanguage().lblSomethingWentWrong),
                );
              }
              return Center(
                child: Text(TempLanguage().lblSomethingWentWrong),
              );
            },
          ),
        ),
        Expanded(
          // child: localDeals.state.isNotEmpty
          //     ? FilteredWidget(usersList: localDeals.state.values.toList(), dealsList: localDeals.state.keys.toList(), userDeals: localDeals.state)
          //     :
          child: FutureBuilder<Map<Deal, User>>(
            future: dealService.getNearestDealsWithUsers(currentLocationCubit),
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

                localDealsStorage.addLocalDeals(snapshot.data!);
                List<Deal> dealsList = snapshot.data!.keys.toList();
                List<User> usersList = snapshot.data!.values.toList();

                return FilteredWidget(dealsList: dealsList, userDeals: snapshot.data!, usersList: usersList);
              }
              return const NoDataFoundWidget();
            },
          ),
        ),
      ],
    );
  }

  void _searchQuery(BuildContext context, String? value) {
     context.read<SearchDealsCubit>().updateQuery(value ?? '');
  }
}

class FilteredWidget extends StatelessWidget {
  const FilteredWidget({Key? key, required this.userDeals, required this.usersList, required this.dealsList}) : super(key: key);
  final List<User> usersList;
  final List<Deal> dealsList;
  final Map<Deal, User> userDeals;

  @override
  Widget build(BuildContext context) {
    final applyFilterCubit = context.read<ApplyFilterCubit>();
    return BlocBuilder<ApplyFilterCubit, bool>(
      builder: (context, isApplied){

        if (isApplied) {
          context.read<FilterDealsCubit>().filterDeals(
              applyFilterCubit.minPriceController.text.isEmpty ? 1.0 : double.parse(applyFilterCubit.minPriceController.text),
              applyFilterCubit.maxPriceController.text.isEmpty ? 1000.0 : double.parse(applyFilterCubit.maxPriceController.text),
              context.read<LocalDealsStorage>().state.keys.toList(),
              context.read<LocalDealsStorage>().state.values.toList(),
              applyFilterCubit.distanceController.text.isEmpty ? 10.0 : double.parse(applyFilterCubit.distanceController.text)
          );
        }

        return BlocBuilder<FilterDealsCubit, List<Deal>>(
          builder: (context, filteredList){

            List<Deal> deals = [];
            List<User> users = [];

            deals = isApplied
                ? (filteredList.isEmpty ? [] : filteredList)
                : dealsList;

            users = isApplied
                ? (filteredList.isEmpty ? [] : deals.map((deal) => userDeals[deal]!).toList())
                : usersList;

            Map<Deal, User> dealUserMap = Map.fromIterables(deals, users);
            context.read<RemoteUserDeals>().resetRemoteUserDeals();
            context.read<RemoteUserDeals>().addRemoteUserDeals(dealUserMap);

            return deals.isEmpty
                ? const NoDataFoundWidget()
                : DealsWidget(dealsList: deals, usersList: users);
          },
        );
      },
    );
  }
}

class DealsWidget extends StatelessWidget {
  const DealsWidget({Key? key, required this.dealsList, required this.usersList}) : super(key: key);
  final List<Deal> dealsList;
  final List<User> usersList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuDealFilterCubit, String>(
      builder: (context, filterString) {
        return BlocBuilder<SearchDealsCubit, String>(
          builder: (context, state) {
            List<Deal> deals = [];
            List<User> users = [];

            if (filterString != defaultVendorFilter) {
              deals = dealsList.where((deal) {
                final category = deal.category?.toLowerCase().trim() ?? '';
                return category.contains(filterString.toLowerCase().trim());
              }).toList();

              List<int> filteredItemsIndexes = [];
              for (int i = 0; i < deals.length; i++) {
                int index = dealsList.indexOf(deals[i]);
                filteredItemsIndexes.add(index);
              }
              for (int index in filteredItemsIndexes) {
                if (index > -1) {
                  users.add(usersList[index]);
                }
              }
            } else {
              deals = dealsList;
              users = usersList;
            }

            if (state.isNotEmpty) {
              deals = dealsList.where((deal) {
                final dealName = deal.title!.toLowerCase();
                final dealDescription = deal.description?.toLowerCase() ?? '';
                return dealName.contains(state.toLowerCase()) || dealDescription.contains(state.toLowerCase());
              }).toList();
              //users = deals.map((deal) => snapshot.data![deal]!).toList();

              List<int> filteredItemsIndexes = [];
              for (int i = 0; i < deals.length; i++) {
                int index = dealsList.indexOf(deals[i]);
                filteredItemsIndexes.add(index);
              }
              for (int index in filteredItemsIndexes) {
                if (index > -1) {
                  users.add(usersList[index]);
                }
              }

            }

            return deals.isEmpty
                ? const NoDataFoundWidget()
                : Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: deals.length,
                itemBuilder: (context, index) {
                  final deal = deals[index];
                  final user = users[index];

                  return DealWidget(
                    isFromClient: true,
                    isLastIndex: index == (deals.length - 1),
                    user: user,
                    deal: deal,
                    onTap: (){
                      context.pushNamed(AppRoutingName.clientMenuItemDetail, extra: user);
                    },
                    onDelete: (){},
                    onUpdate: (){},
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}