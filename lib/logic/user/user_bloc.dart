import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/repoClass/dio_client.dart';
import '../../models/repoClass/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<UserEventNickChanged>(_onUserEventNickChanged);
    on<UserEventEmailChanged>(_onUserEventEmailChanged);
    on<UserEventManyFieldsChanged>(_onUserEventManyFieldsChanged);
    on<UserEventFetchInformation>(_onUserEventFetchInformation);
  }

  _onUserEventNickChanged(UserEventNickChanged event, Emitter<UserState> emit){
    final String nick = event.nick;
    emit(state.copyWith(nick: nick));
  }

  _onUserEventEmailChanged(UserEventEmailChanged event, Emitter<UserState> emit){
    final String email = event.email;
    emit(state.copyWith(email: email));
  }

  _onUserEventManyFieldsChanged(UserEventManyFieldsChanged event, Emitter<UserState> emit){
    final User user = event.user;
    emit(state.copyWith(nick: user.nick, email: user.email));
  }

  _onUserEventFetchInformation(UserEventFetchInformation event, Emitter<UserState> emit) async{
    User result = await DioClient().getSelf();
    if(result != User.unknown()){
      emit(
        state.copyWith(nick: result.nick, email: result.email)
      );
    }else{
      emit(
        state.copyWith(error: "Could not obtain needed data")
      );
    }
  }
}
