import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/menu_cubit.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';

final MenuCubit menuCubit = MenuCubit();


class AddMenuItemsWidget extends StatelessWidget {
  const AddMenuItemsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
    );
  }

  Future<void> updateMenu() async{
    //await menuCubit.updateUserMenu(widget.user!.uid!, selectedDealsIds, selectedItemIds);
  }
}
