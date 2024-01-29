import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/display_map.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/widgets/search_field.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/current_location_cubit.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/models/drop_down_item.dart';
import 'package:street_calle/services/category_service.dart';
import 'package:street_calle/screens/selectUser/widgets/drop_down_widget.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/filter_cubit.dart';

class ClientHomeTab extends StatelessWidget {
  const ClientHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DropDownItem? selectedItem;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: ContextExtension(context).width,
            height: ContextExtension(context).height,
            child: FutureBuilder<Position>(
              future: LocationUtils.fetchLocation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
                } else if (snapshot.hasError) {
                  return Center(child: Text(TempLanguage().lblSomethingWentWrong));
                } else {
                  return BlocBuilder<CurrentLocationCubit, CurrentLocationState>(
                    builder: (context, state) {
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
                        return DisplayMap(position: position, isLocationUpdated: true,);
                      } else {
                        return DisplayMap(position: snapshot.data, isLocationUpdated: false,);
                      }
                    },
                  );
                }
              },
            )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 54, left: 24, right: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          context.pushNamed(AppRoutingName.clientMenu);
                        },
                        child: SearchField(
                          padding: EdgeInsets.zero,
                          hintText: TempLanguage().lblSearchFoodTrucks,
                          onChanged: (String? value) {},
                          enabled: false,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16,),
                    InkWell(
                      onTap: (){
                        context.pushNamed(AppRoutingName.clientMenu);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                            color: AppColors.primaryLightColor,
                            shape: BoxShape.circle
                        ),
                        child: Image.asset(AppAssets.topMenuIcon),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12,),
                FutureBuilder<List<dynamic>?>(
                  future: sl.get<CategoryService>().fetchCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),);
                    } else if (snapshot.hasData && snapshot.data != null) {
                      List<DropDownItem> category = [];
                      snapshot.data?.forEach((element) {
                        final dropDown = DropDownItem(
                            title: element[CategoryKey.TITLE],
                            icon: Image.network(element[CategoryKey.ICON], width: 18, height: 18,),
                            url: element[CategoryKey.ICON]
                        );
                        category.add(dropDown);
                      });

                      selectedItem = category[0];

                      return Container(
                        margin: const EdgeInsets.only(right: 130),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackColor.withOpacity(0.1),
                              spreadRadius: 2, // Spread radius
                              blurRadius: 15, // Blur radius
                              offset: const Offset(0, 0), // Offset in the Y direction
                            ),
                          ],
                        ),
                        child: DropDownWidget(
                          initialValue: selectedItem,
                          items: category,
                          onChanged: (value) {
                            selectedItem = value;
                            context.read<MapFilterCubit>().updateFilter(value?.title ?? '');
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(TempLanguage().lblSomethingWentWrong),
                      );
                    }
                    return Center(
                      child: Text(TempLanguage().lblSomethingWentWrong),
                    );
                  },
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 30,
            left: 30,
            right: 30,
            child: BlocBuilder<CurrentLocationCubit, CurrentLocationState>(
              builder: (context, state) {
                final latLng = LatLng(state.updatedLatitude ?? 0.0, state.updatedLongitude ?? 0.0);
                return FutureBuilder(
                    future: state.updatedLatitude == null ? LocationUtils.getAddressFromPosition() : LocationUtils.getAddressFromLatLng(latLng),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
                      if (snapshot.hasData && snapshot.data != null) {
                        return Container(
                          height: defaultButtonSize,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLightColor,
                            borderRadius: BorderRadius.circular(defaultRadius),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 8,),
                              Expanded(
                                child: Text('${snapshot.data}', style: const TextStyle(color: AppColors.blackColor),),
                              ),
                              IconButton(
                                onPressed: () async {
                                  LocationUtils.fetchLocation().then((current){
                                    final position = LatLng(current.latitude, current.longitude);
                                    context.pushNamed(AppRoutingName.locationPicker, extra: position);
                                  });
                                },
                                icon: const Icon(Icons.edit, color: AppColors.blackColor,),
                              ),
                              const SizedBox(width: 8,),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}