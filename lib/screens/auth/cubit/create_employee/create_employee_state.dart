part of 'create_employee_cubit.dart';

abstract class CreateEmployeeState {}

class SignUpInitial extends CreateEmployeeState {}

class SignUpLoading extends CreateEmployeeState {}

class SignUpSuccess extends CreateEmployeeState {
  final User user;

  SignUpSuccess(this.user);
}

class SignUpFailure extends CreateEmployeeState {
  final String error;

  SignUpFailure(this.error);
}