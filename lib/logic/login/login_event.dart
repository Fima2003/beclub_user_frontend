part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginUsernameChange extends LoginEvent{
  final String username;

  const LoginUsernameChange(this.username);

  @override
  List<Object?> get props => [username];
}

class LoginUsernameUnfocused extends LoginEvent{}

class LoginPasswordChange extends LoginEvent{
  final String password;

  const LoginPasswordChange(this.password);

  @override
  List<Object?> get props => [password];
}

class LoginPasswordUnfocused extends LoginEvent{}

class LoginSubmitted extends LoginEvent{}

class LoginError extends LoginEvent{
  final String error;

  const LoginError(this.error);
}