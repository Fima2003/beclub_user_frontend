part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpUsernameChange extends SignUpEvent{
  final String username;

  const SignUpUsernameChange(this.username);

  @override
  List<Object?> get props => [username];
}

class SignUpEmailChange extends SignUpEvent{
  final String email;

  const SignUpEmailChange(this.email);

  @override
  List<Object?> get props => [email];
}

class SignUpFirstNameChange extends SignUpEvent{
  final String firstName;

  const SignUpFirstNameChange(this.firstName);

  @override
  List<Object?> get props => [firstName];
}

class SignUpPasswordChange extends SignUpEvent{
  final String password;

  const SignUpPasswordChange(this.password);

  @override
  List<Object?> get props => [password];
}

class SignUpLastNameChange extends SignUpEvent{
  final String lastName;

  const SignUpLastNameChange(this.lastName);

  @override
  List<Object?> get props => [lastName];
}

class SignUpDateChange extends SignUpEvent{
  final DateTime birth;

  const SignUpDateChange(this.birth);

  @override
  List<Object?> get props => [birth];
}

class SignUpGenderChange extends SignUpEvent{
  final String gender;

  const SignUpGenderChange(this.gender);

  @override
  List<Object?> get props => [gender];
}

class SignUpCategoriesChange extends SignUpEvent{
  final List<String> categories;

  const SignUpCategoriesChange(this.categories);

  @override
  List<Object?> get props => [categories];
}

class SignUpSubmitted extends SignUpEvent{}

class SignUpError extends SignUpEvent{
  final String error;

  const SignUpError(this.error);

  @override
  List<Object?> get props => [error];
}