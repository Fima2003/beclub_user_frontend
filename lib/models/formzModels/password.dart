import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure([super.value = '']) : super.pure();
  const Password.dirty([super.value = '']) : super.dirty();

  // Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character
  static final _passwordRegex =
  RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&_.])[A-Za-z\d@$!%*?&_.]{8,}$");

  @override
  PasswordValidationError? validator(String? value) {
    return _passwordRegex.hasMatch(value!) ? null : PasswordValidationError.invalid;
  }
}