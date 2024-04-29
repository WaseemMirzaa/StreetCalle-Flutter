part of 'apple_login_cubit.dart';



class AppleeLoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppleeLoginInitial extends AppleeLoginState {
  @override
  List<Object?> get props => [];
}

class AppleeLoginLoading extends AppleeLoginState {
  @override
  List<Object?> get props => [];
}

class AppleeLoginSuccess extends AppleeLoginState {
  final User user;
  final bool isEmailVerified;

  AppleeLoginSuccess(this.user, this.isEmailVerified);

  @override
  List<Object?> get props => [user];
}

class AppleeLoginFailure extends AppleeLoginState {
  final String error;

  AppleeLoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}
