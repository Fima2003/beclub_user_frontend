part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {

  final Password password;
  bool get passwordCorrect => password.valid;
  final Username username;
  bool get usernameCorrect => username.valid;
  final Name firstName;
  bool get firstNameCorrect => firstName.valid;
  final Name lastName;
  bool get lastNameCorrect => lastName.valid;
  final Email email;
  bool get emailCorrect => email.valid;
  final DateTime? birth;
  bool get birthCorrect => DateTime.now().difference(birth!).inDays / 365 > 18;
  final String gender;
  final FormzStatus status;
  final String error;
  final List<String> categories;


  const SignUpState({
    this.password = const Password.pure(),
    this.username = const Username.pure(),
    this.firstName = const Name.pure(),
    this.lastName = const Name.pure(),
    this.email = const Email.pure(),
    this.birth,
    this.status = FormzStatus.pure,
    this.error = "",
    this.gender = "Male",
    this.categories = const []
  });

  SignUpState copyWith(
      {Password? password,
      Username? username,
      Name? firstName,
      Name? lastName,
      Email? email,
      DateTime? birth,
      FormzStatus? status,
      String? gender,
      String? error,
      List<String>? categories}){
    return SignUpState(
      password: password ?? this.password,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      birth: birth ?? this.birth,
      status: status ?? this.status,
      gender: gender ?? this.gender,
      error: error ?? this.error,
      categories: categories ?? this.categories
    );
  }

  Map<String, dynamic> toJson() => {
    "nick": username.value,
    "email": email.value,
    "password": password.value,
    "first_name": firstName.value,
    "last_name": lastName.value,
    "date_of_birth": birth?.toIso8601String(),
    "preferences": categories.join(','),
    "gender": gender
  };

  @override
  List<Object?> get props => [username, password, status, error, email, firstName, lastName, birth, gender, categories];

}