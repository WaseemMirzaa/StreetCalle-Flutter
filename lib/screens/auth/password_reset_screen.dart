import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:street_calle/screens/auth/cubit/forget_password/forget_password_cubit.dart';
import 'package:street_calle/screens/auth/widgets/custom_text_field.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/generated/locale_keys.g.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultVerticalPadding, horizontal: defaultHorizontalPadding),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20,),
                    Text(
                      //TempLanguage().lblResetPassword,
                      LocaleKeys.resetPassword.tr(),
                      style: context.currentTextTheme.titleMedium,
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        //TempLanguage().lblPleaseEnterEmailQuote,
                        LocaleKeys.pleaseEnterEmailQuote.tr(),
                        style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 15, color: AppColors.secondaryFontColor),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),

                    CustomTextField(
                     // hintText: TempLanguage().lblEmail,
                      hintText: LocaleKeys.email.tr(),
                      keyboardType: TextInputType.emailAddress,
                      asset: AppAssets.emailIcon,
                      controller: context.read<PasswordResetCubit>().emailController,
                      isSmall: false,
                    ),
                    const SizedBox(height: 24,),

                    BlocConsumer<PasswordResetCubit, PasswordResetState>(
                      listener: (context, state) {
                        if (state is PasswordResetSuccess) {
                          showToast(context, LocaleKeys.pleaseCheckYourEmail.tr());
                        } else if (state is PasswordResetFailure) {
                          showToast(context, state.error);
                        }
                      },
                      builder: (context, state) {
                        return state is PasswordResetLoading
                            ? const CircularProgressIndicator(color: AppColors.primaryColor,)
                            : SizedBox(
                          width: context.width,
                          height: defaultButtonSize,
                          child: AppButton(
                            //text: TempLanguage().lblSend,
                            text: LocaleKeys.send.tr(),
                            elevation: 0.0,
                            onTap: () {
                              hideKeyboard(context);
                              resetPassword(context);
                            },
                            shapeBorder: RoundedRectangleBorder(
                                side: const BorderSide(color: AppColors.primaryColor),
                                borderRadius: BorderRadius.circular(30)
                            ),
                            textStyle: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                            color: AppColors.primaryColor,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: context.width / 2.6,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        //text: TempLanguage().lblBackTo,
                        text: LocaleKeys.backTo.tr(),
                        style: context.currentTextTheme.labelSmall
                    ),
                    TextSpan(
                        //text: TempLanguage().lblLogin,
                        text: LocaleKeys.login.tr(),
                        style: context.currentTextTheme.labelSmall?.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()..onTap = () => context.pop(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> resetPassword(BuildContext context) async {
    final resetPasswordCubit = context.read<PasswordResetCubit>();
    final email = resetPasswordCubit.emailController.text;

    if (email.isEmpty || !email.validateEmailEnhanced()) {
      //showToast(context, TempLanguage().lblEnterYourEmail);
      showToast(context, LocaleKeys.enterYourEmail.tr());
    } else {
      resetPasswordCubit.resetPassword();
    }
  }
}
