import 'package:flutter/material.dart';
import 'package:street_calle/screens/auth/widgets/custom_text_field.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_colors.dart';


class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40,),
                Text(
                  TempLanguage().lblSignUp,
                  style: context.currentTextTheme.titleMedium?.copyWith(fontFamily: METROPOLIS_MEDIUM),
                ),
                const SizedBox(height: 10,),
                Text(
                  TempLanguage().lblAddYourSignDetails,
                  style: context.currentTextTheme.labelSmall?.copyWith(fontSize: 14),
                ),

                const SizedBox(height: 24,),
                Container(
                  padding: const EdgeInsets.all(26),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor
                  ),
                  child: const Icon(Icons.image_outlined, color: AppColors.whiteColor,),
                ),
                const SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomTextField(
                    hintText: TempLanguage().lblName,
                    keyboardType: TextInputType.name,
                    asset: AppAssets.person,
                    controller: _nameController,
                    isPassword: true,
                  ),
                ),
                const SizedBox(height: 24,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomTextField(
                    hintText: TempLanguage().lblEmail,
                    keyboardType: TextInputType.emailAddress,
                    asset: AppAssets.emailIcon,
                    controller: _emailController,
                    isPassword: false,
                  ),
                ),
                const SizedBox(height: 24,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomTextField(
                    hintText: TempLanguage().lblPhone,
                    keyboardType: TextInputType.phone,
                    asset: AppAssets.phone,
                    controller: _phoneController,
                    isPassword: false,
                  ),
                ),
                const SizedBox(height: 24,),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomTextField(
                    hintText: TempLanguage().lblPassword,
                    keyboardType: TextInputType.visiblePassword,
                    asset: AppAssets.passwordIcon,
                    controller: _passwordController,
                    isPassword: true,
                  ),
                ),
                const SizedBox(height: 24,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomTextField(
                    hintText: TempLanguage().lblConfirmPassword,
                    keyboardType: TextInputType.visiblePassword,
                    asset: AppAssets.passwordIcon,
                    controller: _confirmPasswordController,
                    isPassword: true,
                  ),
                ),
                const SizedBox(height: 24,),

                SizedBox(
                  width: context.width,
                  height: defaultButtonSize,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: (){

                    },
                    child: Text(
                      TempLanguage().lblSignUp,
                      style: context.currentTextTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
                    ),
                  ),
                ),
                const SizedBox(height: 24,),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: TempLanguage().lblAlreadyhaveAccount,
                          style: context.currentTextTheme.labelSmall
                      ),
                      TextSpan(
                          text: TempLanguage().lblLogin,
                          style: context.currentTextTheme.labelSmall?.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
