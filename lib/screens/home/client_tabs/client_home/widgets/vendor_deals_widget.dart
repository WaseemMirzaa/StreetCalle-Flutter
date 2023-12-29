import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/models/user.dart';

class VendorDealsWidget extends StatelessWidget {
  VendorDealsWidget({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: AppColors.containerBackgroundColor.withOpacity(0.9), // Adjust opacity for the glass effect
        ),
        child: FirestoreListView<Deal>(
          query: user.isVendor
              ? dealQuery.where(DealKey.UID, isEqualTo: user.uid ?? '').orderBy(DealKey.UPDATED_AT, descending: true)
              : dealQuery.where(FieldPath.documentId, whereIn: user.employeeItemsList),
          pageSize: DEAL_PER_PAGE,
          scrollDirection: Axis.horizontal,
          emptyBuilder: (context) => Center(child: Text(TempLanguage().lblNoDataFound)),
          errorBuilder: (context, error, stackTrace) => Center(child: Text(TempLanguage().lblSomethingWentWrong)),
          loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
          itemBuilder: (context, deal) {
            return InkWell(
              onTap: () {
                context.pushNamed(AppRoutingName.dealDetail, extra: deal.data(), pathParameters: {IS_CLIENT: true.toString()});
              },
              child: Container(
                  margin: const EdgeInsets.only(left: 4),
                  width: 80,
                  height: 60,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor
                  ),
                  child: deal.data().image == null
                      ? const Icon(
                    Icons.image_outlined,
                    color: AppColors.whiteColor,
                  )
                      : ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: deal.data().image!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  )
              ),
            );
          },
        ),
      ),
    );
  }
}