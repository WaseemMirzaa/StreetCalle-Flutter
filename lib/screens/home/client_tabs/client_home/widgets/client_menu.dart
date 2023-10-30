import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/cubit/client_selected_vendor_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_home/widgets/client_menu_item.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/user_service.dart';

class ClientMenu extends StatelessWidget {
  const ClientMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = sl.get<UserService>();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 54, left: 24, right: 24),
            child: Row(
              children: [
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
                    child: TextField(
                      textAlign: TextAlign.center,
                      onChanged: (String? value) {},
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        filled: true,
                        prefixIcon: Container(
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(
                                color: AppColors.primaryLightColor,
                                shape: BoxShape.circle
                            ),
                            child: const Icon(Icons.search, color: AppColors.hintColor,)),
                        hintStyle: context.currentTextTheme.displaySmall,
                        hintText: TempLanguage().lblSearchFoodTrucks,
                        fillColor: AppColors.whiteColor,
                        border: clientSearchBorder,
                        focusedBorder: clientSearchBorder,
                        disabledBorder: clientSearchBorder,
                        enabledBorder: clientSearchBorder,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16,),
                InkWell(
                  onTap: (){
                    context.pop();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: AppColors.primaryLightColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                          color: AppColors.blackColor.withOpacity(0.25),
                          spreadRadius: 3, // Spread radius
                          blurRadius: 3, // Blur radius
                          offset: const Offset(0, 0), // Offset in the Y direction
                        ),
                        ],
                    ),
                    child: Image.asset(AppAssets.locationMarker),
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
              child: FutureBuilder<List<User>>(
                future: userService.getVendors(),
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
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final user = snapshot.data![index];

                        return ClientMenuItem(
                            user: user,
                            onTap: (){
                              context.read<ClientSelectedVendorCubit>().selectedVendorId(user.uid);
                              context.pushNamed(AppRoutingName.clientMenuItemDetail, extra: user);
                            }
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
          ),
        ],
      ),
    );
  }
}
