import 'package:formz/formz.dart';

enum UsernameValidationError { invalid }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure([super.value = '']) : super.pure();
  const Username.dirty([super.value = '']) : super.dirty();

  static final _usernameRegex = RegExp(
      r'^[a-z0-9._]{3,12}$'
  );

  @override
  UsernameValidationError? validator(String? value) {
    return _usernameRegex.hasMatch(value ?? '')
        ? null
        : UsernameValidationError.invalid;
  }
}