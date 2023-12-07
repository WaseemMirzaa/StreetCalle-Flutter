import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/client_tabs/client_favourites/cubit/favourite_list_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_favourites/widgets/client_favourite_item.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/widgets/no_data_found_widget.dart';

class ClientFavourite extends StatelessWidget {
  const ClientFavourite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = sl.get<UserService>();
    String userId = context.read<UserCubit>().state.userId;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          TempLanguage().lblFavourites,
          style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, ),
        child: FutureBuilder<List<User>>(
          future: userService.getFavouriteVendors(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor,),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  TempLanguage().lblSomethingWentWrong,
                  style: context.currentTextTheme.displaySmall,
                ),
              );
            }
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                return const NoDataFoundWidget();
              }

              context.read<FavouriteListCubit>().addUsers(snapshot.data!);
              return BlocBuilder<FavouriteListCubit, List<User>>(
                builder: (context, state) {
                  return state.isEmpty
                      ? const NoDataFoundWidget()
                      : ListView.builder(
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      final user = state[index];
                      return ClientFavouriteItem(
                          user: user,
                          onDelete: (){
                            context.read<FavouriteListCubit>().removeUser(user.uid ?? '');
                            userService.updateFavourites(user.uid ?? '', userId, false);
                          },
                          onTap: (){
                            context.read<ClientSelectedVendorCubit>().selectedVendorId(user.uid);
                            context.pushNamed(AppRoutingName.clientMenuItemDetail, extra: user);
                          }
                      );
                    },
                  );
                },
              );
            }
            return Center(
              child: Text(
                TempLanguage().lblSomethingWentWrong,
                style: context.currentTextTheme.displaySmall,
              ),
            );
          },
        ),
      ),
    );
  }
}