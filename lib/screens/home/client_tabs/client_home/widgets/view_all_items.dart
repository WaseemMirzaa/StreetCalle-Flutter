import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/item_widget.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/widgets/search_field.dart';

class ViewAllItems extends StatelessWidget {
  const ViewAllItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: BlocBuilder<AllItemsSearchCubit, String>(
               builder: (context, state) {
                return FirestoreListView<Item>(
                  query: state.isEmpty
                      ? itemQuery.where(ItemKey.UID, isEqualTo: clientVendorId ?? '').orderBy(ItemKey.UPDATED_AT, descending: true)
                      : itemQuery.where(ItemKey.UID, isEqualTo: clientVendorId ?? '')
                         .where(ItemKey.SEARCH_PARAM, arrayContains: state),
                  pageSize: ITEM_PER_PAGE,
                  emptyBuilder: (context) => Center(child: Text(TempLanguage().lblNoDataFound)),
                  errorBuilder: (context, error, stackTrace) => Center(child: Text(TempLanguage().lblSomethingWentWrong)),
                  loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
                  itemBuilder: (context, item) {
                    return ItemWidget(
                      item: item.data(),
                      onTap: (){
                        context.pushNamed(AppRoutingName.itemDetail, extra: item, pathParameters: {IS_CLIENT: true.toString()});
                      },
                      onUpdate: (){},
                      onDelete: (){},
                      isFromItemTab: false,
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _searchQuery(BuildContext context, String? value) {
    Future.delayed(const Duration(seconds: 1), () {
      context.read<AllItemsSearchCubit>().updateQuery(value ?? '');
    });
  }
}