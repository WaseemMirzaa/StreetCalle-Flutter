import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/current_location_cubit.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/search_cubit.dart';
import 'package:street_calle/utils/location_utils.dart';
import 'package:street_calle/widgets/search_field.dart';
import 'package:street_calle/models/drop_down_item.dart';
import 'package:street_calle/services/category_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/screens/selectUser/widgets/drop_down_widget.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/display_vendors.dart';

class ClientMenu extends StatelessWidget {
  const ClientMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ClientMenuSearchCubit>().updateQuery('');
    DropDownItem? selectedItem;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 12,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FutureBuilder<List<dynamic>?>(
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
                          color: AppColors.blackColor.withOpacity(0.15),
                          spreadRadius: 3, // Spread radius
                          blurRadius: 18, // Blur radius
                          offset: const Offset(0, 2), // Offset in the Y direction
                        ),
                      ],
                    ),
                    child: DropDownWidget(
                      initialValue: selectedItem,
                      items: category,
                      onChanged: (value) {
                        selectedItem = value;

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
          ),
          const SizedBox(height: 12,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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