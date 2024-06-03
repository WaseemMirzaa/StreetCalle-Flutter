import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/generated/locale_keys.g.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';
import 'package:street_calle/screens/auth/cubit/timer/timer_cubit.dart';
import 'package:street_calle/dependency_injection.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  Widget build(BuildContext context) {
    final authService = sl.get<AuthService>();
    final timerCubit = context.read<TimerCubit>();
    timerCubit.start();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: defaultVerticalPadding,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              child: Text(
                //TempLanguage().lblSendVerificationEmail,
                LocaleKeys.sendVerificationEmail.tr(),
                textAlign: TextAlign.center,
                style: context.currentTextTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 54.0),
              child: Column(
                children: [
                  Text(
                    //TempLanguage().lblPleaseCheckYourEmail,
                    LocaleKeys.pleaseCheckYourEmail.tr(),
                    style: context.currentTextTheme.labelSmall!.copyWith(fontSize: 15, color: AppColors.secondaryFontColor),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: email,
                          style: context.currentTextTheme.labelSmall!.copyWith(fontSize: 13, color: AppColors.secondaryFontColor),
                        ),
                        TextSpan(
                          //text: TempLanguage().lblToVerify,
                          text: LocaleKeys.toVerify.tr(),
                          style: context.currentTextTheme.labelSmall!.copyWith(fontSize: 13, color: AppColors.secondaryFontColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 130,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              child: SizedBox(
                width: context.width,
                height: defaultButtonSize,
                child: AppButton(
                  //text: TempLanguage().lblContinue,
                  text: LocaleKeys.continueText.tr(),
                  elevation: 0.0,
                  onTap: () async {
                    final result = await authService.isUserEmailVerified();
                    if (!context.mounted) return;
                    if (result) {
                      if (timerCubit.state != 0) {
                        timerCubit.stop();
                      }
                      context.read<UserCubit>().setIsLoggedIn(true);
                      context.goNamed(AppRoutingName.selectUserScreen);
                    } else {
                      //showToast(context, TempLanguage().lblVerifyYourEmail);
                      showToast(context, LocaleKeys.verifyYourEmail.tr());
                    }
                  },
                  shapeBorder: RoundedRectangleBorder(
                      side: const BorderSide(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  textStyle: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                  color: AppColors.primaryColor,
                ),

              ),
            ),
            const SizedBox(height: 28,),

            BlocBuilder<TimerCubit, int>(
              builder: (context, state) {
                return  Text(
                  '0:$state',
                  textAlign: TextAlign.center,
                  style: context.currentTextTheme.labelMedium?.copyWith(color: AppColors.primaryColor,),
                );
              },
            ),


            const SizedBox(height: 44,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        //text: TempLanguage().lblDidNotReceive,
                        text: LocaleKeys.didNotReceive.tr(),
                        style: context.currentTextTheme.labelSmall!.copyWith(fontSize: 14, color: AppColors.secondaryFontColor),
                    ),
                    TextSpan(
                      //text: TempLanguage().lblSendAgain,
                      text: LocaleKeys.sendAgain.tr(),
                      style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 14, color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        if (timerCubit.state == 0) {
                          authService.sendEmailVerificationAgain();
                          //showToast(context, TempLanguage().lblPleaseCheckYourEmail);
                          showToast(context, LocaleKeys.pleaseCheckYourEmail.tr());
                          timerCubit.resetAndStartTimer(60);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
