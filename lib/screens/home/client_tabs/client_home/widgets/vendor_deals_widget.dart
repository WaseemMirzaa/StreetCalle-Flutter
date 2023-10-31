import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/deal_service.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

class VendorDealsWidget extends StatelessWidget {
  const VendorDealsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dealService = sl.get<DealService>();
    String? clientVendorId = context.select((ClientSelectedVendorCubit cubit) => cubit.state);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: context.width,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: AppColors.containerBackgroundColor.withOpacity(0.9), // Adjust opacity for the glass effect
        ),
        child: StreamBuilder<List<Deal>>(
          stream: dealService.getDeals(clientVendorId ?? ''),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor,),
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
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final deal = snapshot.data![index];

                  return InkWell(
                    onTap: () {
                      context.pushNamed(AppRoutingName.dealDetail, extra: deal, pathParameters: {IS_CLIENT: true.toString()});
                    },
                    child: Container(
                        margin: const EdgeInsets.only(left: 4),
                        width: 80,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor
                        ),
                        child: deal.image == null
                            ? const Icon(
                               Icons.image_outlined,
                               color: AppColors.whiteColor,
                             )
                            : ClipOval(
                             child: CachedNetworkImage(
                            imageUrl: deal.image!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        )
                    ),
                  );
                },
              );
            }
            return Center(
              child: Text(
                TempLanguage().lblNoDataFound,
                style: context.currentTextTheme.displaySmall,
              ),
            );
          },
        ),
      ),
    );
  }
}