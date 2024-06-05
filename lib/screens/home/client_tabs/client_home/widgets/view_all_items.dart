import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_menu/widgets/item_widget.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/widgets/search_field.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/generated/locale_keys.g.dart';
import 'package:street_calle/main.dart';

class ViewAllItems extends StatelessWidget {
  const ViewAllItems({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    context.read<AllItemsSearchCubit>().updateQuery('');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.items.tr(),
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
            hintText: LocaleKeys.searchItems.tr(),
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
                      ? user.isVendor
                      ? itemQuery.where(ItemKey.UID, isEqualTo: user.uid ?? '').orderBy(ItemKey.UPDATED_AT, descending: true)
                      : itemQuery.where(FieldPath.documentId, whereIn: user.employeeItemsList)
                      : user.isVendor
                      ? itemQuery.where(ItemKey.UID, isEqualTo: user.uid ?? '').where(LANGUAGE == 'es' ? ItemKey.SEARCH_TRANSLATED_PARAM : ItemKey.SEARCH_PARAM, arrayContains: state.toLowerCase())
                      : itemQuery.where(FieldPath.documentId, whereIn: user.employeeItemsList).where(LANGUAGE == 'es' ? ItemKey.SEARCH_TRANSLATED_PARAM : ItemKey.SEARCH_PARAM, arrayContains: state.toLowerCase()),
                  pageSize: ITEM_PER_PAGE,
                  emptyBuilder: (context) => Center(child: Text(LocaleKeys.noDataFound.tr())),
                  errorBuilder: (context, error, stackTrace) => Center(child: Text(LocaleKeys.somethingWentWrong.tr())),
                  loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
                  itemBuilder: (context, item) {
                    return ItemWidget(
                      item: item.data(),
                      onTap: (){
                        context.pushNamed(AppRoutingName.itemDetail, extra: item.data(), pathParameters: {IS_CLIENT: true.toString()});
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