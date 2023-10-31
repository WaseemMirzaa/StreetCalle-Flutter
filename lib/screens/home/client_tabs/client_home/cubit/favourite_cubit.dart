import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/services/user_service.dart';

enum FavoriteStatus { loading, isFavorite, isNotFavorite }

class FavoriteCubit extends Cubit<FavoriteStatus> {
  FavoriteCubit(this.userService) : super(FavoriteStatus.loading);
  final UserService userService;


  void checkFavoriteStatus(String userId, String vendorId) async {
    bool isFavorite = await userService.isVendorInFavorites(userId, vendorId);
    if (isFavorite) {
      emit(FavoriteStatus.isFavorite);
    } else {
      emit(FavoriteStatus.isNotFavorite);
    }
  }

  void updateFavouriteStatue(bool isFav) {
    if (isFav) {
      emit(FavoriteStatus.isFavorite);
    } else {
      emit(FavoriteStatus.isNotFavorite);
    }
  }
}
