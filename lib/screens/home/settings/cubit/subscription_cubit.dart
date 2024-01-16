import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_calle/services/user_service.dart';
import 'package:street_calle/services/stripe_service.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState>{

  final UserService userService;
  final StripeService stripeService;

  SubscriptionCubit(this.userService, this.stripeService) : super(SubscriptionLoading());

  Future<void> createPaymentIntent(String amount, String stripeId) async {
    emit(SubscriptionLoading());
    try {

      final ephemeralKey = await StripeService.createEphemeralKey(stripeId);
      final paymentIntent = await StripeService.createPaymentIntent(amount, stripeId);
      emit(SubscriptionSuccess(paymentIntent['paymentIntent'], ephemeralKey['ephemeralKey']));

    } catch (e) {
      emit(SubscriptionFailure('$e'));
    }
  }

}