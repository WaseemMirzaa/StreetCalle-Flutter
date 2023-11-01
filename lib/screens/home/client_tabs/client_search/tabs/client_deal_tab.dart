import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/widgets/no_data_found_widget.dart';
import 'package:street_calle/services/deal_service.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/deal_widget.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

class ClientDealTab extends StatelessWidget {
  const ClientDealTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dealService = sl.get<DealService>();
    context.read<SearchDealsCubit>().updateQuery('');

    return Column(
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
                hintText: TempLanguage().lblSearchDeals,
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
          child: StreamBuilder<List<Deal>>(
            stream: dealService.getAllDeals(),
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

                return BlocBuilder<SearchDealsCubit, String>(
                  builder: (context, state) {

                    List<Deal> list = [];
                    if (state.isNotEmpty) {
                      list = snapshot.data!.where((deal) {
                        final dealName = deal.title!.toLowerCase();
                        return dealName.contains(state.toLowerCase());
                      }).toList();
                    } else {
                      list = snapshot.data!;
                    }

                    return list.isEmpty
                        ? const NoDataFoundWidget()
                        : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final deal = list[index];

                          return DealWidget(
                            isFromClient: true,
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
