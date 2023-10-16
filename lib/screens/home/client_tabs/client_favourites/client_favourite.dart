import 'package:flutter/material.dart';
import 'package:street_calle/screens/home/client_tabs/client_favourites/widgets/client_favourite_item.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/utils/constant/app_assets.dart';

class ClientFavourite extends StatelessWidget {
  const ClientFavourite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          TempLanguage().lblFavourites,
          style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryFontColor, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 10,
          itemBuilder: (context, index) {
            final item = Item(
                image: AppAssets.teaImage,
                title: 'Tea House',
                foodType: 'Westren food'
            );

            return ClientFavouriteItem(
                item: item,
                onTap: (){

                }
            );
          },
        ),
      ),
    );
  }
}
