import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/screens/auth/cubit/image/image_cubit.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_expanded_cubit.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/add_deal_cubit.dart';

class DealDetail extends StatefulWidget {
  const DealDetail({Key? key, required this.deal}) : super(key: key);
  final Deal deal;

  @override
  State<DealDetail> createState() => _DealDetailState();
}

class _DealDetailState extends State<DealDetail> {
  late Deal deal;

  @override
  void initState() {
    super.initState();
    deal = widget.deal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Stack(
          children: [
            SizedBox(
              height: 250,
              width: context.width,
              child: deal.image.isEmptyOrNull
                  ? Image.asset(AppAssets.camera, fit: BoxFit.cover,)
                  : Image.network(deal.image!, fit: BoxFit.cover,),
            ),

            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.5), Colors.white.withOpacity(0.0)],
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height - 220,
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0, top: 24.0, right: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deal.title ?? '',
                        style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor),
                      ),
                      Text(
                        deal.foodType ?? '',
                        style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child:  (deal.discountedPrice != null && deal.discountedPrice != defaultPrice)
                            ? Column(
                          children: [
                            Text(
                              '\$${calculateDiscountAmount(deal.actualPrice, deal.discountedPrice)}',
                              style: context.currentTextTheme.titleMedium,
                            ),
                            Text(
                              '\$${deal.actualPrice}',
                              style: context.currentTextTheme.titleMedium?.copyWith(
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: AppColors.redColor,
                                  decorationThickness: 4.0
                              ),
                            ),
                          ],
                        )
                            : Text(
                          '\$${deal.actualPrice}',
                          style: context.currentTextTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      deal.description.isEmptyOrNull
                          ? const SizedBox.shrink()
                          : const Text(
                        'Description',
                        style: TextStyle(
                            fontFamily: METROPOLIS_BOLD,
                            fontSize: 14, color: AppColors.primaryFontColor, fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      deal.description.isEmptyOrNull
                          ? const SizedBox.shrink()
                          : Text(
                        deal.description ?? '',
                        style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.secondaryFontColor, fontSize: 12),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      deal.description.isEmptyOrNull
                          ? const SizedBox.shrink()
                          : const Divider(color: AppColors.dividerColor,),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 190,
              right: 15,
              child: InkWell(
                onTap: () => _onUpdate(context, deal),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.asset(AppAssets.whiteIconImage).image,
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(AppAssets.edit, width: 25, height: 25,)
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 40,
              left: 15,
              child: GestureDetector(
                onTap: (){
                  context.pop();
                },
                child: Image.asset(AppAssets.backIcon, color: AppColors.whiteColor, width: 24, height: 24,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onUpdate(BuildContext context, Deal dealParam) async {
    final imageCubit =  context.read<ImageCubit>();
    final dealCubit = context.read<AddDealCubit>();
    final foodTypeExpandedCubit = context.read<FoodTypeExpandedCubit>();
    final foodTypeCubit = context.read<FoodTypeCubit>();

    foodTypeCubit.loadFromFirebase();
    dealCubit.titleController.text = dealParam.title ?? '';
    dealCubit.descriptionController.text = dealParam.description ?? '';
    dealCubit.foodTypeController.text = dealParam.foodType ?? '';
    dealCubit.actualPriceController.text = dealParam.actualPrice.toString() ?? '';
    dealCubit.discountedPriceController.text = dealParam.discountedPrice.toString() ?? '';
    dealCubit.id = dealParam.id ?? '';
    dealCubit.createdAt = dealParam.createdAt ?? Timestamp.now();

    if (dealCubit.foodTypeController.text.isNotEmpty) {
      foodTypeExpandedCubit.expand();
      foodTypeCubit.addString(dealCubit.foodTypeController.text);
      foodTypeCubit.defaultValue = dealCubit.foodTypeController.text;
    } else {
      foodTypeExpandedCubit.collapse();
      foodTypeCubit.defaultValue = TempLanguage().lblSelect;
    }

    imageCubit.resetForUpdateImage(dealParam.image ?? '',);
    final result = await context.pushNamed(AppRoutingName.addDeal, pathParameters: {IS_UPDATE: true.toString(), IS_FROM_DETAIL: true.toString()});
    if(result != null) {
      setState(() {
        deal = result as Deal;
      });
    }
  }
}