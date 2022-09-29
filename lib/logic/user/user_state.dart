part of 'user_bloc.dart';

class UserState extends Equatable {

  final String nick, email, error;

  const UserState({this.nick = "", this.email = "", this.error = ""});

  UserState copyWith({String? nick, String? email, String? error}) => UserState(
    nick: nick ?? this.nick,
    email: email ?? this.email,
    error: error ?? this.error
  );

  @override
  List<Object> get props => [nick, email];
}
