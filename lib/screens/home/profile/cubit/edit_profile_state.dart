part of 'edit_profile_cubit.dart';

abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final User user;

  EditProfileSuccess(this.user);
}

class EditProfileFailure extends EditProfileState {
  final String error;

  EditProfileFailure(this.error);
}