part of 'user_bloc.dart';

class UserState extends Equatable {

  final String name, nick, email;

  const UserState({this.name = "", this.nick = "", this.email = ""});

  UserState copyWith({String? name, String? nick, String? email}) => UserState(
    name: name ?? this.name,
    nick: nick ?? this.nick,
    email: email ?? this.email
  );

  @override
  List<Object> get props => [name, nick, email];
}
