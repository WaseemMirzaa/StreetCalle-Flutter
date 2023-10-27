import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/employee_detail_screen.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

class ManageEmployeesScreen extends StatelessWidget {
  const ManageEmployeesScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: GestureDetector(

          onTap: () => context.pop(),
          // onTap: (){
          //   print('id');
          //   print(context.read<UserCubit>().state.userId);
          // },

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
          StreamBuilder(stream: FirebaseFirestore.instance.collection('users').where('vendorId',
              isEqualTo:context.read<UserCubit>().state.userId).snapshots(),
              builder: (context,snapshot){

            if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
              return const Center(
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Text('No data found'),
                  ],
                ),
              );
            }
            else if(snapshot.hasError){
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
            }
            else{

              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {

                    var userData = snapshot.data!.docs[index].data();
                    return InkWell(
                      onTap: () {
                        // context.pushNamed(AppRoutingName.employeeDetail,);
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> EmployeeDetailScreen(userData: userData,)));
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
                                  imageUrl: userData['image'] ?? '',
                                  fit: BoxFit.cover,
                                ),
                                // Image.network(userData['image'],fit: BoxFit.cover,),

                                // Image.asset(
                                //   AppAssets.burgerImage,
                                //   fit: BoxFit.cover,
                                // ),
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
                                            // 'Shehzad',
                                            '${userData['name']}',
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontFamily: METROPOLIS_BOLD,
                                                color: AppColors.primaryFontColor),
                                          ),
                                        ),
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
