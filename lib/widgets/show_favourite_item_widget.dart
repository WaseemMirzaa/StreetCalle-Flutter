import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/favourite_cubit.dart';
import 'package:street_calle/utils/constant/app_colors.dart';

class ShowFavouriteItemWidget extends StatelessWidget {
  const ShowFavouriteItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteStatus>(
      builder: (context, state) {
        switch (state) {
          case FavoriteStatus.loading:
            return const CircularProgressIndicator(); // Display a loading indicator.
          case FavoriteStatus.isFavorite:
            return const Icon(
              Icons.favorite_outlined,
              color: AppColors.redColor,
            );
          case FavoriteStatus.isNotFavorite:
            return const Icon(
              Icons.favorite_border_rounded,
            );
          default:
            return const SizedBox(); // Handle other states as needed.
        }
      },
    );
  }
}
