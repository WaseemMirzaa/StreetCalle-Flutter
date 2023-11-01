import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/selected_item_cubit.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

class AddEmployeeMenuItemsScreen extends StatefulWidget {
  final User? user;

  AddEmployeeMenuItemsScreen({Key? key, this.user}) : super(key: key);

  @override
  State<AddEmployeeMenuItemsScreen> createState() => _AddEmployeeMenuItemsScreenState();
}

class _AddEmployeeMenuItemsScreenState extends State<AddEmployeeMenuItemsScreen> {

  bool isLoading = false;
  List<dynamic> selectedItemIds =[] ;

  @override
  void initState() {
    // selectedItemIds = widget.user!.employeeItemsList as List<dynamic>;
    if (widget.user?.employeeItemsList != null) {
      selectedItemIds = widget.user!.employeeItemsList as List<dynamic>;
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final itemService = sl.get<ItemService>();
    final userService = sl.get<UserService>();

    print('--------------------ids---------------------');
    print(selectedItemIds);


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
      body: Stack(
        alignment: Alignment.center,
        children: [

          widget.user!.vendorId?.isNotEmpty ?? false ?

          StreamBuilder<List<Item>>(
              stream:itemService.getVendorItems(widget.user!.vendorId!),
              builder: (context,snapshot){
            if(!snapshot.hasData || snapshot.data!.isEmpty){

              return Center(
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(TempLanguage().lblNoDataFound),
                  ],
                ),
              );
                 }
              else if(snapshot.hasError){
                return
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Error: ${snapshot.hasError}'),
                      ],
                    ),
                  );
    }           else if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);

    }
                 else{
                           List<Item> items = snapshot.data ?? [];



      if(items.isEmpty){
        return  Center(
          child: Text(TempLanguage().lblNoDataFound)
        );
      }
      else {
        return  Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
            child:


            BlocBuilder<SelectedItemsCubit,List<String>>(builder: (context,state){
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {



                  var itemData  = items[index];
                  bool isUserItem = widget.user!.employeeItemsList!.contains(itemData.id) ?? false;


                  return  Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: (){
                          context.read<SelectedItemsCubit>().toggleItem(itemData.id!);

                          if(selectedItemIds != null)
                            {
                              if(selectedItemIds.contains(itemData.id)){
                                selectedItemIds.remove(itemData.id);
                              }
                              else{
                                selectedItemIds.add(itemData.id);
                              }

                          }else{
                            selectedItemIds = [itemData.id];

                          }




                          print(selectedItemIds);

                        },
                        child: Row(
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child:  Image.network(itemData.image!, fit: BoxFit.cover),
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
                                          itemData.title!,
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

                                          color: isUserItem ?  AppColors.primaryColor : Colors.transparent,
                                          border: Border.all(
                                            color: isUserItem ?  Colors.transparent : AppColors.dividerColor,
                                          ),
                                        ),
                                        child:const Icon(Icons.check,color: Colors.white,size: 15,),

                                      ),


                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    itemData.smallItemTitle!,
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
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Divider(
                        color: AppColors.dividerColor,
                      ),
                    ],
                  );
                },
              );
            })

        );
      }




          }})

            : Center(child: Text(TempLanguage().lblNoDataFound),),


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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     CircularProgressIndicator(),
                  ],
                ) :  AppButton(
                  text: TempLanguage().lblAddItemForEmployee,
                  elevation: 0.0,
                  onTap: () {

                    // userService.updateMenuItems(widget.user!.uid!, selectedItemIds);

                    setState(() {
                      isLoading = true;
                    });



                   userService.updateUserMenuItems(widget.user!.uid!, selectedItemIds).then((value){
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
                  textStyle: context.currentTextTheme.labelMedium
                      ?.copyWith(color: AppColors.whiteColor,fontSize: 18),
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
