import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/deal.dart';
import 'package:street_calle/models/item.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/menu_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/selected_deal_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/selected_item_cubit.dart';
import 'package:street_calle/services/deal_service.dart';
import 'package:street_calle/services/item_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/widgets/image_widget.dart';

class AddEmployeeMenuItemsScreen extends StatefulWidget {
  final User? user;

  AddEmployeeMenuItemsScreen({Key? key, this.user}) : super(key: key);

  @override
  State<AddEmployeeMenuItemsScreen> createState() => _AddEmployeeMenuItemsScreenState();
}

class _AddEmployeeMenuItemsScreenState extends State<AddEmployeeMenuItemsScreen> {

  bool isLoading = false;
  List<dynamic> selectedItemIds =[] ;
  List<dynamic> selectedDealsIds =[] ;

  final itemService = sl.get<ItemService>();
  final dealService = sl.get<DealService>();
  final userService = sl.get<UserService>();

  final MenuCubit menuCubit = MenuCubit();

  @override
  void initState() {
    // selectedItemIds = widget.user!.employeeItemsList as List<dynamic>;
    if (widget.user?.employeeItemsList != null) {
      selectedItemIds = widget.user!.employeeItemsList as List<dynamic>;
    }
    if (widget.user?.employeeDealsList != null) {
      selectedDealsIds = widget.user!.employeeDealsList as List<dynamic>;
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
             Column(children: [
              /// the tab bar with two items
              SizedBox(
                height: 50,
                child: AppBar(
                  bottom: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: context.currentTextTheme.displaySmall,
                    unselectedLabelStyle: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryFontColor),
                    tabs:  [
                      Tab(text: TempLanguage().lblItems),
                      Tab(text: TempLanguage().lblDeals),
                    ],
                  ),
                ),
              ),
              /// create widgets for each tab bar here
              Expanded(
                child: TabBarView(
                  children: [
                    /// Items tab bar
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
                                    Text(TempLanguage().lblSomethingWentWrong),
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


                                        return  InkWell(
                                          onTap: () {
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
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Row(
                                                children: [
                                                  ImageWidget(image: itemData.image!,),
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
                                                                itemData.title!.capitalizeEachFirstLetter(),
                                                                style: const TextStyle(
                                                                  fontSize: 23,
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
                                                                  color: isUserItem ?  Colors.transparent : AppColors.blackColor,
                                                                ),
                                                              ),
                                                              child:const Icon(Icons.check,color: Colors.white,size: 15,),

                                                            ),


                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 6,
                                                        ),
                                                        itemData.foodType == null ? const SizedBox.shrink() : Text(
                                                          itemData.foodType!.capitalizeEachFirstLetter(),
                                                          style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor, fontSize: 16),
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
                                              SizedBox(height: index == items.length - 1 ? 80 : 0,),

                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  })

                              );
                            }
                          }})

                        : Center(child: Text(TempLanguage().lblNoDataFound),),

                    /// Deals tab bar
                    widget.user!.vendorId?.isNotEmpty ?? false ?
                    StreamBuilder<List<Deal>>(
                        stream:dealService.getDeals(widget.user!.vendorId!),
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
                                    Text(TempLanguage().lblSomethingWentWrong),
                                  ],
                                ),
                              );
                          }           else if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator(),);
                          }
                          else{
                            List<Deal> deals = snapshot.data ?? [];
                            if(deals.isEmpty){
                              return  Center(
                                  child: Text(TempLanguage().lblNoDataFound)
                              );
                            }
                            else {
                              return  Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                                  child: BlocBuilder<SelectedDealsCubit,List<String>>(builder: (context,state){
                                    return ListView.builder(
                                      itemCount: deals.length,
                                      itemBuilder: (context, index) {
                                        var dealData  = deals[index];
                                        bool isUserDeal = widget.user!.employeeDealsList!.contains(dealData.id) ?? false;

                                        return InkWell(
                                          onTap: (){
                                            context.read<SelectedDealsCubit>().toggleItem(dealData.id!);
                                            if(selectedDealsIds != null)
                                            {
                                              if(selectedDealsIds.contains(dealData.id)){
                                                selectedDealsIds.remove(dealData.id);
                                              }
                                              else{
                                                selectedDealsIds.add(dealData.id);
                                              }
                                            }else{
                                              selectedDealsIds = [dealData.id];
                                            }
                                            print(selectedDealsIds);
                                          },
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Row(
                                                children: [
                                                  ImageWidget(image: dealData.image!,),
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
                                                                dealData.title!.capitalizeEachFirstLetter(),
                                                                style: const TextStyle(
                                                                  fontSize: 23,
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

                                                                color: isUserDeal ?  AppColors.primaryColor : Colors.transparent,
                                                                border: Border.all(
                                                                  color: isUserDeal ?  Colors.transparent : AppColors.blackColor,
                                                                ),
                                                              ),
                                                              child:const Icon(Icons.check,color: Colors.white,size: 15,),

                                                            ),


                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 6,
                                                        ),
                                                        dealData.foodType == null ? const SizedBox.shrink() : Text(
                                                          dealData.foodType!.capitalizeEachFirstLetter(),
                                                          style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor, fontSize: 16),
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
                                              SizedBox(height: index == deals.length - 1 ? 80 : 0,),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  })

                              );
                            }
                          }})

                        : Center(child: Text(TempLanguage().lblNoDataFound),),
                  ],
                ),
              ),
            ],),
             Positioned(
              bottom: 20,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44.0),
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: defaultButtonSize,
                  child:
                  BlocBuilder<MenuCubit,MenuState>(builder: (context,state){

                    if (state == MenuState.loading) {
                      return const Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                           CircularProgressIndicator(),
                        ],
                      ); // Show a loading indicator
                    } else if (state == MenuState.loaded) {
                      return Text(TempLanguage().lblMenuUpdatedSuccessfully);
                    } else if (state == MenuState.error) {
                      return Text(TempLanguage().lblErrorOccurred);
                    }else{
                      return AppButton(
                        text: TempLanguage().lblAddMenuItems,
                        elevation: 0.0,
                        onTap: ()async {
                          context.read<MenuCubit>().emit(MenuState.loading);

                        await  updateMenu().then((value) {
                          context.pop();
                          context.read<MenuCubit>().emit(MenuState.initial);
                        });
                        },
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        textStyle: context.currentTextTheme.labelMedium
                            ?.copyWith(color: AppColors.whiteColor,fontSize: 18),
                        color: AppColors.primaryColor,
                      );
                    }
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> updateMenu() async{
   await menuCubit.updateUserMenu(widget.user!.uid!, selectedDealsIds, selectedItemIds);
  }
}
