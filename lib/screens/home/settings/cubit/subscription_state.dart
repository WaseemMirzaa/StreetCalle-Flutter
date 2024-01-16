part of 'subscription_cubit.dart';

abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionSuccess extends SubscriptionState {
  final String paymentIntent;
  final String ephemeralKey;

  SubscriptionSuccess(this.paymentIntent, this.ephemeralKey);
}

class SubscriptionFailure extends SubscriptionState {
  final String error;

  SubscriptionFailure(this.error);
}