import 'dart:async';

import '../../models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()){
    on<LoginUsernameChange>(_onLoginUsernameChange);
    on<LoginPasswordChange>(_onLoginPasswordChange);
    on<LoginUsernameUnfocused>(_onLoginUsernameUnfocused);
    on<LoginPasswordUnfocused>(_onLoginPasswordUnfocused);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  _onLoginUsernameChange(LoginUsernameChange event, Emitter<LoginState> emit){
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        status: Formz.validate([username, state.password]),
        error: ""
      ),
    );
  }

  _onLoginPasswordChange(LoginPasswordChange event, Emitter<LoginState> emit){
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([state.username, password]),
        error: ""
      )
    );
  }

  _onLoginUsernameUnfocused(LoginUsernameUnfocused event, Emitter<LoginState> emit){
    final username = Username.dirty(state.username.value);
    emit(
      state.copyWith(
        username: username,
        status: Formz.validate([username, state.password]),
        error: ""
      )
    );
  }

  _onLoginPasswordUnfocused(LoginPasswordUnfocused event, Emitter<LoginState> emit){
    final password = Password.dirty(state.password.value);
    emit(
      state.copyWith(
        username: state.username,
        status: Formz.validate([state.username, password]),
        error: ""
      )
    );
  }

  _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    final username = Username.dirty(state.username.value);
    final password = Password.dirty(state.password.value);
    emit(
      state.copyWith(
        username: username,
        password: password,
        status: Formz.validate([username, password])
      )
    );
    if(state.status.isValidated){
      emit(state.copyWith(
          status: FormzStatus.submissionInProgress
      ));
      try {
        await Future<void>.delayed(const Duration(seconds: 2));
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess
        ));
      }catch(e){
        emit(state.copyWith(status: FormzStatus.submissionFailure, error: e.toString()));
      }
    }
  }

}