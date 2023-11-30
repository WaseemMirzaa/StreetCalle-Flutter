import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/current_location_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/filter_cubit.dart';
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
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/apply_filter_cubit.dart';

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
        Expanded(
          child: localDeals.state.isNotEmpty
              ? FilteredWidget(usersList: localDeals.state.values.toList(), dealsList: localDeals.state.keys.toList(), userDeals: localDeals.state)
              : FutureBuilder<Map<Deal, User>>(
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

            context.read<DealList>().resetDeals();
            context.read<DealUserList>().resetUsers();
            context.read<DealList>().addDeals(deals);
            context.read<DealUserList>().addUsers(users);

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
    return BlocBuilder<SearchDealsCubit, String>(
      builder: (context, state) {

        List<Deal> deals = [];
        List<User> users = [];

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

        } else {
          deals = dealsList;
          users = usersList;
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
                  context.pushNamed(AppRoutingName.dealDetail, extra: deal, pathParameters: {IS_CLIENT: true.toString()});
                },
                onDelete: (){},
                onUpdate: (){},
              );
            },
          ),
        );
      },
    );
  }
}