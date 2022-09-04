import 'package:formz/formz.dart';

enum UsernameValidationError { invalid }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure([super.value = '']) : super.pure();
  const Username.dirty([super.value = '']) : super.dirty();

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static final _usernameRegex = RegExp(
      r'^[a-zA-Z0-9._]+$'
  );

  @override
  UsernameValidationError? validator(String? value) {
    return _emailRegex.hasMatch(value ?? '') || _usernameRegex.hasMatch(value ?? '')
        ? null
        : UsernameValidationError.invalid;
  }
}