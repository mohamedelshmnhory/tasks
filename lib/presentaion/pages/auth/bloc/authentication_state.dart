part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class ChangePasswordVisibility extends AuthenticationState {
  final bool visible;
  const ChangePasswordVisibility(this.visible);
  @override
  List<Object?> get props => [visible];
}

class LoginSuccess extends AuthenticationState {
  final User? user;
  const LoginSuccess({this.user});

  @override
  List<Object?> get props => [user];
}

class RequestOTPSuccess extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class RequestOTPLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class RegisterSuccess extends AuthenticationState {
  final String message;
  const RegisterSuccess({required this.message});
  @override
  List<Object?> get props => [];
}

class RegisterLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class LogoutSuccess extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationError extends AuthenticationState {
  final String message;
  const AuthenticationError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class GetProfileSuccess extends AuthenticationState {
  GetProfileSuccess(this.user);
  final User user;
  final dateTime = DateTime.now();
  @override
  List<Object?> get props => [dateTime];
}

class ChangePasswordSuccess extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class GetProfileLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class UpdateProfileSuccess extends AuthenticationState {
  const UpdateProfileSuccess();
  @override
  List<Object?> get props => [];
}

class NavigateToNewTasks extends AuthenticationState {
  final DateTime dateTime = DateTime.now();
  @override
  List<Object?> get props => [dateTime];
}

class UpdateProfileLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

final class GetProfessionsLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}


