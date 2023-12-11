import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/employee/location_block_edit_widget.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/employee/employee_detail_header.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/item_widget.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/deal_widget.dart';
import 'package:street_calle/utils/custom_widgets/custom_query_builder.dart';


class EmployeeDetailScreen extends StatefulWidget {
  final User? user;
  const EmployeeDetailScreen({Key? key,this.user}) : super(key: key);

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  AppAssets.backIcon,
                  width: 20,
                  height: 20,
                )
              ],
            ),
          ),
          title: Text(
            TempLanguage().lblLocationDetails,
            style: context.currentTextTheme.titleMedium
                ?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  EmployeeDetailHeader(user: widget.user),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    color: AppColors.dividerColor,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  /// the tab bar with two items
                  SizedBox(
                    height: 50,
                    child: AppBar(
                      bottom: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: context.currentTextTheme.displaySmall,
                        unselectedLabelStyle: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryFontColor),
                        tabs:  [
                          Tab(text: TempLanguage().lblItems),
                          Tab(text: TempLanguage().lblDeals),
                        ],
                      ),
                    ),
                  ),
                  /// create widgets for each tab bar here
                  Expanded(
                    child: TabBarView(
                      children: [
                        /// Items tab bar
                        widget.user?.employeeItemsList?.isNotEmpty ?? false
                            ? CustomFirestoreListView<Item>(
                          query: itemQuery.where(FieldPath.documentId, whereIn: widget.user?.employeeItemsList),
                          pageSize: ITEM_PER_PAGE,
                          emptyBuilder: (context) => Center(child: Text(TempLanguage().lblNoDataFound)),
                          errorBuilder: (context, error, stackTrace) => Center(child: Text(TempLanguage().lblSomethingWentWrong)),
                          loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
                          itemBuilder: (context, item, isLastItem, hasMore) {
                            return ItemWidget(
                              item: item.data(),
                              onTap: (){},
                              onUpdate: (){},
                              onDelete: (){},
                              isFromItemTab: false,
                              isFromVendorLocation: true,
                              isLastIndex: isLastItem,
                            );
                          },
                        )
                            : Center(child: Text(TempLanguage().lblNoDataFound),),

                        /// Deals tab bar
                        widget.user?.employeeDealsList?.isNotEmpty ?? false
                            ? CustomFirestoreListView<Deal>(
                          query: dealQuery.where(FieldPath.documentId, whereIn: widget.user?.employeeDealsList),
                          pageSize: DEAL_PER_PAGE,
                          emptyBuilder: (context) => Center(child: Text(TempLanguage().lblNoDataFound)),
                          errorBuilder: (context, error, stackTrace) => Center(child: Text(TempLanguage().lblSomethingWentWrong)),
                          loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
                          itemBuilder: (context, deal, isLastDeal, hasMore) {
                            return DealWidget(
                              deal: deal.data(),
                              onTap: (){},
                              onUpdate: (){},
                              onDelete: (){},
                              isFromClient: true,
                              isFromVendorLocation: true,
                              isLastIndex: isLastDeal,
                            );
                          },
                        )
                            : Center(child: Text(TempLanguage().lblNoDataFound),),
                      ],
                    ),
                  ),
               ],
              ),
            ),
            LocationBlockEditWidget(user: widget.user,),
          ],
        ),
      ),
    );
  }
}