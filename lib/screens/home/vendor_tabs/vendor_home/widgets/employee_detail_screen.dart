import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/add_employee_menu_item_screen.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/constant/constants.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const EmployeeDetailScreen({Key? key,this.userData}) : super(key: key);

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {

  List<dynamic>? listData;
  bool isLoading = false;

  @override
  void initState() {
    listData = widget.userData!['employeeItemsList'];
    setState(() {

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    listData = widget.userData?['employeeItemsList'];
    print(listData);
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
          TempLanguage().lblEmployeeDetails,
          style: context.currentTextTheme.titleMedium
              ?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultHorizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      clipBehavior: Clip.hardEdge,
                      child:
                      CachedNetworkImage(
                        imageUrl: widget.userData!['image'] ?? '',
                        fit: BoxFit.cover,
                      ),
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
                                  widget.userData!['name'],
                                  // 'Shehzad',
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
                                  style: context.currentTextTheme.displaySmall
                                      ?.copyWith(
                                          color: AppColors.placeholderColor,
                                          fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: AppColors.dividerColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppAssets.itemListIcon),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      TempLanguage().lblItemList,
                      style: context.currentTextTheme.labelLarge
                          ?.copyWith(color: AppColors.primaryFontColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),

                /// this is initial code written by shehzad
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: 10,
                //     itemBuilder: (context, index) {
                //       return Column(
                //         children: [
                //           const SizedBox(
                //             height: 12,
                //           ),
                //           Row(
                //             children: [
                //               Container(
                //                 width: 90,
                //                 height: 90,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(10)),
                //                 clipBehavior: Clip.hardEdge,
                //                 child: Image.asset(
                //                   AppAssets.burgerImage,
                //                   fit: BoxFit.cover,
                //                 ),
                //               ),
                //               const SizedBox(
                //                 width: 12,
                //               ),
                //               Expanded(
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     const Row(
                //                       children: [
                //                         Expanded(
                //                           flex: 2,
                //                           child: Text(
                //                             'Shehzad',
                //                             style: TextStyle(
                //                                 fontSize: 24,
                //                                 fontFamily: METROPOLIS_BOLD,
                //                                 color:
                //                                     AppColors.primaryFontColor),
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                     const SizedBox(
                //                       height: 6,
                //                     ),
                //                     Row(
                //                       children: [
                //                         Image.asset(
                //                           AppAssets.marker,
                //                           width: 12,
                //                           height: 12,
                //                           color: AppColors.primaryColor,
                //                         ),
                //                         const SizedBox(
                //                           width: 4,
                //                         ),
                //                         Text('No 03, 4th Lane, Newyork',
                //                             style: context
                //                                 .currentTextTheme.displaySmall
                //                                 ?.copyWith(
                //                                     color: AppColors
                //                                         .placeholderColor,
                //                                     fontSize: 14)),
                //                       ],
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           ),
                //           const SizedBox(
                //             height: 20,
                //           ),
                //           const Divider(
                //             color: AppColors.dividerColor,
                //           ),
                //           SizedBox(
                //             height: index == 9 ? 60 : 0,
                //           ),
                //         ],
                //       );
                //     },
                //   ),
                // ),

              listData!.isNotEmpty ?

    StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('items')
        .where(FieldPath.documentId, whereIn: listData)
        .snapshots(),
    builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return const Center(
    child: CircularProgressIndicator(),
    );
    } else if (snapshot.hasError) {
    return Center(
    child: Text('Error: ${snapshot.error}'),
    );
    } else if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(
    child: CircularProgressIndicator(),
    );
    } else {
    QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
    List<DocumentSnapshot> documents = querySnapshot.docs;

    if (documents.isEmpty) {
    return const Center(
    child: Text('No items found with the provided IDs'),
    );
    }

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
      itemCount: documents.length,
      itemBuilder: (context, index) {
      var itemData = documents[index].data() as Map<String, dynamic>;
      return   Column(
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
                child: Image.network(itemData['image'],fit: BoxFit.cover,)
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
                              itemData['title'],
                            // 'Shehzad',
                            style: const TextStyle(
                                fontSize: 24,
                                fontFamily: METROPOLIS_BOLD,
                                color:
                                AppColors.primaryFontColor),
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
                                color: AppColors
                                    .placeholderColor,
                                fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            color: AppColors.dividerColor,
          ),
          SizedBox(
            height: index == 9 ? 60 : 0,
          ),
        ],
      );
      },
      ),
    );
    }
    },
    ):
                  const Center(child: Text('Empty list Data '),)






    ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child:
                  widget.userData!['isEmployeeBlocked'] ?
                      AppButton(
                        text: 'Blocked',
                        textColor: AppColors.whiteColor,
                        onTap: (){},
                        width: context.width,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: AppColors.redColor,
                      ):
              Row(
                children: [
                isLoading ? const CircularProgressIndicator() :   GestureDetector(
                    onTap:(){
                      setState(() {
                        isLoading = true;
                      });
                      FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: widget.userData!['uid']).get().then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          FirebaseFirestore.instance.collection('users').doc(doc.id).update({
                            'isEmployeeBlocked': true,
                          });
                          setState(() {

                          });
                        });
                      }).then((value) {
                        setState(() {
                          isLoading = false;
                        });
                      }).onError((error, stackTrace) {
                        print('Error $error');
                        setState(() {
                          isLoading = false;
                        });
                      });

                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.redColor,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppAssets.block,
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),


                  Expanded(
                    child:  SizedBox(
                      width: context.width,
                      height: defaultButtonSize,
                      child: AppButton(
                        elevation: 0.0,
                        onTap: () {
                          // context
                          //     .pushNamed(AppRoutingName.addEmployeeMenuItems);

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddEmployeeMenuItemsScreen(id:widget.userData!['uid'],selectedItemId: listData,)));
                        },
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: AppColors.primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppAssets.pencil),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              TempLanguage().lblEditAddMenuItems,
                              style: context.currentTextTheme.labelLarge
                                  ?.copyWith(color: AppColors.whiteColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
