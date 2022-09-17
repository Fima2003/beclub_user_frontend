import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../models/formzModels/models.dart';
import '../../constants/responses/sign_up_responses.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState()) {
    on<SignUpEmailChange>(_onSignUpEmailChange);
    on<SignUpUsernameChange>(_onSignUpUsernameChange);
    on<SignUpPasswordChange>(_onSignUpPasswordChange);
    on<SignUpFirstNameChange>(_onSignUpFirstNameChange);
    on<SignUpLastNameChange>(_onSignUpLastNameChange);
    on<SignUpDateChange>(_onSignUpDateChange);
    on<SignUpGenderChange>(_onSignUpGenderChange);
    on<SignUpCategoriesChange>(_onSignUpCategoriesChange);
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<SignUpError>(_onSignUpError);
  }

  _onSignUpDateChange(SignUpDateChange event, Emitter<SignUpState> emit){
    final birth = event.birth;
    emit(
      state.copyWith(birth: birth, error: "")
    );
  }

  _onSignUpPasswordChange(SignUpPasswordChange event, Emitter<SignUpState> emit){
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(password: password, status: Formz.validate([password, state.username, state.email, state.firstName, state.lastName]), error: "")
    );
  }

  _onSignUpUsernameChange(SignUpUsernameChange event, Emitter<SignUpState> emit){
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(username: username, status: Formz.validate([state.password, username, state.email, state.firstName, state.lastName]), error: "")
    );
  }

  _onSignUpEmailChange(SignUpEmailChange event, Emitter<SignUpState> emit){
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(email: email, status: Formz.validate([state.password, state.username, email, state.firstName, state.lastName]), error: "")
    );
  }

  _onSignUpFirstNameChange(SignUpFirstNameChange event, Emitter<SignUpState> emit){
    final firstName = Name.dirty(event.firstName);
    emit(
      state.copyWith(firstName: firstName, status: Formz.validate([state.password, state.username, state.email, firstName, state.lastName]), error: "")
    );
  }

  _onSignUpLastNameChange(SignUpLastNameChange event, Emitter<SignUpState> emit){
    final lastName = Name.dirty(event.lastName);
    emit(
        state.copyWith(lastName: lastName, status: Formz.validate([state.password, state.username, state.email, state.firstName, lastName]), error: "")
    );
  }

  _onSignUpGenderChange(SignUpGenderChange event, Emitter<SignUpState> emit){
    final gender = event.gender;
    emit(
        state.copyWith(gender: gender, error: "")
    );
  }

  _onSignUpCategoriesChange(SignUpCategoriesChange event, Emitter<SignUpState> emit){
    final categories = event.categories;
    emit(
      state.copyWith(categories: categories)
    );
  }

  _onSignUpSubmitted(SignUpSubmitted event, Emitter<SignUpState> emit) async {
    final username = Username.dirty(state.username.value);
    final password = Password.dirty(state.password.value);
    final email = Email.dirty(state.email.value);
    final firstName = Name.dirty(state.firstName.value);
    final lastName = Name.dirty(state.lastName.value);
    emit(
      state.copyWith(
        username: username,
        password: password,
        email: email,
        firstName: firstName,
        lastName: lastName,
        gender: state.gender,
        birth: state.birth,
        status: Formz.validate([username, password, email, firstName, lastName])
      )
    );
    if(state.status.isValidated){
      emit(
        state.copyWith(status: FormzStatus.submissionInProgress)
      );
      try {
        await Future<void>.delayed(const Duration(seconds: 2));
        emit(
            state.copyWith(status: FormzStatus.submissionSuccess)
        );
      }catch(e){
        emit(state.copyWith(status: FormzStatus.submissionFailure, error: e.toString()));
      }
    }
  }

  _onSignUpError(SignUpError event, Emitter<SignUpState> emit){
    final error = event.error;
    emit(
        state.copyWith(error: error)
    );
  }
}
