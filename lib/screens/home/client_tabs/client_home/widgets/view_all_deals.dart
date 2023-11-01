import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/deal_widget.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/services/deal_service.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/widgets/no_data_found_widget.dart';

class ViewAllDeals extends StatelessWidget {
  const ViewAllDeals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dealService = sl.get<DealService>();
    String? clientVendorId = context.select((ClientSelectedVendorCubit cubit) => cubit.state);
    context.read<AllDealsSearchCubit>().updateQuery('');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          TempLanguage().lblDeals,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: StreamBuilder<List<Deal>>(
                stream: dealService.getDeals(clientVendorId ?? ''),
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
                    return BlocBuilder<AllDealsSearchCubit, String>(
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
                            : ListView.builder(
                          itemCount: list.length,
                          //padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final deal = list[index];

                            return DealWidget(
                                deal: deal,
                                onTap: (){
                                  context.pushNamed(AppRoutingName.dealDetail, extra: deal, pathParameters: {IS_CLIENT: true.toString()});
                                },
                                onUpdate: (){},
                                onDelete: (){},
                                isFromClient: true,
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
    context.read<AllDealsSearchCubit>().updateQuery(value ?? '');
  }
}
