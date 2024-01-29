import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:street_calle/services/stripe_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:street_calle/main.dart';
import 'package:street_calle/cubit/user_state.dart';
import 'package:street_calle/services/user_service.dart';


class CheckOutPage extends StatefulWidget {
  const CheckOutPage({
    Key? key,
    required this.sessionId,
    required this.planLookUpKey,
    required this.url,
    required this.userCubit,
    required this.userService,
    required this.subscriptionType,
    //this.aPiCallback
  }) : super(key: key);

  final String sessionId;
  final String planLookUpKey;
  final String url;
  final UserService userService;
  final UserCubit userCubit;
  final String subscriptionType;
 // final APiCallback aPiCallback;

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  late WebViewController _webViewController;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            if (!_isLoaded) _redirectToStripe(widget.sessionId);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains('success')) {
              final data = await StripeService.getSessionData(widget.sessionId);
              if (data['status'] == 'complete' || data['status'] == 'paid') {
                await widget.userService.updateUserStripeDetails(data['customer'], data['subscription'], widget.sessionId, widget.userCubit.state.userId);
                syncUserSubscriptionStatus(widget.userService, widget.userCubit, true, widget.subscriptionType, widget.planLookUpKey, data['subscription'], widget.sessionId, data['customer']);
              }
              if (!context.mounted) return NavigationDecision.navigate;
              //widget.aPiCallback.call(true);
              Navigator.pop(context);
            } else if (request.url.contains('cancel')) {
              if (!context.mounted) return NavigationDecision.navigate;
              //widget.aPiCallback.call(false);
              Navigator.pop(context);
            }
            return NavigationDecision.navigate;
          },
        ),
      )..loadRequest(Uri.parse(widget.url));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SafeArea(
            child: WebViewWidget(controller: _webViewController,),
          ),
        ],
      ),
    );
  }

  Future<void> _redirectToStripe(String sessionId) async {
    final redirectToCheckoutJs = '''
            var stripe = Stripe(\'$PUBLISH_KEY\');
            stripe.redirectToCheckout({
              sessionId: '$sessionId'
            }).then(function (result) {
              result.error.message = 'Error'
            });
      ''';

    try {
      await _webViewController
          .runJavaScriptReturningResult(redirectToCheckoutJs);
      setState(() {
        _isLoaded = true;
      });
    } on PlatformException catch (e) {
      log('platform error');
      if (!e.details.contains(
          'JavaScript execution returned a result of an unsupported type')) {
        rethrow;
      }
    }
  }

  Future<void> syncUserSubscriptionStatus(
      UserService userService,
      UserCubit userCubit,
      bool isSubscribed,
      String subscriptionType,
      String planLookUpKey,
      String subscriptionId,
      String sessionId,
      String customerId
      ) async {

    final result = await userService.updateUserSubscription(isSubscribed, subscriptionType, userCubit.state.userId, planLookUpKey);
    if (result) {
      userCubit.setSubscriptionId(subscriptionId);
      userCubit.setSessionId(sessionId);
      userCubit.setStripeId(customerId);
      userCubit.setIsSubscribed(isSubscribed);
      userCubit.setSubscriptionType(subscriptionType);
      userCubit.setPlanLookUpKey(planLookUpKey);
    }
  }
}