import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/screens/selectUser/widgets/drop_down_widget.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/models/drop_down_item.dart';
import 'package:street_calle/services/category_service.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({Key? key, required this.vendorName, required this.userName}) : super(key: key);
  final String vendorName;
  final String userName;

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  DropDownItem? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: double.maxFinite,
      height: 250,
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

            _selectedItem = category[0];

            return Column(
              children: [
                Text(
                  TempLanguage().lblSelectCategory,
                  style: context.currentTextTheme.labelMedium,
                ),
                const SizedBox(height: 15),
                Text(
                  TempLanguage().lblSelectCategoryList,
                  textAlign: TextAlign.center,
                  style: context.currentTextTheme.displaySmall,
                ),
                const SizedBox(height: 15),
                Container(
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
                    initialValue: _selectedItem,
                    items: category,
                    onChanged: (value) {
                      _selectedItem = value;

                    },
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: ContextExtensions(context).width(),
                  height: defaultButtonSize,
                  child: AppButton(
                    text: TempLanguage().lblDone,
                    elevation: 0.0,
                    onTap: onTap,
                    shapeBorder: RoundedRectangleBorder(
                        side: const BorderSide(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(30)),
                    textStyle: context.currentTextTheme.labelLarge
                        ?.copyWith(color: AppColors.whiteColor),
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
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
    );
  }

  Future<void> onTap() async {
    final userService = sl.get<UserService>();
    final userCubit = context.read<UserCubit>();
    final userId = userCubit.state.userId;

    if (_selectedItem != null) {
      userService.updateCategory(_selectedItem!.title, _selectedItem!.url ?? '', userId).then((value) {
        if (value) {
          userCubit.setUserType(widget.userName);
          userCubit.setVendorType(widget.vendorName);
          userCubit.setIsVendor(true);
          userCubit.setCategory(_selectedItem!.title);
          userCubit.setCategoryImage(_selectedItem!.url ?? '');
          userService.setVendorType(userId, widget.vendorName, widget.userName);
          context.goNamed(AppRoutingName.mainScreen);
        } else {
          toast(TempLanguage().lblSomethingWentWrong);
        }
      });
    }
  }
}