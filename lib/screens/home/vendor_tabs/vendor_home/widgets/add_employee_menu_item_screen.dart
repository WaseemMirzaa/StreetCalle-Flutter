import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

class AddEmployeeMenuItemsScreen extends StatefulWidget {

  String id;
  List<dynamic>?  selectedItemId;
  AddEmployeeMenuItemsScreen({Key? key,required this.id,this.selectedItemId}) : super(key: key);

  @override
  State<AddEmployeeMenuItemsScreen> createState() => _AddEmployeeMenuItemsScreenState();
}

class _AddEmployeeMenuItemsScreenState extends State<AddEmployeeMenuItemsScreen> {


  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    print((widget.selectedItemId));
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
          TempLanguage().lblAddMenuItems,
          style: context.currentTextTheme.titleMedium
              ?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
      ),
      body:
      /// this is shehzad

      // Padding(
      //   padding:
      //       const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
      //   child: ListView.builder(
      //     itemCount: 10,
      //     itemBuilder: (context, index) {
      //       return InkWell(
      //         onTap: () {},
      //         child: Column(
      //           children: [
      //             const SizedBox(
      //               height: 12,
      //             ),
      //             Row(
      //               children: [
      //                 Container(
      //                   width: 90,
      //                   height: 90,
      //                   decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(10)),
      //                   clipBehavior: Clip.hardEdge,
      //                   child: Image.asset(
      //                     AppAssets.burgerImage,
      //                     fit: BoxFit.cover,
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   width: 12,
      //                 ),
      //                 Expanded(
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Row(
      //                         children: [
      //                           const Expanded(
      //                             flex: 2,
      //                             child: Text(
      //                               'Burgers',
      //                               style: TextStyle(
      //                                   fontSize: 24,
      //                                   fontFamily: METROPOLIS_BOLD,
      //                                   color: AppColors.primaryFontColor),
      //                             ),
      //                           ),
      //                           Checkbox(
      //                             checkColor: Colors.white,
      //                             value: true,
      //                             side: const BorderSide(
      //                                 color: AppColors.primaryFontColor,
      //                                 width: 1.5),
      //                             shape: const StadiumBorder(),
      //                             onChanged: (bool? value) {},
      //                           ),
      //                         ],
      //                       ),
      //                       const SizedBox(
      //                         height: 6,
      //                       ),
      //                       Row(
      //                         children: [
      //                           Image.asset(
      //                             AppAssets.marker,
      //                             width: 12,
      //                             height: 12,
      //                             color: AppColors.primaryColor,
      //                           ),
      //                           const SizedBox(
      //                             width: 4,
      //                           ),
      //                           Text('No 03, 4th Lane, Newyork',
      //                               style: context.currentTextTheme.displaySmall
      //                                   ?.copyWith(
      //                                       color: AppColors.placeholderColor,
      //                                       fontSize: 14)),
      //                         ],
      //                       ),
      //                       const SizedBox(
      //                         height: 6,
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             const SizedBox(
      //               height: 12,
      //             ),
      //             const Divider(
      //               color: AppColors.dividerColor,
      //             ),
      //           ],
      //         ),
      //       );
      //     },
      //   ),
      // ),

      /// new code


      Stack(
        alignment: Alignment.center,
        children: [
          StreamBuilder(stream: FirebaseFirestore.instance.collection('items').where('uid',isEqualTo: context.read<UserCubit>().state.userId).snapshots(), builder: (context,snapshot){

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
            return
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              child:
              // ListView.builder(
              //   itemCount: snapshot.data!.docs.length,
              //   itemBuilder: (context, index) {
              //     var itemsData = snapshot.data!.docs[index].data();
              //     String itemId = itemsData['id'];
              //     bool isItemInUserItemList = selectedItemId.contains(itemsData['id']);
              //     return InkWell(
              //       onTap: () {
              //         print(itemsData['id']);
              //         // Toggle item selection
              //         setState(() {
              //           if (isItemInUserItemList) {
              //             selectedItemId.remove(itemId);
              //           } else {
              //             selectedItemId.add(itemId);
              //           }
              //         });
              //       },
              //       child: Column(
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
              //                 child: Image.network(itemsData['image'],fit: BoxFit.cover,)
              //                 // Image.asset(
              //                 //   AppAssets.burgerImage,
              //                 //   fit: BoxFit.cover,
              //                 // ),
              //               ),
              //               const SizedBox(
              //                 width: 12,
              //               ),
              //               Expanded(
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Row(
              //                       children: [
              //                          Expanded(
              //                           flex: 2,
              //                           child: Text(
              //                             itemsData['title'],
              //                             // 'Burgers',
              //                             style: const TextStyle(
              //                                 fontSize: 24,
              //                                 fontFamily: METROPOLIS_BOLD,
              //                                 color: AppColors.primaryFontColor),
              //                           ),
              //                         ),
              //
              //                   !isItemInUserItemList ?     Container(
              //                           height: 20,
              //                           width: 20,
              //                           decoration: const BoxDecoration(
              //                             shape: BoxShape.circle,
              //                             color: AppColors.primaryColor,
              //                           ),
              //                           child:
              //                                const Icon(Icons.check, color: Colors.white, size: 15)
              //                         ):
              //                   Container(
              //                       height: 20,
              //                       width: 20,
              //                       decoration:  BoxDecoration(
              //                         shape: BoxShape.circle,
              //                         border:  Border.all(color: AppColors.dividerColor)
              //                       ),
              //                   )
              //
              //
              //                       ],
              //                     ),
              //                     const SizedBox(
              //                       height: 6,
              //                     ),
              //                     Text(
              //                       itemsData['smallItemTitle'],
              //                       // 'Burgers',
              //                       style: const TextStyle(
              //                           fontSize: 12,
              //                           fontFamily: METROPOLIS_BOLD,
              //                           color: AppColors.primaryColor),
              //                     ),
              //                     const SizedBox(
              //                       height: 6,
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //           const SizedBox(
              //             height: 12,
              //           ),
              //           const Divider(
              //             color: AppColors.dividerColor,
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              // ),

              ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var itemsData = snapshot.data!.docs[index].data();
                  String itemId = itemsData['id'];
                  bool isItemInUserItemList = widget.selectedItemId!.contains(itemId);

                  return InkWell(
                    onTap: () {
                      print(itemsData['id']);
                      // Toggle item selection
                      setState(() {
                        if (isItemInUserItemList) {
                          widget.selectedItemId!.remove(itemId);
                        } else {
                          widget.selectedItemId!.add(itemId);
                        }
                      });
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(itemsData['image'], fit: BoxFit.cover),
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
                                          itemsData['title'],
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontFamily: METROPOLIS_BOLD,
                                            color: AppColors.primaryFontColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          // Check if the item is in the selectedItemId list
                                          color: isItemInUserItemList
                                              ? AppColors.primaryColor
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: AppColors.dividerColor,
                                          ),
                                        ),
                                        child: isItemInUserItemList
                                            ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 15,
                                        )
                                            : null,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    itemsData['smallItemTitle'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: METROPOLIS_BOLD,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
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
                      ],
                    ),
                  );
                },
              )

            );
          }}),


          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44.0),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: defaultButtonSize,
                child: isLoading ?  const Column(
                  mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,mainAxisSize: MainAxisSize.min,
                  children: [
                     CircularProgressIndicator(),
                  ],
                ) :  AppButton(
                  text: 'Add Item For Employee',
                  elevation: 0.0,
                  onTap: () {
                    print(widget.selectedItemId);
                    setState(() {
                      isLoading = true;
                    });

                    FirebaseFirestore.instance.collection('users').doc(widget.id).update({
                      'employeeItemsList': widget.selectedItemId,
                    }).then((value){
                      setState(() {
                        isLoading = false;
                      });
                     Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      setState(() {
                        isLoading = false;
                      });
                    });
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
