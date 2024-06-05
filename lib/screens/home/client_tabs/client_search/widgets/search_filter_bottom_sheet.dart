import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/screens/auth/widgets/custom_text_field.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/my_sizer.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/cubit/apply_filter_cubit.dart';
import 'package:street_calle/screens/home/client_tabs/client_search/cubit/filter_cubit.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class SearchFilterBottomSheet extends StatelessWidget {
  const SearchFilterBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final applyFilterCubit = context.read<ApplyFilterCubit>();
    MySizer().init(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.filter.tr(),
                    style: context.currentTextTheme.labelLarge,
                  ),
                  InkWell(
                    onTap: userCubit.state.isGuest ? null : (){
                      context.read<ApplyFilterCubit>().resetApplyFilter();
                      context.read<ApplyFilterCubit>().clear();
                      context.read<FilterItemsCubit>().resetFilterItems();
                      context.read<RemoteUserItems>().resetRemoteUserItems();
                      context.read<FilterDealsCubit>().resetFilterDeals();
                      context.read<RemoteUserDeals>().resetRemoteUserDeals();
                      context.pop();
                    },
                    child: Text(
                      LocaleKeys.reset.tr(),
                      style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.price.tr(),
                    style: context.currentTextTheme.labelLarge,
                  ),
                  // Text(
                  //   TempLanguage().lblSetManually,
                  //   style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor),
                  // ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: applyFilterCubit.minPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.minimumPrice.tr(),
                        hintStyle: context.currentTextTheme.displaySmall?.copyWith(fontSize: 16, color: AppColors.secondaryFontColor),
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                        filled: true,
                        isDense: true,
                        fillColor: AppColors.whiteColor,
                        border: border,
                        enabledBorder: border,
                        disabledBorder: border,
                        focusedBorder: border,
                      ),
                    )
                  ),
                  const SizedBox(width: 16,),
                  Expanded(
                      child: TextField(
                        controller: applyFilterCubit.maxPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.maximumPrice.tr(),
                          hintStyle: context.currentTextTheme.displaySmall?.copyWith(fontSize: 16, color: AppColors.secondaryFontColor),
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                          filled: true,
                          isDense: true,
                          fillColor: AppColors.whiteColor,
                          border: border,
                          enabledBorder: border,
                          disabledBorder: border,
                          focusedBorder: border,
                        ),
                      )
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.distance.tr(),
                    style: context.currentTextTheme.labelLarge,
                  ),
                  // Text(
                  //   TempLanguage().lblSetManually,
                  //   style: context.currentTextTheme.displaySmall?.copyWith(color: AppColors.primaryColor),
                  // ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: applyFilterCubit.distanceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.distance.tr(),
                          hintStyle: context.currentTextTheme.displaySmall?.copyWith(fontSize: 16, color: AppColors.secondaryFontColor),
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                          filled: true,
                          isDense: true,
                          fillColor: AppColors.whiteColor,
                          border: border,
                          enabledBorder: border,
                          disabledBorder: border,
                          focusedBorder: border,
                        ),
                      )
                  ),
                  const SizedBox(width: 16,),
                  Text(LocaleKeys.miles.tr()),
                  const Spacer(),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: ContextExtension(context).width,
                child: AppButton(
                  text: LocaleKeys.apply.tr(),
                  elevation: 0.0,
                  enabled: !userCubit.state.isGuest,
                  disabledColor: AppColors.greyColor,
                  onTap: () {
                     context.read<ApplyFilterCubit>().applyFilter();
                     final navPosition = context.read<NavPositionCubit>();

                     if (navPosition.state.name == SearchTab.deal.name) {
                       itemFilter(context, applyFilterCubit);
                       dealFilter(context, applyFilterCubit);
                     } else {
                       itemFilter(context, applyFilterCubit);
                     }
                    context.pop();
                  },
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  textStyle: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void itemFilter(BuildContext context, ApplyFilterCubit applyFilterCubit) {
    context.read<FilterItemsCubit>().filterItems(
        applyFilterCubit.minPriceController.text.isEmpty ? 1.0 : double.parse(applyFilterCubit.minPriceController.text),
        applyFilterCubit.maxPriceController.text.isEmpty ? 1000.0 : double.parse(applyFilterCubit.maxPriceController.text),
        context.read<LocalItemsStorage>().state.keys.toList(),
        context.read<LocalItemsStorage>().state.values.toList(),
        applyFilterCubit.distanceController.text.isEmpty ? 10.0 : double.parse(applyFilterCubit.distanceController.text)
    );
  }

  void dealFilter(BuildContext context, ApplyFilterCubit applyFilterCubit) {
    context.read<FilterDealsCubit>().filterDeals(
        applyFilterCubit.minPriceController.text.isEmpty ? 1.0 : double.parse(applyFilterCubit.minPriceController.text),
        applyFilterCubit.maxPriceController.text.isEmpty ? 1000.0 : double.parse(applyFilterCubit.maxPriceController.text),
        context.read<LocalDealsStorage>().state.keys.toList(),
        context.read<LocalDealsStorage>().state.values.toList(),
        applyFilterCubit.distanceController.text.isEmpty ? 10.0 : double.parse(applyFilterCubit.distanceController.text)
    );
  }
}
