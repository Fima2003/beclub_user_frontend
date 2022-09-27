import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/repoClass/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState()) {
    on<UserEventNameChanged>(_onUserEventNameChanged);
    on<UserEventNickChanged>(_onUserEventNickChanged);
    on<UserEventEmailChanged>(_onUserEventEmailChanged);
    on<UserEventManyFieldsChanged>(_onUserEventManyFieldsChanged);
  }

  _onUserEventNameChanged(UserEventNameChanged event, Emitter<UserState> emit){
    final String name = event.name;
    emit(state.copyWith(name: name));
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
    emit(state.copyWith(name: user.name, nick: user.nick, email: user.email));
  }
}
