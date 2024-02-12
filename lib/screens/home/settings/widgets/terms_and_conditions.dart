import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:street_calle/utils/extensions/context_extension.dart';
import 'package:street_calle/utils/constant/app_assets.dart';
import 'package:street_calle/utils/constant/app_colors.dart';
import 'package:street_calle/utils/constant/temp_language.dart';
import 'package:webview_flutter/webview_flutter.dart';


class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(
        const PlatformWebViewControllerCreationParams());
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://sites.google.com/view/wa-direct-without-saving/home'));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          TempLanguage().lblTermsAndConditions,
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
      body:  WebViewWidget(
      controller: controller,// Enable JavaScript
      ),
    );
    //   Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 40),
    //     child: SingleChildScrollView(
    //       child: Text(
    //         TempLanguage().lblLorem,
    //         textAlign: TextAlign.justify,
    //       ),
    //     ),
    //   ),
    // );
  }
}
