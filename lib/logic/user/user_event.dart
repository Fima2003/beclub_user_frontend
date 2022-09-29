part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {}

class UserEventNickChanged extends UserEvent{
  final String nick;

  UserEventNickChanged(this.nick);

  @override
  List<Object?> get props => [nick];
}

class UserEventEmailChanged extends UserEvent{
  final String email;

  UserEventEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class UserEventManyFieldsChanged extends UserEvent{
  final User user;

  UserEventManyFieldsChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class UserEventFetchInformation extends UserEvent{
  @override
  List<Object?> get props => [];

}