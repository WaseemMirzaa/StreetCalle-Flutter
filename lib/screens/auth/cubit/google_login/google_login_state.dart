part of 'google_login_cubit.dart';

class GoogleLoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GoogleLoginInitial extends GoogleLoginState {
  @override
  List<Object?> get props => [];
}

class GoogleLoginLoading extends GoogleLoginState {
  @override
  List<Object?> get props => [];
}

class GoogleLoginSuccess extends GoogleLoginState {
  final User user;
  final bool isEmailVerified;

  GoogleLoginSuccess(this.user, this.isEmailVerified);

  @override
  List<Object?> get props => [user];
}

class GoogleLoginFailure extends GoogleLoginState {
  final String error;

  GoogleLoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}
