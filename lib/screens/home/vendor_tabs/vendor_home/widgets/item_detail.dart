import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';

class ItemDetail extends StatelessWidget {
  const ItemDetail({Key? key, required this.item}) : super(key: key);
  final Item item;

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
              child: item.image.isEmptyOrNull ? Image.asset(AppAssets.camera, fit: BoxFit.cover,) : Image.network(item.image!, fit: BoxFit.cover,),
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
                        item.title ?? '',
                        style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor),
                      ),
                      Text(
                        item.foodType ?? '',
                        style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '\$${item.actualPrice}',
                          style: context.currentTextTheme.titleMedium,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '/per item',
                          style: context.currentTextTheme.displaySmall,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      item.description.isEmptyOrNull
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
                      item.description.isEmptyOrNull
                          ? const SizedBox.shrink()
                          : Text(
                        item.description ?? '',
                        style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.secondaryFontColor, fontSize: 12),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      item.description.isEmptyOrNull
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

            Positioned(
              top: 60,
              left: 15,
              child: GestureDetector(
                onTap: (){
                  context.pop();
                },
                child: Image.asset(AppAssets.backIcon, color: AppColors.whiteColor, width: 18, height: 18,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
