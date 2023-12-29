import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/client_menu_item.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/filter_cubit.dart';
import 'package:street_calle/utils/constant/constants.dart';

class DisplayVendors extends StatelessWidget {
  const DisplayVendors({Key? key, required this.position}) : super(key: key);
  final Position? position;

  @override
  Widget build(BuildContext context) {
    final userService = sl.get<UserService>();

    return FutureBuilder<List<User>>(
      future: userService.getVendorsAndEmployees(),
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
            return Center(
              child: Text(
                TempLanguage().lblNoVendorFound,
                style: context.currentTextTheme.displaySmall,
              ),
            );
          }

          return BlocBuilder<VendorFilterCubit, String>(
            builder: (context, filterString) {
              return BlocBuilder<ClientMenuSearchCubit, String>(
                builder: (context, state) {

                  List<User> users = [];
                  if (filterString != defaultVendorFilter) {
                    users = snapshot.data!.where((user) {
                      final category = user.category?.toLowerCase().trim() ?? '';
                      return category.contains(filterString.toLowerCase().trim());
                    }).toList();
                  } else {
                    users = snapshot.data ?? [];
                  }

                  if (state.isNotEmpty) {
                    users = users.where((user) {
                      final userName = user.name?.toLowerCase() ?? '';
                      final ownerName = user.employeeOwnerName?.toLowerCase() ?? '';
                      return ownerName.isEmpty ? userName.contains(state.toLowerCase()) : ownerName.contains(state.toLowerCase());
                    }).toList();
                  }

                  if (position != null) {
                    users = users.where((user) {
                      if (user.latitude != null && user.longitude != null) {
                        return LocationUtils.isDistanceWithinRange(
                            position?.latitude ?? 0.0,
                            position?.longitude ?? 0.0,
                            user.latitude!,
                            user.longitude!,
                            10
                        );
                      } else {
                        return false;
                      }
                    }).toList();

                    users.sort((a, b) =>
                        LocationUtils.distanceInMiles(position?.latitude ?? 0.0, position?.longitude ?? 0.0, a.latitude!, a.longitude!)
                            .compareTo(LocationUtils.distanceInMiles(position?.latitude ?? 0.0, position?.longitude ?? 0.0, b.latitude!, b.longitude!)));
                  }

                  return users.isEmpty
                      ? Center(
                    child: Text(
                      TempLanguage().lblNoDataFound,
                      style: context.currentTextTheme.displaySmall,
                    ),
                  )
                      : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ClientMenuItem(
                          user: user,
                          onTap: (){
                            context.read<ClientSelectedVendorCubit>().selectedVendorId(user.uid);
                            context.pushNamed(AppRoutingName.clientMenuItemDetail, extra: user);
                          }
                      );
                    },
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
    );
  }
}