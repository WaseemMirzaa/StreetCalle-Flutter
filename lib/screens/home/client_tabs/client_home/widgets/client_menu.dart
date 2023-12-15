import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/current_location_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/client_menu_item.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/widgets/search_field.dart';

class ClientMenu extends StatelessWidget {
  const ClientMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ClientMenuSearchCubit>().updateQuery('');

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 54, left: 24, right: 24),
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: FloatingActionButton(
                    onPressed: (){
                      context.pop();
                    },
                    backgroundColor: AppColors.primaryLightColor,
                    shape: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(Icons.arrow_back_ios, color: AppColors.blackColor),
                    ),
                  ),
                ),
                const SizedBox(width: 16,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackColor.withOpacity(0.25),
                          spreadRadius: 3, // Spread radius
                          blurRadius: 15, // Blur radius
                          offset: const Offset(0, 0), // Offset in the Y direction
                        ),
                      ],
                    ),
                    child: SearchField(
                      padding: EdgeInsets.zero,
                      hintText: TempLanguage().lblSearchFoodTrucks,
                      onChanged: (String? value) => _searchQuery(context, value),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: FutureBuilder<Position>(
                future: LocationUtils.fetchLocation(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
                  } else if (snap.hasError) {
                    return Center(child: Text(TempLanguage().lblSomethingWentWrong));
                  } else {
                    return BlocBuilder<CurrentLocationCubit, CurrentLocationState>(
                      builder: (context, state){
                        if (state.updatedLatitude != null && state.updatedLongitude != null) {
                          Position position = Position(
                              longitude: state.updatedLongitude!,
                              latitude: state.updatedLatitude!,
                              timestamp: DateTime.now(),
                              accuracy: 0.0,
                              altitude: 0.0,
                              heading: 0.0,
                              speed: 0.0,
                              speedAccuracy: 0.0, altitudeAccuracy: 100,headingAccuracy: 100);
                          return DisplayVendors(position: position);
                        } else {
                          return DisplayVendors(position: snap.data!);
                        }},
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _searchQuery(BuildContext context, String? value) {
    context.read<ClientMenuSearchCubit>().updateQuery(value ?? '');
  }
}

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

          return BlocBuilder<ClientMenuSearchCubit, String>(
            builder: (context, state) {

              List<User> list = [];
              if (state.isNotEmpty) {
                list = snapshot.data!.where((user) {
                  final userName = user.name?.toLowerCase() ?? '';
                  final ownerName = user.employeeOwnerName?.toLowerCase() ?? '';
                  return ownerName.isEmpty ? userName.contains(state.toLowerCase()) : ownerName.contains(state.toLowerCase());
                }).toList();
              } else {
                list = snapshot.data!;
              }

              if (position != null) {
                list = list.where((user) {
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

                list.sort((a, b) =>
                    LocationUtils.distanceInMiles(position?.latitude ?? 0.0, position?.longitude ?? 0.0, a.latitude!, a.longitude!)
                        .compareTo(LocationUtils.distanceInMiles(position?.latitude ?? 0.0, position?.longitude ?? 0.0, b.latitude!, b.longitude!)));
              }


              return list.isEmpty
                  ? Center(
                child: Text(
                  TempLanguage().lblNoDataFound,
                  style: context.currentTextTheme.displaySmall,
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final user = list[index];
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