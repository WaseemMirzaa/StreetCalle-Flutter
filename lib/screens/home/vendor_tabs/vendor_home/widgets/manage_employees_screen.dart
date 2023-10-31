import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/cubit/user_state.dart';

class ManageEmployeesScreen extends StatelessWidget {
  const ManageEmployeesScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final userService = sl.get<UserService>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: GestureDetector(

          onTap: () => context.pop(),

          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                AppAssets.backIcon,
                width: 20,
                height: 20,
              )
            ],
          ),
        ),
        title: Text(
          TempLanguage().lblManage,
          style: context.currentTextTheme.titleMedium
              ?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder<List<User>>(
            stream: userService.getEmployees(context.read<UserCubit>().state.userId),
              builder: (context,snapshot){

               if(!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty){
                 return Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Text(TempLanguage().lblNoDataFound),
                  ],
                ),
                 );
               } else if(snapshot.hasError){
              return  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.hasError}'),
                  ],
                ),
              );
            }else if(snapshot.connectionState == ConnectionState.waiting){
                 return const Center(child: CircularProgressIndicator(),);
               } else{
                 return Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                child: ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {

                    var userData = snapshot.data![index];
                    return InkWell(
                      onTap: () {
                         context.pushNamed(AppRoutingName.employeeDetail, extra: userData);
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                clipBehavior: Clip.hardEdge,

                                child: CachedNetworkImage(
                                  imageUrl: userData.image ?? '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            '${userData.name}',
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontFamily: METROPOLIS_BOLD,
                                                color: AppColors.primaryFontColor),
                                          ),
                                        ),
                                       userData.isEmployeeBlocked != true || userData.isEmployeeBlocked == null ?
                                         const SizedBox.shrink():
                                       const Text('Blocked', style: TextStyle(
                                           fontSize: 16,
                                           fontFamily: METROPOLIS_R,
                                           color: AppColors.redColor),)
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          AppAssets.marker,
                                          width: 12,
                                          height: 12,
                                          color: AppColors.primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text('No 03, 4th Lane, Newyork',
                                            style: context
                                                .currentTextTheme.displaySmall
                                                ?.copyWith(
                                                color:
                                                AppColors.placeholderColor,
                                                fontSize: 14)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Divider(
                            color: AppColors.dividerColor,
                          ),
                          SizedBox(
                            height: index == 9 ? 60 : 0,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
              }
          }),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44.0),
              child: SizedBox(
                width: context.width,
                height: defaultButtonSize,
                child: AppButton(
                  text: TempLanguage().lblCreateNewEmployee,
                  elevation: 0.0,
                  onTap: () {
                    context
                        .pushNamed(AppRoutingName.createEmployeeProfileScreen);
                  },
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  textStyle: context.currentTextTheme.labelLarge
                      ?.copyWith(color: AppColors.whiteColor),
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
