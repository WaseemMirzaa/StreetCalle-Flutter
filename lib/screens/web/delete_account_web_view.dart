import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/utils/constant/constants.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';


class DeleteAccountWebView extends StatelessWidget {
  const DeleteAccountWebView({super.key});

  @override
  Widget build(BuildContext context) {
    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(
        const PlatformWebViewControllerCreationParams());
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://street-calle-72cff.web.app/'));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TempLanguage().lblDeleteAccount,
          style: context.currentTextTheme.titleMedium?.copyWith(color: AppColors.primaryFontColor, fontSize: 20),
        ),
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(AppAssets.backIcon, width: 20, height: 20,)
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
        child: WebViewWidget(
          controller: controller,// Enable JavaScript
        ),
      ),
    );
  }
}
