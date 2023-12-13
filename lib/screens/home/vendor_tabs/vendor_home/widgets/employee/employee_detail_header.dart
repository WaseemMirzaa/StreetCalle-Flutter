import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:street_calle/utils/extensions/string_extensions.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/widgets/address_widget.dart';
import 'package:street_calle/widgets/category_widget.dart';

class EmployeeDetailHeader extends StatelessWidget {
  const EmployeeDetailHeader({Key? key, required this.user}) : super(key: key);
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20)),
          clipBehavior: Clip.hardEdge,
          child:
          CachedNetworkImage(
            imageUrl: user?.image ?? '',
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
                      '${user?.name?.capitalizeEachFirstLetter()}',
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
              AddressWidget(latitude: user?.latitude, longitude: user?.longitude,),
              const SizedBox(
                height: 6,
              ),
              const CategoryWidget(),
            ],
          ),
        ),
      ],
    );
  }
}