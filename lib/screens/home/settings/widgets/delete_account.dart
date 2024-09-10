import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/screens/auth/widgets/custom_text_field.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/common.dart';
import 'package:street_calle/generated/locale_keys.g.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/dependency_injection.dart';
import 'package:street_calle/services/shared_preferences_service.dart';
import 'package:street_calle/utils/routing/app_routing_name.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    _emailController.text = userCubit.state.userEmail;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          //TempLanguage().lblSubscriptionPlans,
          LocaleKeys.deleteAccount.tr(),
          style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => ContextExtensions(context).pop(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(AppAssets.backIcon, width: 20, height: 20,)
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SizedBox(height: 50,),
              CustomTextField(
                //hintText: TempLanguage().lblEmail,
                hintText: LocaleKeys.email.tr(),
                keyboardType: TextInputType.emailAddress,
                asset: AppAssets.emailIcon,
                controller: _emailController,
                isSmall: false,
                isDecor: false,
                isEnabled: false,
              ),
              const SizedBox(height: 24,),
              CustomTextField(
                //hintText: TempLanguage().lblPassword,
                hintText: LocaleKeys.password.tr(),
                keyboardType: TextInputType.visiblePassword,
                asset: AppAssets.passwordIcon,
                controller: _passwordController,
                isSmall: true,
                isObscure: true,
                isDecor: false,
              ),
              const SizedBox(height: 24,),
              SizedBox(
                width: ContextExtension(context).width,
                height: defaultButtonSize,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AppButton(
                  //text: TempLanguage().lblDelete,
                  text: LocaleKeys.delete.tr(),
                  elevation: 0.0,
                  onTap: () {
                    deleteAccount();
                  },
                  shapeBorder: RoundedRectangleBorder(
                      side: const BorderSide(color: AppColors.redColor),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  textStyle: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                  color: AppColors.redColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteAccount() async {
    final sharedPreferencesService = sl.get<SharedPreferencesService>();
    final userCubit = context.read<UserCubit>();
    final email = _emailController.text;
    final password = _passwordController.text;
    AuthService authService = AuthService();

    if (email.isEmpty || !email.validateEmailEnhanced()) {
      showToast(context, LocaleKeys.enterYourEmail.tr());
    } else if (password.isEmpty || password.toString().length < 6) {
      showToast(context, LocaleKeys.passwordMustBeGreater.tr());
    } else {
      setState(() {
        isLoading = true;
      });

      final firebaseUser = await authService.deleteAccount(email, password);

      _emailController.text = '';
      _passwordController.text = '';

      firebaseUser.fold(
              (l) {
            showToast(context, l);
            setState(() {
              isLoading = false;
            });
          },
              (r) async {
            if (r != null) {
              await sharedPreferencesService.clearSharedPref();
              userCubit.setDefaultState();
              if (context.mounted) {
                context.goNamed(AppRoutingName.authScreen);
              }
            } else {
              showToast(context, LocaleKeys.errorDuringDeleteAccount.tr());
            }
            setState(() {
              isLoading = false;
            });
          }
      );
    }
  }
}
