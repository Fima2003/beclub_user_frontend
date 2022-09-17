part of 'login_bloc.dart';

class LoginState extends Equatable {
  final Password password;
  bool get passwordCorrect => password.valid;
  final UsernameEmail usernameEmail;
  bool get usernameEmailCorrect => usernameEmail.valid;
  final FormzStatus status;
  final String error;

  const LoginState({
    this.usernameEmail = const UsernameEmail.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.error = ""
  });

  LoginState copyWith({Password? password, UsernameEmail? usernameEmail, FormzStatus? status, String? error}){
    return LoginState(
      usernameEmail: usernameEmail ?? this.usernameEmail,
      password: password ?? this.password,
      status: status ?? this.status,
      error: error ?? this.error
    );
  }

  Map<String, dynamic> toJson() => {
    "nick": usernameEmail.value,
    "password": password.value
  };

  @override
  List<Object> get props => [usernameEmail, password, status];
}
