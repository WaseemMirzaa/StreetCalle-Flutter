
part of 'guest_cubit.dart';

abstract class GuestState {}

class GuestLoginInitial extends GuestState {}

class GuestLoginLoading extends GuestState {}

class GuestLoginSuccess extends GuestState {
  final User user;

  GuestLoginSuccess(this.user);
}

class GuestLoginFailure extends GuestState {
  final String error;

  GuestLoginFailure(this.error);
}