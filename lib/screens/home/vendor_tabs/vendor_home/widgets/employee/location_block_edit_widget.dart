import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/models/user.dart';
import 'package:street_calle/dependency_injection.dart';

class LocationBlockEditWidget extends StatefulWidget {
  const LocationBlockEditWidget({Key? key, this.user}) : super(key: key);
  final User? user;

  @override
  State<LocationBlockEditWidget> createState() =>
      _LocationBlockEditWidgetState();
}

class _LocationBlockEditWidgetState extends State<LocationBlockEditWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userService = sl.get<UserService>();
    return Positioned(
      bottom: 20,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: widget.user?.isEmployeeBlocked ?? false
            ? isLoading
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  )
                : AppButton(
                    text: TempLanguage().lblUnblock,
                    textColor: AppColors.whiteColor,
                    onTap: () async {
                      if (widget.user != null) {
                        setState(() {
                          isLoading = true;
                        });
                        userService.updateEmployeeBlockStatus(widget.user!.uid!, false).then((value){
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                        });
                      }
                    },
                    width: context.width,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: AppColors.redColor,
                  )
            : Row(
                children: [
                  isLoading
                      ? const CircularProgressIndicator()
                      : GestureDetector(
                          onTap: () async {
                            if (widget.user != null) {
                              setState(() {
                                isLoading = true;
                              });
                              userService.updateEmployeeBlockStatus(widget.user!.uid!, true).then((value){
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pop(context);
                              });
                            }
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
                    child: SizedBox(
                      width: context.width,
                      height: defaultButtonSize,
                      child: AppButton(
                        elevation: 0.0,
                        onTap: () {
                          context.pushNamed(AppRoutingName.addEmployeeMenuItems,
                              extra: widget.user);
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
                                  ?.copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}