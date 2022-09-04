part of 'login_bloc.dart';

class LoginState extends Equatable {
  final Password password;
  bool get passwordCorrect => password.valid;
  final Username username;
  bool get usernameCorrect => username.valid;
  final FormzStatus status;
  final String error;

  const LoginState({
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.error = ""
  });

  LoginState copyWith({Password? password, Username? username, FormzStatus? status, String? error}){
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status,
      error: error ?? this.error
    );
  }

  @override
  List<Object> get props => [username, password, status];
}
