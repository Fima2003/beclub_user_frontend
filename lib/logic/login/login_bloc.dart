import 'dart:async';

import 'package:beclub/constants/responses/login_responses.dart';
import 'package:dio/dio.dart';

import '../../models/formzModels/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()){
    on<LoginUsernameEmailChange>(_onLoginUsernameEmailChange);
    on<LoginPasswordChange>(_onLoginPasswordChange);
    on<LoginUsernameUnfocused>(_onLoginUsernameUnfocused);
    on<LoginPasswordUnfocused>(_onLoginPasswordUnfocused);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginError>(_onLoginError);
  }

  _onLoginUsernameEmailChange(LoginUsernameEmailChange event, Emitter<LoginState> emit){
    final usernameEmail = UsernameEmail.dirty(event.usernameEmail);
    emit(
      state.copyWith(
        usernameEmail: usernameEmail,
        status: Formz.validate([usernameEmail, state.password]),
        error: ""
      ),
    );
  }

  _onLoginPasswordChange(LoginPasswordChange event, Emitter<LoginState> emit){
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([state.usernameEmail, password]),
        error: ""
      )
    );
  }

  _onLoginUsernameUnfocused(LoginUsernameUnfocused event, Emitter<LoginState> emit){
    final usernameEmail = UsernameEmail.dirty(state.usernameEmail.value);
    emit(
      state.copyWith(
        usernameEmail: usernameEmail,
        status: Formz.validate([usernameEmail, state.password]),
        error: ""
      )
    );
  }

  _onLoginPasswordUnfocused(LoginPasswordUnfocused event, Emitter<LoginState> emit){
    final password = Password.dirty(state.password.value);
    emit(
      state.copyWith(
        usernameEmail: state.usernameEmail,
        status: Formz.validate([state.usernameEmail, password]),
        error: ""
      )
    );
  }

  _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    final usernameEmail = UsernameEmail.dirty(state.usernameEmail.value);
    final password = Password.dirty(state.password.value);
    emit(
      state.copyWith(
        usernameEmail: usernameEmail,
        password: password,
        status: Formz.validate([usernameEmail, password])
      )
    );
    if(state.status.isValidated){
      emit(state.copyWith(
          status: FormzStatus.submissionInProgress
      ));
      try {
        var response = await Dio().post(
          "http://192.168.1.28:8080/api/users/sign_in",
          data: state.toJson(),
        );
        print(response);
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess
        ));
      } on DioError catch(e){
        print(e.response!.statusCode);
        switch(e.response!.statusCode){
          case(404):
            emit(state.copyWith(status: FormzStatus.submissionFailure, error: userDNE));
            break;
          case(700):
            emit(state.copyWith(status: FormzStatus.submissionFailure, error: notAllFieldsAreFilled));
            break;
          case(704):
            emit(state.copyWith(status: FormzStatus.submissionFailure, error: wrongPassword));
            break;
          default:
            emit(state.copyWith(status: FormzStatus.submissionFailure, error: "An error occurred"));
            break;
        }
      } catch(e){
        emit(state.copyWith(status: FormzStatus.submissionFailure, error: "An error occurred"));
      }
    }
  }

  _onLoginError(LoginError event, Emitter<LoginState> emit){
    emit(
      state.copyWith(error: event.error)
    );
  }

}