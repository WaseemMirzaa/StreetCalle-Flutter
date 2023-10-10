import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/cubit/food_type_expanded_cubit.dart';
import 'package:street_calle/screens/home/vendor_tabs/vendor_home/widgets/food_type_drop_down.dart';

class FoodTypeExpandedWidget extends StatelessWidget {
  const FoodTypeExpandedWidget({Key? key, required this.isFromItem}) : super(key: key);
  final bool isFromItem;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodTypeExpandedCubit, bool>(
      builder: (context, state) {
        return state
            ? Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  context.read<FoodTypeExpandedCubit>().collapse();
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            FoodTypeDropDown(isFromItem: isFromItem),
          ],
        )
            : const SizedBox.shrink();
      },
    );
  }
}