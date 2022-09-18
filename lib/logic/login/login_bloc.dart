import 'package:beclub/constants/local_storage.dart';
import 'package:beclub/constants/responses/login_responses.dart';
import 'package:beclub/logic/backend/api_calls.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../../constants/responses/general_responses.dart';
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
        var response = await login(state.toJson());
        var box = Hive.box(localStorageKey);
        box.put(localStorageJWT, response.data['token']);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } on DioError catch(e){
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
            emit(state.copyWith(status: FormzStatus.submissionFailure, error: generalErrorOccurred));
            break;
        }
      } catch(e){
        emit(state.copyWith(status: FormzStatus.submissionFailure, error: generalErrorOccurred));
      }
    }
  }

  _onLoginError(LoginError event, Emitter<LoginState> emit){
    emit(
      state.copyWith(error: event.error)
    );
  }

}