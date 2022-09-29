import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable{

  final String nick;
  final String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
    nick: json['nick'],
    email: json['email'],
  );

  factory User.fromString(String str) => User.fromJson(jsonDecode(str));

  Map<String, dynamic> toJson() => {
    nick: nick,
    email: email,
  };

  const User({required this.nick, required this.email});

  factory User.unknown() => const User(nick: "", email: "");

  @override
  String toString() {
    return "nick: $nick\nemail: $email";
  }

  @override
  List<Object?> get props => [nick, email];
}