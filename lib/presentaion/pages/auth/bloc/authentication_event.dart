part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class LoginEvent extends AuthenticationEvent {
  const LoginEvent({this.username, this.password});
  final String? username;
  final String? password;
  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthenticationEvent {
  const RegisterEvent({this.requestModel});
  final LoginRequest? requestModel;
  @override
  List<Object?> get props => [];
}

class RequestOTPEvent extends AuthenticationEvent {
  const RequestOTPEvent({this.phone, this.countryCode, this.countryISOCode});
  final String? phone;
  final String? countryCode;
  final String? countryISOCode;
  @override
  List<Object?> get props => [];
}

class UpdateUserLanguageEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class GetProfileEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class UpdateProfileEvent extends AuthenticationEvent {
  const UpdateProfileEvent({required this.requestModel});
  final LoginRequest? requestModel;
  @override
  List<Object?> get props => [];
}

class UpdateProfilePhotoEvent extends AuthenticationEvent {
  const UpdateProfilePhotoEvent({required this.photo});
  final File photo;
  @override
  List<Object?> get props => [];
}

class ForgotPasswordEvent extends AuthenticationEvent {
  const ForgotPasswordEvent({required this.email});
  final String email;
  @override
  List<Object?> get props => [];
}

class NavigateToNewTasksEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class LogoutEvent extends AuthenticationEvent {
  const LogoutEvent({required this.apiRequest, this.model});
  final LogoutRequest? model;
  final bool apiRequest;
  @override
  List<Object?> get props => [model];
}
