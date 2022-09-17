import 'package:formz/formz.dart';

enum EmailValidationError { invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure([super.value = '']) : super.pure();
  const Email.dirty([super.value = '']) : super.dirty();

  // Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character:
  static final _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  @override
  EmailValidationError? validator(String? value) {
    return _emailRegex.hasMatch(value!) ? null : EmailValidationError.invalid;
  }
}