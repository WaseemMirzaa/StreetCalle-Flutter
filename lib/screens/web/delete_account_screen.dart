import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/services/auth_service.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/screens/auth/widgets/custom_text_field.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/common.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {

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
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              TempLanguage().lblDeleteAccount,
              style: context.currentTextTheme.titleMedium,
            ),
            const SizedBox(height: 50,),
            SizedBox(
              width: 400,
              child: CustomTextField(
                hintText: TempLanguage().lblEmail,
                keyboardType: TextInputType.emailAddress,
                asset: AppAssets.emailIcon,
                controller: _emailController,
                isSmall: false,
                isDecor: false,
              ),
            ),
            const SizedBox(height: 24,),
            SizedBox(
              width: 400,
              child: CustomTextField(
                hintText: TempLanguage().lblPassword,
                keyboardType: TextInputType.visiblePassword,
                asset: AppAssets.passwordIcon,
                controller: _passwordController,
                isSmall: true,
                isObscure: true,
                isDecor: false,
              ),
            ),
            const SizedBox(height: 24,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              child: SizedBox(
                width: 400,
                height: defaultButtonSize,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AppButton(
                  text: TempLanguage().lblDelete,
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
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> deleteAccount() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    AuthService authService = AuthService();

    if (email.isEmpty || !email.validateEmailEnhanced()) {
      showToast(context, TempLanguage().lblEnterYourEmail);
    } else if (password.isEmpty || password.toString().length < 6) {
      showToast(context, TempLanguage().lblPasswordMustBeGreater);
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
              showToast(context, r);
              if(!kIsWeb) {
                Navigator.pop(context, true);
              }
            } else {
              showToast(context, TempLanguage().lblErrorDuringDeleteAccount);
            }
            setState(() {
              isLoading = false;
            });
          }
      );
    }
  }
}
