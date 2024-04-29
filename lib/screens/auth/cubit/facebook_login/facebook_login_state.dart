part of 'facebook_login_cubit.dart';



class FacebookLoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FacebookLoginInitial extends FacebookLoginState {
  @override
  List<Object?> get props => [];
}

class FacebookLoginLoading extends FacebookLoginState {
  @override
  List<Object?> get props => [];
}

class FacebookLoginSuccess extends FacebookLoginState {
  final User user;
  final bool isEmailVerified;

  FacebookLoginSuccess(this.user, this.isEmailVerified);

  @override
  List<Object?> get props => [user];
}

class FacebookLoginFailure extends FacebookLoginState {
  final String error;

  FacebookLoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}
