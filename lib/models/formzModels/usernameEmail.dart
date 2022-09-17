import 'package:formz/formz.dart';

enum UsernameEmailValidationError { invalid }

class UsernameEmail extends FormzInput<String, UsernameEmailValidationError> {
  const UsernameEmail.pure([super.value = '']) : super.pure();
  const UsernameEmail.dirty([super.value = '']) : super.dirty();

  @override
  UsernameEmailValidationError? validator(String? value) {
    return value!.trim() != "" ? null : UsernameEmailValidationError.invalid;
  }
}